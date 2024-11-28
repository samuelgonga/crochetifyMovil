class Comentario {
  String comentario;
  int valoracion;

  Comentario({required this.comentario, required this.valoracion});

  factory Comentario.fromJson(Map<String, dynamic> json) {
    return Comentario(
      comentario: json['comentario'],
      valoracion: json['valoracion'],
    );
  }
}
