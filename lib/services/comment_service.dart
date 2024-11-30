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
}
