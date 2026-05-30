import 'package:flutter/foundation.dart';

import '../../../../core/session/session_manager.dart';
import '../../../../core/state/view_state.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/register_usecase.dart';

/// ViewModel del feature `auth`. Extiende [ChangeNotifier] para que Provider
/// pueda escucharlo. Aquí vive TODO el estado de las pantallas de auth.
class AuthViewModel extends ChangeNotifier {
  final LoginUseCase _loginUseCase;
  final RegisterUseCase _registerUseCase;

  AuthViewModel({
    required LoginUseCase loginUseCase,
    required RegisterUseCase registerUseCase,
  })  : _loginUseCase = loginUseCase,
        _registerUseCase = registerUseCase;

  // ---------------------- ESTADO (ui = f(state)) ----------------------
  ViewState _state = ViewState.idle;
  ViewState get state => _state;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  UserEntity? _user;
  UserEntity? get user => _user;

  bool get isLoading => _state == ViewState.loading;

  // ---------------------- ACCIONES ----------------------
  Future<bool> login({
    required String username,
    required String password,
  }) async {
    _setState(ViewState.loading);
    try {
      _user = await _loginUseCase(username: username, password: password);
      SessionManager().save(token: _user!.accessToken ?? '', user: _user!);
      _setState(ViewState.success);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setState(ViewState.error);
      return false;
    }
  }

  Future<bool> register({
    required String name,
    required String email,
    required String username,
    required String password,
  }) async {
    _setState(ViewState.loading);
    try {
      _user = await _registerUseCase(
        name: name,
        email: email,
        username: username,
        password: password,
      );
      SessionManager().save(token: _user!.accessToken ?? '', user: _user!);
      _setState(ViewState.success);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setState(ViewState.error);
      return false;
    }
  }

  void logout() {
    SessionManager().clear();
    _user = null;
    _setState(ViewState.idle);
  }

  void _setState(ViewState s) {
    _state = s;
    notifyListeners();
  }
}
