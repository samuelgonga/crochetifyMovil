import 'category.dart';

class Product {
  final int idProduct;
  final String name;
  final String description;
  final bool status;
  final List<Category> categories;

  Product({
    required this.idProduct,
    required this.name,
    required this.description,
    required this.status,
    required this.categories,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    var categoriesList = (json['categories'] as List)
        .map((category) => Category.fromJson(category))
        .toList();

    return Product(
      idProduct: json['idProduct'],
      name: json['name'],
      description: json['description'],
      status: json['status'],
      categories: categoriesList,
    );
  }

  // Método para convertir el objeto a JSON
  Map<String, dynamic> toJson() {
    return {
      'idProduct': idProduct,
      'name': name,
      'description': description,
      'status': status,
      'categories': categories.map((category) => category.toJson()).toList(),
    };
  }
}
