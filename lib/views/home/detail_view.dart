import 'dart:convert'; // Para decodificar imágenes Base64
import 'package:crochetify_movil/views/cart/cart_view.dart';
import 'package:crochetify_movil/widget/navigation/bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:crochetify_movil/viewmodels/cart_viewmodel.dart';
import 'package:crochetify_movil/viewmodels/comment_viewmodel.dart';
import 'package:crochetify_movil/viewmodels/session_viewmodel.dart';
import 'package:crochetify_movil/models/stock.dart';
import 'package:crochetify_movil/models/producto.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;
  final List<Stock> stocks;

  const ProductDetailScreen({
    Key? key,
    required this.product,
    required this.stocks,
  }) : super(key: key);

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late Stock _selectedStock;
  int _currentImageIndex = 0;
  int _quantity = 1;

  @override
  void initState() {
    super.initState();
    _selectedStock = widget.stocks.first;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final reviewViewModel =
          Provider.of<ReviewViewModel>(context, listen: false);
      reviewViewModel.fetchReviews(widget.product.idProduct);
    });
  }

  void _incrementQuantity() {
    if (_quantity < _selectedStock.quantity) {
      setState(() {
        _quantity++;
      });
    }
  }

  void _decrementQuantity() {
    if (_quantity > 1) {
      setState(() {
        _quantity--;
      });
    }
  }

  double get totalPrice => _selectedStock.price * _quantity;

  String cleanBase64Image(String base64Image) {
    return base64Image.contains(',') ? base64Image.split(',')[1] : base64Image;
  }

  @override
Widget build(BuildContext context) {
  final reviewViewModel = Provider.of<ReviewViewModel>(context);
  final cartViewModel = Provider.of<CartViewModel>(context, listen: false);

  return Scaffold(
    appBar: AppBar(
      centerTitle: true,
      title: Text(widget.product.name),
      actions: [
        IconButton(
          icon: const Icon(
            Icons.star,
            color: Colors.yellow,
            size: 30.0,
          ),
          onPressed: () {
            // Lógica para cambiar la valoración
          },
        ),
      ],
    ),
    body: SingleChildScrollView(
      child: Column(
        children: [
          // Sección de imágenes (ya existente)
          SizedBox(
            height: 200.0,
            width: double.infinity,
            child: CarouselSlider(
              options: CarouselOptions(
                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 3),
                enlargeCenterPage: true,
                viewportFraction: 0.8,
                onPageChanged: (index, reason) {
                  setState(() {
                    _currentImageIndex = index;
                  });
                },
              ),
              items: _selectedStock.images.map((base64Image) {
                final cleanImage = cleanBase64Image(base64Image!);
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 5.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 4.0,
                            offset: Offset(2, 2),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15.0),
                        child: cleanImage.isNotEmpty
                            ? Image.memory(
                                base64Decode(cleanImage),
                                fit: BoxFit.cover,
                                width: double.infinity,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Center(
                                  child: Icon(Icons.image_not_supported),
                                ),
                              )
                            : const Center(
                                child: Icon(Icons.image_not_supported),
                              ),
                      ),
                    );
                  },
                );
              }).toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Detalles del producto (ya existente)
                Text(
                  widget.product.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  widget.product.description,
                  style: const TextStyle(fontSize: 16, color: Colors.black54),
                ),
                const SizedBox(height: 20),
                // Sección para mostrar reseñas
                const Text(
                  'Reseñas',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                reviewViewModel.isLoading
    ? const Center(child: CircularProgressIndicator())
    : reviewViewModel.errorMessage != null
        ? Text(
            'Error al cargar reseñas: ${reviewViewModel.errorMessage}',
            style: const TextStyle(
              color: Colors.red,
              fontSize: 16,
            ),
          )
        : reviewViewModel.reviews.isNotEmpty
            ? ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: reviewViewModel.reviews.length,
                itemBuilder: (context, index) {
                  final reviewKey = reviewViewModel.reviews.keys.elementAt(index);
                  final review = reviewViewModel.reviews[reviewKey];
                  return Card(
  elevation: 5,
  margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
  shape: RoundedRectangleBorder(
    side: BorderSide(
      color: review['score'] >= 4 ? Colors.green : Colors.red,
      width: 2,
    ),
    borderRadius: BorderRadius.circular(15),
  ),
  child: Padding(
    padding: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.star,
              color: Colors.yellow[700],
              size: 30,
            ),
            const SizedBox(width: 10),
            Text(
              'Puntuación: ${review['score']}/5',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          review['comment'],
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black87,
            fontStyle: FontStyle.italic,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          height: 2,
          width: double.infinity,
          color: Colors.grey[200],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            const Icon(Icons.person, color: Colors.grey),
            const SizedBox(width: 5),
            Text(
              'Usuario Anónimo',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    ),
  ),
);

                },
              )
            : const Center(
                child: Text(
                  'Este producto no tiene reseñas aún.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),

              ],
            ),
          ),
        ],
      ),
    ),
  );
}

}
