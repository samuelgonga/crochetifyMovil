import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/comment.dart'; // Asegúrate de ajustar la ruta a tu modelo

class CommentService {
  final String baseUrl = 'http://100.27.71.83:8087/api/crochetify/review';  

  Future<Map<String, dynamic>> fetchReviewsByProductId(int productId) async {
    try {
      final url = Uri.parse('$baseUrl/$productId');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['success'] == true) {
          // Devuelve las reseñas desde la respuesta
          return data['response'];
        } else {
          throw Exception(data['message'] ?? 'Error desconocido al obtener reseñas');
        }
      } else {
        throw Exception('Error al comunicarse con el servidor: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error al obtener las reseñas: $e');
    }
  }

  Future<bool> createComment(Comment comment) async {
    try {
      final url = Uri.parse(baseUrl);
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'productId': comment.productId,          
          'comment': comment.comment,
          'score': comment.score,
        }),
      );

      if (response.statusCode == 201) { // Código de respuesta para creación exitosa
        final data = jsonDecode(response.body);

        if (data['success'] == true) {
          return true; // Indica que se creó el comentario con éxito
        } else {
          throw Exception(data['message'] ?? 'Error desconocido al crear comentario');
        }
      } else {
        throw Exception('Error al comunicarse con el servidor: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error al crear el comentario: $e');
    }
  }
}
