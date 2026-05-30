import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

/// Caso de uso: iniciar sesión.
///
/// Un caso de uso encapsula UNA acción de negocio. Mantiene el ViewModel
/// limpio: el VM no llama al repositorio directamente, llama al caso de uso.
class LoginUseCase {
  final AuthRepository _repository;
  LoginUseCase(this._repository);

  Future<UserEntity> call({
    required String username,
    required String password,
  }) {
    return _repository.login(username: username, password: password);
  }
}
