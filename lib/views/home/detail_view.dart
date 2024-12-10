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

  Color _getBorderColor(int score) {
    if (score <= 2) return Colors.red;
    if (score <= 4) return Colors.orange;
    return Colors.green;
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
    } else {
      _showAlertDialog(
        context,
        'Cantidad no válida',
        'No puedes agregar más productos de los que hay en stock.',
        showCartActions: false,
      );
    }
  }

  void _decrementQuantity() {
    if (_quantity > 1) {
      setState(() {
        _quantity--;
      });
    } else {
      _showAlertDialog(
        context,
        'Cantidad no válida',
        'No puedes agregar 0 productos a tu carrito, selecciona una cantidad mayor a 1',
        showCartActions: false,
      );
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
      body: CustomScrollView(
        slivers: [
          // SliverAppBar
          SliverAppBar(
            expandedHeight: 100.0,
            floating: false,
            pinned: true,
            backgroundColor: const Color.fromARGB(255, 113, 191, 254),
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                utf8.decode(widget.product.name.runes.toList()),
                style: const TextStyle(color: Colors.white),
              ),
              background: Container(
                color: const Color.fromARGB(255, 113, 191, 254),
              ),
            ),
          ),
          // Contenido principal
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Column(
                children: [
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          utf8.decode(widget.product.name.runes.toList()),
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          utf8.decode(
                              widget.product.description.runes.toList()),
                        ),
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
                              onPressed: _selectedStock.quantity > 0 &&
                                      _quantity > 1
                                  ? _decrementQuantity
                                  : null, // Desactiva si no hay stock o cantidad es 1
                              icon: const Icon(
                                Icons.remove_circle,
                                size: 30,
                              ),
                              color: _selectedStock.quantity > 0 &&
                                      _quantity > 1
                                  ? Colors.red
                                  : Colors
                                      .grey, // Cambia a gris si está desactivado
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
                              onPressed: _selectedStock.quantity > 0 &&
                                      _quantity < _selectedStock.quantity
                                  ? _incrementQuantity
                                  : null, // Desactiva si no hay stock o cantidad alcanza el stock disponible
                              icon: const Icon(
                                Icons.add_circle,
                                size: 30,
                              ),
                              color: _selectedStock.quantity > 0 &&
                                      _quantity < _selectedStock.quantity
                                  ? Colors.blue
                                  : Colors
                                      .grey, // Cambia a gris si está desactivado
                            ),
                          ],
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _selectedStock.quantity > 0
                                ? () async {
                                    if (userId == null) {
                                      _showAlertDialog(
                                        context,
                                        'Inicia sesión',
                                        'Debes iniciar sesión para agregar productos al carrito.',
                                        showCartActions: false,
                                      );
                                    } else {
                                      await cartViewModel.addToCart(
                                        userId,
                                        _selectedStock.idStock,
                                        _quantity,
                                      );
                                      await cartViewModel.fetchCart(userId);
                                      _showAlertDialog(
                                        context,
                                        'Producto añadido',
                                        'El producto se ha añadido al carrito.',
                                        showCartActions: true,
                                        userId: userId,
                                      );
                                    }
                                  }
                                : null, // Desactiva el botón si no hay stock
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _selectedStock.quantity > 0
                                  ? Colors.blue
                                  : Colors
                                      .grey, // Cambia el color dependiendo del stock
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            child: Text(
                              _selectedStock.quantity > 0
                                  ? 'Añadir al carrito'
                                  : 'Sin Stock', // Cambia el texto dependiendo del stock
                              style: const TextStyle(
                                  fontSize: 18, color: Colors.white),
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
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: userId == null
                                ? () {
                                    _showAlertDialog(
                                      context,
                                      'Inicia sesión',
                                      'Debes iniciar sesión para agregar una reseña.',
                                      showCartActions: false,
                                    );
                                  }
                                : () {
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
                              backgroundColor: Colors.blue,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            child: const Text(
                              'Agregar Reseña',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white),
                            ),
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
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount:
                                            reviewViewModel.reviews.length,
                                        itemBuilder: (context, index) {
                                          final reviewKey = reviewViewModel
                                              .reviews.keys
                                              .elementAt(index);
                                          final review = reviewViewModel
                                              .reviews[reviewKey];
                                          return Card(
                                            color: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              side: BorderSide(
                                                color: _getBorderColor(
                                                    review['score']),
                                                width: 2,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(10),
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
                                              subtitle: Text(
                                                utf8.decode(review['comment']
                                                    .runes
                                                    .toList()),
                                              ),
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
          ),
        ],
      ),
    );
  }

  void _showAlertDialog(BuildContext context, String title, String message,
      {bool showCartActions = false, int? userId}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        title: Row(
          children: [
            const Icon(Icons.info, color: Colors.blue, size: 30),
            const SizedBox(width: 10),
            Text(
              title,
              style: const TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
        content: Text(
          message,
          style: const TextStyle(fontSize: 16),
        ),
        actions: [
          if (showCartActions)
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Seguir comprando'),
            ),
          if (showCartActions)
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                if (userId != null) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HomeScreen(initialIndex: 2),
                    ),
                  );
                }
              },
              child: const Text('Ir al carrito'),
            ),
          if (!showCartActions)
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Aceptar'),
            ),
        ],
      ),
    );
  }
}
