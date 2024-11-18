import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:crochetify_movil/viewmodels/product_viewmodel.dart';
import 'package:crochetify_movil/views/home/detail_view.dart';
import 'package:crochetify_movil/widget/home/custom_buttom.dart';
import 'package:crochetify_movil/widget/home/carousel.dart';

class ProductList extends StatefulWidget {
  const ProductList({super.key});

  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
                top: 56.0, left: 8.0, right: 8.0, bottom: 6),
            child: SizedBox(
              height: 40,
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Buscar...',
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
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
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CustomButton(text: 'Popular'),
              CustomButton(text: 'Nuevo'),
              CustomButton(text: 'Menor precio'),
              CustomButton(text: 'Mayor precio'),
            ],
          ),
          const Center(
            child: ImageCarousel(imageUrls: [
              'https://i.ytimg.com/vi/wj6N6knIHes/hq720.jpg?sqp=-oaymwEhCK4FEIIDSFryq4qpAxMIARUAAAAAGAElAADIQj0AgKJD&rs=AOn4CLB2qaMdlw5QRW2C-QRT_d7Ca9h7Ew',
              'https://i.pinimg.com/originals/6f/5e/6b/6f5e6b8e22c6cbbd69195c16fd1aec36.jpg',
              'https://www.supergurumi.com/wp-content/uploads/2022/10/Patrones-de-Crochet-Amigurumi-Gratis.jpg',
              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSLjweO621wvjrO9HHSo1isiOTylj863MH8og&s'
            ]),
          ),
          /*
          FutureBuilder para la lista de productos
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
                        return product.name
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
                                            child: Text(product.name,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15,
                                                )),
                                          ),
                                          Text(
                                            product.description,
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
          */
        ],
      ),
    );
  }
}
