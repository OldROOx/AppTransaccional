import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

/// Implementación concreta del [AuthRepository]. Conecta el dominio con la
/// fuente de datos remota. Si mañana se cambia el backend o se agrega cache
/// local, sólo se toca esta clase: dominio y UI ni se enteran.
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remote;
  AuthRepositoryImpl(this._remote);

  @override
  Future<UserEntity> login({
    required String username,
    required String password,
  }) {
    return _remote.login(username: username, password: password);
  }

  @override
  Future<UserEntity> register({
    required String name,
    required String email,
    required String username,
    required String password,
  }) {
    return _remote.register(
      name: name,
      email: email,
      username: username,
      password: password,
    );
  }
}
