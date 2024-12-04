import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/comment.dart'; // Asegúrate de ajustar la ruta a tu modelo

class CommentService {
  final String baseUrl = 'http://35.153.187.92:8087/api/crochetify/review';

  Future<Map<String, dynamic>> fetchReviewsByProductId(int productId) async {
    try {
      final url = Uri.parse('$baseUrl/$productId');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['success'] == true) {
          return data['response'];
        } else {
          throw Exception(
              data['message'] ?? 'Error desconocido al obtener reseñas');
        }
      } else {
        throw Exception(
            'Error al comunicarse con el servidor: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error al obtener las reseñas: $e');
    }
  }

  Future<void> addReview({
    required int productId,
    required String comment,
    required int score,
  }) async {
    try {
      final url = Uri.parse(baseUrl);
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'productId': productId,
          'comment': comment,
          'score': score,
        }),
      );

      // Verificar que la respuesta sea exitosa (200 o 201)
      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);

        // Validar el campo ⁠ success ⁠ en la respuesta
        if (responseData['success'] != true) {
          throw Exception(
              responseData['message'] ?? 'Error desconocido en el servidor.');
        }
      } else {
        throw Exception('Error HTTP: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error al enviar la reseña: $e');
    }
  }
}