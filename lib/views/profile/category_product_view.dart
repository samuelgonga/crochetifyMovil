import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class ProductsScreen extends StatefulWidget {
  final String categoryName;

  ProductsScreen({required this.categoryName});

  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  List<Product> filteredProducts = [];
  List<Product> products = [];
  final List<String> imagePaths = [
    'assets/images/ness.jpeg',
    'assets/images/donkey.jpeg',
    'assets/images/pikachu.jpeg',
  ];

  late List<Widget> _pages;
  int _activePage = 0;
  final PageController _pageController = PageController(initialPage: 0);
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    loadProducts();
    _pages = List.generate(
      imagePaths.length,
      (index) => ImagePlaceHolder(
        imagePath: imagePaths[index],
      ),
    );
    startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancelar el temporizador al cerrar la vista
    _pageController.dispose(); // Liberar el PageController
    super.dispose();
  }

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      if (_pageController.hasClients) {
        final nextPage =
            (_pageController.page?.toInt() ?? 0) == imagePaths.length - 1
                ? 0
                : (_pageController.page?.toInt() ?? 0) + 1;
        _pageController.animateToPage(
          nextPage,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  Future<void> loadProducts() async {
    final String response = await rootBundle.loadString('assets/products.json');
    final List data = json.decode(response);
    setState(() {
      products = data.map((json) => Product.fromJson(json)).toList();
      filteredProducts = products;
    });
  }

  void _filterProducts(String query) {
    final List<Product> results = [];
    if (query.isEmpty) {
      results.addAll(products);
    } else {
      results.addAll(products.where((product) =>
          product.name.toLowerCase().contains(query.toLowerCase())));
    }
    setState(() {
      filteredProducts = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categoryName),
      ),
      body: CustomScrollView(
        slivers: [
          // Sliver para la barra de búsqueda
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: _filterProducts,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Buscar...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
              ),
            ),
          ),

          // Sliver para el carrusel de imágenes
          SliverToBoxAdapter(
            child: Stack(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height / 8,
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: _pages.length,
                    itemBuilder: (context, index) {
                      return _pages[index];
                    },
                  ),
                ),
                Positioned(
                  bottom: 10,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List<Widget>.generate(
                      _pages.length,
                      (index) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: InkWell(
                          onTap: () {
                            _pageController.animateToPage(
                              index,
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeIn,
                            );
                          },
                          child: CircleAvatar(
                            radius: 4,
                            backgroundColor: _activePage == index
                                ? Colors.grey
                                : Colors.black87,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.all(15),
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 0.7,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final product = filteredProducts[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Stack(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(
                                        'assets/images/${product.name.toLowerCase().replaceAll(" ", "_")}.jpeg'),
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(15)),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product.name,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    product.description,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    '\$${product.price.toStringAsFixed(2)}',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Positioned(
                          bottom: 8,
                          right: 8,
                          child: MouseRegion(
                            cursor: SystemMouseCursors
                                .click, // Cambia el cursor a una "manita" al pasar sobre el botón
                            child: FloatingActionButton(
                              onPressed: () {
                                // Lógica para agregar al carrito o cualquier otra acción
                              },
                              mini: true,
                              backgroundColor: Colors.blue,
                              child: Icon(Icons.add, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                childCount: filteredProducts.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ImagePlaceHolder extends StatelessWidget {
  final String? imagePath;
  const ImagePlaceHolder({super.key, this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      imagePath ?? 'assets/ness.jpeg',
      fit: BoxFit.cover,
    );
  }
}

class Product {
  final String name;
  final String description;
  final double price;

  Product({required this.name, required this.description, required this.price});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      name: json['name'],
      description: json['description'],
      price: json['price'].toDouble(),
    );
  }
}
