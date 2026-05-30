import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

/// Caso de uso: registrar un nuevo usuario.
class RegisterUseCase {
  final AuthRepository _repository;
  RegisterUseCase(this._repository);

  Future<UserEntity> call({
    required String name,
    required String email,
    required String username,
    required String password,
  }) {
    return _repository.register(
      name: name,
      email: email,
      username: username,
      password: password,
    );
  }
}
