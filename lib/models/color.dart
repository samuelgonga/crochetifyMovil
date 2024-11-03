class ColorImagen {
  String color;
  List<String> imagenes;
  String colorHex;

  ColorImagen(
      {required this.color, required this.imagenes, required this.colorHex});

  factory ColorImagen.fromJson(Map<String, dynamic> json) {
    return ColorImagen(
        color: json['color'],
        imagenes: List<String>.from(json['imagenes']),
        colorHex: json['colorHex']);
  }
}
