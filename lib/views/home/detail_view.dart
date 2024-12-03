import 'dart:convert'; // Para decodificar imágenes Base64
import 'package:crochetify_movil/views/cart/cart_view.dart';
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
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: widget.stocks.map((stock) {
                      bool isSelected = _selectedStock == stock;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedStock = stock;
                            _quantity = 1;
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.all(4.0),
                          width: 30.0,
                          height: 30.0,
                          decoration: BoxDecoration(
                            color: Color(
                                int.parse('0xff${stock.color.substring(1)}')),
                            shape: BoxShape.circle,
                            border: isSelected
                                ? Border.all(color: Colors.blue, width: 3.0)
                                : null,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: _decrementQuantity,
                        icon: const Icon(Icons.remove, color: Colors.blue),
                      ),
                      Text(
                        '$_quantity',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        onPressed: _incrementQuantity,
                        icon: const Icon(Icons.add, color: Colors.blue),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Total: \$${totalPrice.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () async {
                      final authViewModel =
                          Provider.of<AuthViewModel>(context, listen: false);
                      final userId = authViewModel.user?.id;

                      if (userId == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content:
                                Text('Inicia sesión para agregar al carrito'),
                          ),
                        );
                        return;
                      }

                      try {
                        await cartViewModel.addToCart(
                          userId,
                          _selectedStock.idStock,
                          _quantity,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Producto agregado al carrito')),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text('Error al agregar al carrito: $e')),
                        );
                      }
                    },
                    icon: const Icon(Icons.shopping_cart),
                    label: const Text('Agregar al carrito'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      minimumSize: const Size(double.infinity, 50),
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
