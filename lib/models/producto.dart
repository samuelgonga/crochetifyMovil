import 'category.dart';

class Product {
  final int idProduct;
  final String name;
  final String description;
  final bool status;
  final List<Category> categories;

  Product(
      {required this.idProduct,
      required this.name,
      required this.description,
      required this.status,
      required this.categories});

  factory Product.fromJson(Map<String, dynamic> json) {
    var categoryList =
        (json['categories'] as List).map((i) => Category.fromJson(i)).toList();

    return Product(
      idProduct: json['idProduct'],
      name: json['name'],
      description: json['description'],
      status: json['status'],
      categories: categoryList,
    );
  }
}
