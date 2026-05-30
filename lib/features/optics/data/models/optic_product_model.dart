import '../../domain/entities/optic_product_entity.dart';

/// Modelo de datos. Extiende la entidad de dominio (es-un OpticProductEntity)
/// y agrega serialización JSON contra el backend (/api/optics).
class OpticProductModel extends OpticProductEntity {
  const OpticProductModel({
    super.id,
    required super.name,
    required super.category,
    required super.price,
  });

  /// Construye desde el JSON que devuelve el backend.
  factory OpticProductModel.fromJson(Map<String, dynamic> json) {
    return OpticProductModel(
      id: json['id']?.toString(),
      name: (json['name'] ?? '') as String,
      category: (json['category'] ?? '') as String,
      price: (json['price'] as num).toDouble(),
    );
  }

  /// Convierte la entidad a JSON. No incluimos id porque el backend lo asigna
  /// (POST) o lo toma de la URL (PUT).
  Map<String, dynamic> toJson() => {
        'name': name,
        'category': category,
        'price': price,
      };

  /// Convierte una entidad de dominio en su versión de modelo, lista para
  /// serializar (útil cuando el ViewModel construye una entity).
  factory OpticProductModel.fromEntity(OpticProductEntity e) {
    return OpticProductModel(
      id: e.id,
      name: e.name,
      category: e.category,
      price: e.price,
    );
  }
}
