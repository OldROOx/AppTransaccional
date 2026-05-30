/// Entidad de dominio del usuario.
///
/// Vive en la capa de DOMINIO: es un objeto puro de negocio. No sabe nada de
/// JSON, http, ni Flutter. Las capas exteriores (data, presentation) dependen
/// de esta entidad, nunca al revés.
class UserEntity {
  final String id;
  final String name;
  final String email;
  final String username;

  /// Token devuelto por el login/registro. Null si la entidad se construyó
  /// fuera de un flujo de autenticación.
  final String? accessToken;

  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.username,
    this.accessToken,
  });
}
