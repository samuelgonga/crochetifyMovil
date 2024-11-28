class Category {
  final int idCategory;
  final String name;
  final bool status;

  Category({
    required this.idCategory,
    required this.name,
    required this.status,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      idCategory: json['idCategory'],
      name: json['name'],
      status: json['status'],
    );
  }
}
