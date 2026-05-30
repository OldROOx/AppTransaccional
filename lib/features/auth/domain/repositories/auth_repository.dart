import '../entities/user_entity.dart';

/// Contrato del repositorio de autenticación.
/// El dominio define QUÉ se puede hacer; la implementación (data) define CÓMO.
abstract class AuthRepository {
  Future<UserEntity> login({
    required String username,
    required String password,
  });

  Future<UserEntity> register({
    required String name,
    required String email,
    required String username,
    required String password,
  });
}
