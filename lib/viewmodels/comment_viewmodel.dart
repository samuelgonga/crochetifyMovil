import 'package:flutter/foundation.dart';
import '../services/comment_service.dart';

class ReviewViewModel extends ChangeNotifier {
  final CommentService reviewService;

  // Estado interno
  Map<String, dynamic> _reviews = {};
  bool _isLoading = false;
  String? _errorMessage;

  // Constructor que recibe la instancia del servicio
  ReviewViewModel({required this.reviewService});

  // Getters
  Map<String, dynamic> get reviews => _reviews;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Método para obtener las reseñas de un producto
  Future<void> fetchReviews(int productId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Obtenemos los datos
      final response = await reviewService.fetchReviewsByProductId(productId);

      // Convertimos el mapa a una lista de reseñas
      _reviews = response ?? {};
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
