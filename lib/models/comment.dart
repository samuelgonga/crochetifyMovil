class Comment {
  final String comment;   // Texto del comentario
  final int score;        // Calificación dada
  final int productId;    // ID del producto relacionado

  // Constructor
  Comment({
    required this.comment,
    required this.score,
    required this.productId,
  });

  // Método para mapear desde JSON
  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      comment: json['comment'] as String,
      score: json['score'] as int,
      productId: json['productId'] as int,
    );
  }

  // Método para mapear a JSON
  Map<String, dynamic> toJson() {
    return {
      'comment': comment,
      'score': score,
      'productId': productId,
    };
  }
}
