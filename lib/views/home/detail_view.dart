import 'dart:convert'; // Para decodificar imágenes Base64
import 'package:crochetify_movil/viewmodels/cart_viewmodel.dart';
import 'package:crochetify_movil/viewmodels/session_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:crochetify_movil/models/stock.dart';
import 'package:crochetify_movil/models/producto.dart';
import 'package:provider/provider.dart';
import 'package:crochetify_movil/viewmodels/comment_viewmodel.dart';

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
    final reviewViewModel =
        Provider.of<ReviewViewModel>(context, listen: false);
    reviewViewModel.fetchReviews(widget.product.idProduct);
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

  void _updateSelectedStock(Stock stock) {
    setState(() {
      _selectedStock = stock;
      _quantity = 1;
    });
  }

  double get totalPrice => _selectedStock.price * _quantity;

  @override
  Widget build(BuildContext context) {
    final reviewViewModel = Provider.of<ReviewViewModel>(context);
    reviewViewModel.fetchReviews;
    return Scaffold(
      appBar: AppBar(
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
              height: 150.0,
              width: 400,
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
                          child: base64Image.isNotEmpty
                              ? Image.memory(
                                  base64Decode(base64Image.replaceFirst(
                                      'data:image/jpeg;base64,', '')),
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
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Text(
                widget.product.name,
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: widget.stocks.map((stock) {
                bool isSelected = _selectedStock == stock;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedStock = stock;
                      _updateSelectedStock(stock);
                      _currentImageIndex = 0;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.all(2.0),
                    width: 25.0,
                    height: 25.0,
                    decoration: BoxDecoration(
                      color:
                          Color(int.parse('0xff${stock.color.substring(1)}')),
                      shape: BoxShape.circle,
                      border: isSelected
                          ? Border.all(color: Colors.blue, width: 3.0)
                          : null,
                    ),
                    child: isSelected
                        ? Center(
                            child: Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 10.0,
                            ),
                          )
                        : null,
                  ),
                );
              }).toList(),
            ),
            Center(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      widget.product.description,
                      maxLines: 4,
                      textAlign: TextAlign.center,
                      style:
                          const TextStyle(fontSize: 12, color: Colors.black87),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4),
                    child: Text(
                      "Disponible: ${_selectedStock.quantity}",
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: widget.product.categories.map((category) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 2.0),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 4.0, vertical: 2.0),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 138, 142, 143),
                    borderRadius: BorderRadius.circular(20.0),
                    border: Border.all(
                        color: const Color.fromARGB(255, 0, 0, 0), width: 1.5),
                  ),
                  child: Text(
                    category.name,
                    style: TextStyle(
                        fontSize: 10.0,
                        color: const Color.fromARGB(255, 255, 255, 255)),
                  ),
                );
              }).toList(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: _decrementQuantity,
                  icon: const Icon(Icons.remove, color: Colors.blue),
                ),
                Text(
                  "$_quantity",
                  style: const TextStyle(fontSize: 18, color: Colors.blue),
                ),
                IconButton(
                  onPressed: _incrementQuantity,
                  icon: const Icon(Icons.add, color: Colors.blue),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Total: \$${totalPrice.toStringAsFixed(2)}',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 60.0),
              child: ElevatedButton.icon(
                onPressed: () async {
                  final authViewModel =
                      Provider.of<AuthViewModel>(context, listen: false);
                  final cartViewModel =
                      Provider.of<CartViewModel>(context, listen: false);

                  // Obtener el ID del usuario
                  final idUser = authViewModel.user?.id;
                  if (idUser == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content:
                              Text('Inicia sesión para agregar al carrito')),
                    );
                    return;
                  }

                  try {
                    // Verificar si el carrito existe
                    await cartViewModel.fetchCart(idUser);
                    if (cartViewModel.hasCart) {
                      print("El carrito existe. Actualizando...");
                      await cartViewModel.updateCart(
                        idUser,
                        _selectedStock.idStock,
                        _quantity,
                      );
                    } else {
                      print("El carrito no existe. Creando uno nuevo...");
                      await cartViewModel.addToCart(
                        idUser,
                        _selectedStock.idStock,
                        _quantity,
                      );
                    }

                    // Mostrar confirmación al usuario
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Producto agregado al carrito')),
                    );
                  } catch (e) {
                    // Manejo de errores
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text('Error al procesar el carrito: $e')),
                    );
                    print("Error al procesar el carrito: $e");
                  }
                },
                label: const Text(
                  'Agregar al carrito',
                  style: TextStyle(fontSize: 18),
                ),
                icon: const Icon(Icons.arrow_forward, color: Colors.white),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  minimumSize: Size(double.infinity, 50),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Comentarios del producto',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            reviewViewModel.isLoading
                ? const Center(child: CircularProgressIndicator())
                : reviewViewModel.errorMessage != null
                    ? Center(
                        child: Text(
                          reviewViewModel.errorMessage!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      )
                    : reviewViewModel.reviews.isNotEmpty
                        ? ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: reviewViewModel.reviews.length,
                            itemBuilder: (context, index) {
                              final reviewKey =
                                  reviewViewModel.reviews.keys.elementAt(index);
                              final review = reviewViewModel.reviews[reviewKey];

                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 8.0),
                                child: Material(
                                  elevation: 4,
                                  borderRadius: BorderRadius.circular(10),
                                  child: Container(
                                    padding: const EdgeInsets.all(16.0),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.star,
                                              color: Colors.yellow[700],
                                            ),
                                            const SizedBox(width: 8.0),
                                            Text(
                                              'Puntuación: ${review["score"]}',
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8.0),
                                        Text(
                                          review["comment"],
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          )
                        : const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text(
                              'No hay comentarios para este producto.',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
          ],
        ),
      ),
    );
  }
}
