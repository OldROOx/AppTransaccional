import '../../features/auth/domain/entities/user_entity.dart';

/// Maneja la sesión activa en memoria (Singleton).
///
/// Guarda el token devuelto por el login y el usuario actual, para que el
/// [ApiClient] pueda agregar el Bearer en cada petición sin que cada feature
/// tenga que pasarlo manualmente.
class SessionManager {
  SessionManager._internal();
  static final SessionManager _instance = SessionManager._internal();
  factory SessionManager() => _instance;

  String? _token;
  UserEntity? _currentUser;

  String? get token => _token;
  UserEntity? get currentUser => _currentUser;
  bool get isLoggedIn => _token != null;

  void save({required String token, required UserEntity user}) {
    _token = token;
    _currentUser = user;
  }

  void clear() {
    _token = null;
    _currentUser = null;
  }
}
