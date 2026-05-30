/// Entidad de dominio de un producto óptico.
class OpticProductEntity {
  final String? id;
  final String name;
  final String category;
  final double price;

  const OpticProductEntity({
    this.id,
    required this.name,
    required this.category,
    required this.price,
  });

  /// Crea una copia con campos modificados (útil al editar).
  OpticProductEntity copyWith({
    String? id,
    String? name,
    String? category,
    double? price,
  }) {
    return OpticProductEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      price: price ?? this.price,
    );
  }
}
