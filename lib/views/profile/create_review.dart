import 'package:flutter/material.dart';
import 'package:crochetify_movil/models/comment.dart';
import 'package:crochetify_movil/viewmodels/comment_viewmodel.dart';
import 'package:provider/provider.dart';

class CreateCommentView extends StatelessWidget {
  final int productId;

  const CreateCommentView({Key? key, required this.productId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final reviewViewModel = Provider.of<ReviewViewModel>(context);

    final TextEditingController contentController = TextEditingController();
    double rating = 5.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Comentario'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Escribe tu comentario:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: contentController,
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: 'Escribe tu experiencia...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Calificación:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Slider(
              value: rating,
              min: 1.0,
              max: 5.0,
              divisions: 4,
              label: rating.toString(),
              onChanged: (value) {
                rating = value;
              },
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () async {
                final comment = Comment(
                  productId: productId,                  
                  comment: contentController.text,
                  score: rating.toInt(),
                );

                await reviewViewModel.createReview(comment);

                if (reviewViewModel.errorMessage != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(reviewViewModel.errorMessage!)),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Comentario enviado con éxito')),
                  );
                  Navigator.pop(context);
                }
              },
              child: const Text('Enviar'),
            ),
          ],
        ),
      ),
    );
  }
}
