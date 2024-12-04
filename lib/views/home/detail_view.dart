import 'dart:convert';
import 'package:crochetify_movil/viewmodels/comment_viewmodel.dart';
import 'package:crochetify_movil/views/cart/cart_view.dart';
import 'package:crochetify_movil/views/home/review_form.dart';
import 'package:crochetify_movil/widget/navigation/bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';
import 'package:crochetify_movil/viewmodels/cart_viewmodel.dart';
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
  int _quantity = 1;

  Color _parseColor(String color) {
    try {
      return Color(int.parse(color.replaceFirst('#', '0xff')));
    } catch (e) {
      return Colors.grey;
    }
  }

  double get totalPrice => _selectedStock.price * _quantity;

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

  String cleanBase64Image(String base64Image) {
    return base64Image.contains(',') ? base64Image.split(',')[1] : base64Image;
  }

  @override
  Widget build(BuildContext context) {
    final cartViewModel = Provider.of<CartViewModel>(context, listen: false);
    final reviewViewModel = Provider.of<ReviewViewModel>(context);
    final userId = Provider.of<AuthViewModel>(context, listen: false).user?.id;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product.name),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Carrusel de imágenes
            SizedBox(
              height: 250,
              width: double.infinity,
              child: CarouselSlider(
                options: CarouselOptions(
                  autoPlay: true,
                  enlargeCenterPage: true,
                ),
                items: _selectedStock.images.map((image) {
                  final cleanImage = cleanBase64Image(image!);
                  return Builder(
                    builder: (context) => Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Image.memory(
                        base64Decode(cleanImage),
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.image_not_supported),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),
            // Botones para cambiar de color
            Wrap(
              spacing: 8,
              children: widget.stocks.map((stock) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedStock = stock;
                    });
                  },
                  child: CircleAvatar(
                    backgroundColor: _parseColor(stock.color),
                    child: _selectedStock == stock
                        ? const Icon(Icons.check, color: Colors.white)
                        : null,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            // Información del producto
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.product.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(widget.product.description),
                  const SizedBox(height: 16),
                  Center(
                    child: Text(
                      'Total en Stock: ${_selectedStock.quantity}',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: _selectedStock.quantity == 0
                            ? Colors.red
                            : Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: _decrementQuantity,
                        icon: const Icon(
                          Icons.remove_circle,
                          size: 30,
                          color: Colors.red,
                        ),
                      ),
                      Column(
                        children: [
                          Text(
                            'Cantidad: $_quantity',
                            style: const TextStyle(fontSize: 18),
                          ),
                          Text(
                            'Total: \$${totalPrice.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: _incrementQuantity,
                        icon: const Icon(
                          Icons.add_circle,
                          size: 30,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_selectedStock.quantity == 0) {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              title: Row(
                                children: const [
                                  Icon(Icons.warning_amber_rounded,
                                      color: Colors.orange, size: 30),
                                  SizedBox(width: 10),
                                  Text(
                                    'Sin Stock',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              content: const Text(
                                'No hay stock disponible para agregar este producto al carrito.',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text(
                                    'Aceptar',
                                    style: TextStyle(color: Colors.blue),
                                  ),
                                ),
                              ],
                            ),
                          );
                        } else if (userId == null) {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Inicia sesión'),
                              content: const Text(
                                  'Debes iniciar sesión para agregar productos al carrito.'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Cancelar'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const HomeScreen(initialIndex: 3),
                                      ),
                                    );
                                  },
                                  child: const Text('Iniciar sesión'),
                                ),
                              ],
                            ),
                          );
                        } else {
                          await cartViewModel.addToCart(
                            userId,
                            _selectedStock.idStock,
                            _quantity,
                          );
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Producto añadido'),
                              content: const Text(
                                  'El producto se ha añadido al carrito.'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Seguir comprando'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const HomeScreen(initialIndex: 2),
                                      ),
                                    );
                                  },
                                  child: const Text('Ir al carrito'),
                                ),
                              ],
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: const Text(
                        'Añadir al carrito',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Reseñas',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Botón para agregar reseñas
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: userId == null
                          ? () {
                              // Mostrar alerta para iniciar sesión si el usuario no está logueado
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Inicia sesión'),
                                  content: const Text(
                                      'Debes iniciar sesión para agregar una reseña.'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('Cancelar'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const HomeScreen(
                                                    initialIndex: 3),
                                          ),
                                        );
                                      },
                                      child: const Text('Iniciar sesión'),
                                    ),
                                  ],
                                ),
                              );
                            }
                          : () {
                              // Navegar a la pantalla para agregar reseñas si el usuario está logueado
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddReviewScreen(
                                    productId: widget.product.idProduct,
                                  ),
                                ),
                              );
                            },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: const Text('Agregar Reseña'),
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
                                    final reviewKey = reviewViewModel
                                        .reviews.keys
                                        .elementAt(index);
                                    final review =
                                        reviewViewModel.reviews[reviewKey];
                                    return Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 8),
                                      child: ListTile(
                                        leading: const Icon(
                                          Icons.star,
                                          color: Colors.yellow,
                                        ),
                                        title: Text(
                                          'Puntuación: ${review['score']}/5',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        subtitle: Text(review['comment']),
                                      ),
                                    );
                                  },
                                )
                              : const Center(
                                  child: Text(
                                    'Este producto no tiene reseñas aún.',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey,
                                    ),
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