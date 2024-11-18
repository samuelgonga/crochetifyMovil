class Category {
  final int id;
  final String name;
  final bool status;

  Category({required this.id, required this.name, required this.status});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['idCategory'], // Ajuste para coincidir con la clave en la respuesta
      name: json['name'],
      status: json['status'],
    );
  }
}
