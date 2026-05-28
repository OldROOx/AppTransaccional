
class OpticProduct {
  final String? id;
  final String name;
  final String category;
  final double price;

  OpticProduct({this.id, required this.name, required this.category, required this.price});

  factory OpticProduct.fromJson(Map<String, dynamic> json) {
    return OpticProduct(
      id: json['id'],
      name: json['name'],
      category: json['category'],
      price: json['price'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'category': category,
    'price': price,
  };
}