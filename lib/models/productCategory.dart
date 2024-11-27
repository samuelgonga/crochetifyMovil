class Product {
  final int id;
  final String description;
  final String name;
  final bool status;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.status,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id_product'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
      status: json['status'] as bool,
    );
  }
}
