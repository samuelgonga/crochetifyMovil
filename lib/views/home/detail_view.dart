import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
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
                items: _selectedStock.images.map((url) {
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
                          child: Image.network(
                            url,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            errorBuilder: (context, error, stackTrace) =>
                                const Center(
                              child: Icon(Icons.image_not_supported),
                            ),
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
                      "Disponible: ${_selectedStock.quantity}", // Muestra cantidad disponible
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  )
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
              mainAxisAlignment: MainAxisAlignment
                  .center, // Centra los elementos horizontalmente
              children: [
                IconButton(
                  onPressed: _decrementQuantity,
                  icon: const Icon(Icons.remove,
                      color: Colors.blue), // Icono en azul
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
            // Total a pagar
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
                onPressed: () {
                  // Lógica para agregar al carrito
                },
                label: const Text(
                  'Agregar al carrito',
                  style: TextStyle(fontSize: 18),
                ),
                icon: const Icon(Icons.arrow_forward, color: Colors.white),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // Botón azul
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  minimumSize: Size(double.infinity, 50),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
