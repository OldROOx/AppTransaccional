import '../../../../core/network/api_client.dart';
import '../models/user_model.dart';

/// Única clase del feature `auth` que conoce los endpoints concretos.
/// Usa el [ApiClient] (instancia única de http) para hablar con la API.
class AuthRemoteDataSource {
  final ApiClient _api;
  AuthRemoteDataSource(this._api);

  /// POST /api/auth/login  ->  { user, accessToken }
  Future<UserModel> login({
    required String username,
    required String password,
  }) async {
    final data = await _api.post('/auth/login', {
      'username': username,
      'password': password,
    });
    return UserModel.fromAuthResponse(data as Map<String, dynamic>);
  }

  /// POST /api/auth/register  ->  { user, accessToken }
  Future<UserModel> register({
    required String name,
    required String email,
    required String username,
    required String password,
  }) async {
    final data = await _api.post('/auth/register', {
      'name': name,
      'email': email,
      'username': username,
      'password': password,
    });
    return UserModel.fromAuthResponse(data as Map<String, dynamic>);
  }
}
