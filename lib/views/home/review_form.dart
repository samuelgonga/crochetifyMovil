import 'package:flutter/material.dart';
import 'package:crochetify_movil/services/comment_service.dart';
import 'package:crochetify_movil/widget/navigation/bottom_navigation.dart'; // Asegúrate de tener la importación correcta para HomeScreen

class AddReviewScreen extends StatefulWidget {
  final int productId;

  const AddReviewScreen({Key? key, required this.productId}) : super(key: key);

  @override
  _AddReviewScreenState createState() => _AddReviewScreenState();
}

class _AddReviewScreenState extends State<AddReviewScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _commentController = TextEditingController();
  int _rating = 0;
  bool _isSubmitting = false;

  void _submitReview() async {
    if (_formKey.currentState!.validate() && _rating > 0) {
      setState(() {
        _isSubmitting = true;
      });

      final commentService = CommentService();
      try {
        await commentService.addReview(
          productId: widget.productId,
          comment: _commentController.text,
          score: _rating,
        );

        _showSuccessDialog();
      } on Exception catch (e) {
        _showErrorDialog('Hubo un problema al enviar la reseña: $e');
      } finally {
        setState(() {
          _isSubmitting = false;
        });
      }
    } else {
      _showErrorDialog('Por favor selecciona una puntuación.');
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        title: Row(
          children: const [
            Icon(Icons.check_circle, color: Colors.green, size: 30),
            SizedBox(width: 10),
            Text('Reseña enviada', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        content: const Text('Tu reseña ha sido enviada con éxito.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomeScreen(initialIndex: 0),
                ),
                (route) => false,
              );
            },
            child: const Text(
              'Aceptar',
              style: TextStyle(color: Colors.blue),
            ),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        title: Row(
          children: const [
            Icon(Icons.error, color: Colors.red, size: 30),
            SizedBox(width: 10),
            Text('Error', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cerrar',
              style: TextStyle(color: Colors.blue),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar Reseña'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Calificación:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Row(
                children: List.generate(5, (index) {
                  return IconButton(
                    onPressed: () {
                      setState(() {
                        _rating = index + 1;
                      });
                    },
                    icon: Icon(
                      Icons.star,
                      color: _rating > index ? Colors.yellow : Colors.grey,
                    ),
                  );
                }),
              ),
              const SizedBox(height: 16),
              const Text(
                'Comentario:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _commentController,
                maxLines: 5,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Escribe tu comentario aquí...',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor escribe un comentario.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitReview,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: _isSubmitting
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Enviar Reseña', style: TextStyle(fontSize: 16)),
                ),
              ),
              const SizedBox(height: 16),
              if (_rating > 0)
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(
                      color: _rating <= 2
                          ? Colors.red
                          : (_rating <= 4 ? Colors.orange : Colors.green),
                      width: 2,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Tu calificación: $_rating estrellas',
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
