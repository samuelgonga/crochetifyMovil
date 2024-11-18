class Product {
  String name;
  String description;

  Product({
    required this.name,
    required this.description,
  });

  // Método para deserializar desde JSON
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      name: json['name'],
      description: json['description'],
    );
  }
}
