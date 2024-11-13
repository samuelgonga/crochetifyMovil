import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:crochetify_movil/viewmodels/product_viewmodel.dart';
import 'package:crochetify_movil/views/home/detail_view.dart';
import 'package:crochetify_movil/widget/home/custom_buttom.dart';

// Nuevo widget ImageCarousel que carga imágenes de activos locales y se desplaza automáticamente
class ImageCarousel extends StatefulWidget {
  final List<String> imageUrls;

  const ImageCarousel({required this.imageUrls, super.key});

  @override
  _ImageCarouselState createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<ImageCarousel> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_pageController.hasClients) {
        _currentPage++;
        if (_currentPage >= widget.imageUrls.length) {
          _currentPage = 0;
        }
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150, // Ajusta la altura según sea necesario
      child: PageView.builder(
        controller: _pageController,
        itemCount: widget.imageUrls.length,
        itemBuilder: (context, index) {
          return Image.asset(
            widget.imageUrls[index],
            fit: BoxFit.cover,
            width: double.infinity,
          );
        },
      ),
    );
  }
}

class CategoryProductView extends StatefulWidget {
  const CategoryProductView({super.key});

  @override
  _CategoryProductViewState createState() => _CategoryProductViewState();
}

class _CategoryProductViewState extends State<CategoryProductView> {
  late Future<void> _fetchProductsFuture;
  String _searchQuery = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _fetchProductsFuture =
        Provider.of<ProductViewModel>(context, listen: false).fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Videojuegos'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Navigator.of(context).pop(); // Regresa a la vista anterior
          },
        ),
      ),
      body: Column(
        children: [
          // Campo de búsqueda
          Padding(
            padding: const EdgeInsets.only(
                top: 16.0, left: 8.0, right: 8.0, bottom: 6),
            child: SizedBox(
              height: 40,
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Buscar...',
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(30.0), // Borde redondeado
                  ),
                  prefixIcon: const Icon(Icons.search),
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery =
                        value.toLowerCase(); // Actualiza el texto de búsqueda
                  });
                },
              ),
            ),
          ),
          // Botones de selección
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CustomButton(text: 'Popular'),
              CustomButton(text: 'Nuevo'),
              CustomButton(text: 'Menor precio'),
              CustomButton(text: 'Mayor precio'),
            ],
          ),
          // Carrusel de imágenes con imágenes de assets locales
          Center(
            child: ImageCarousel(imageUrls: [
              'assets/images/donkey.jpeg',
              'assets/images/link.jpeg',
              'assets/images/mario.jpeg',
              'assets/images/megaman.jpeg',
            ]),
          ),

          // FutureBuilder para la lista de productos
          Expanded(
            child: FutureBuilder(
              future: _fetchProductsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  return Consumer<ProductViewModel>(
                    builder: (context, viewModel, child) {
                      // Filtra la lista de productos según la búsqueda
                      final filteredProducts =
                          viewModel.products.where((product) {
                        return product.nombre
                            .toLowerCase()
                            .contains(_searchQuery);
                      }).toList();

                      return GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.7,
                          crossAxisSpacing: 8.0,
                          mainAxisSpacing: 8.0,
                        ),
                        itemCount: filteredProducts.length,
                        itemBuilder: (context, index) {
                          final product = filteredProducts[index];
                          final firstImage = product
                                      .imagenesPorColor.isNotEmpty &&
                                  product
                                      .imagenesPorColor[0].imagenes.isNotEmpty
                              ? product.imagenesPorColor[0].imagenes[0]
                              : ''; // Obtiene la primera imagen del primer color disponible

                          return Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 6.0, vertical: 4.0),
                            child: Card(
                              elevation: 4,
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ProductDetail(product: product),
                                    ),
                                  );
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: ClipRRect(
                                        borderRadius:
                                            const BorderRadius.vertical(
                                                top: Radius.circular(4)),
                                        child: Image.network(
                                          firstImage,
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Center(
                                            child: Text(product.nombre,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20,
                                                )),
                                          ),
                                          Text(
                                            product.descripcion,
                                            textAlign: TextAlign.justify,
                                            style: const TextStyle(fontSize: 8),
                                          ),
                                          Center(
                                            child: Text(
                                              '\$${product.precio.toStringAsFixed(2)}',
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
