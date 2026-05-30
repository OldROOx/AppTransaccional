import '../../domain/entities/user_entity.dart';

/// Modelo de datos del usuario. Extiende la entidad de dominio y le agrega
/// la capacidad de convertirse a/desde el JSON que devuelve nuestro backend
/// (FastAPI en /api/auth/*).
class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
    required super.username,
    super.accessToken,
  });

  /// Construye desde la respuesta de /api/auth/login y /api/auth/register:
  /// `{ user: { id, name, email, username }, accessToken: "..." }`
  factory UserModel.fromAuthResponse(Map<String, dynamic> json) {
    final user = json['user'] as Map<String, dynamic>;
    return UserModel(
      id: user['id'] ?? '',
      name: user['name'] ?? '',
      email: user['email'] ?? '',
      username: user['username'] ?? '',
      accessToken: json['accessToken'],
    );
  }
}
