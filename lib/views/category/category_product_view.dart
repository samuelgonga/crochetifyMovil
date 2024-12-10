import 'dart:convert';
import 'package:crochetify_movil/widget/navigation/bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:crochetify_movil/viewmodels/stock_viewmodel.dart';
import 'package:crochetify_movil/views/home/detail_view.dart';

class CategoryProductView extends StatefulWidget {
  final String categoryTitle;
  final int categoryId;

  const CategoryProductView({
    Key? key,
    required this.categoryTitle,
    required this.categoryId,
  }) : super(key: key);

  @override
  _CategoryProductViewState createState() => _CategoryProductViewState();
}

class _CategoryProductViewState extends State<CategoryProductView> {
  late TextEditingController _searchController;
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<StockViewModel>(context, listen: false)
          .fetchStocksByCategory(widget.categoryId);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterProducts(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
    });
  }

  // Función para limpiar el prefijo base64
  String? cleanBase64(String? base64String) {
    if (base64String == null) return null;
    final prefixes = [
      'data:image/jpeg;base64,',
      'data:image/jpg;base64,',
      'data:image/png;base64,',
    ];
    for (var prefix in prefixes) {
      if (base64String.startsWith(prefix)) {
        return base64String.replaceFirst(prefix, '');
      }
    }
    return base64String;
  }

  @override
  Widget build(BuildContext context) {
    final stockViewModel = Provider.of<StockViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text(
          widget.categoryTitle,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          // Barra de búsqueda
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onChanged: _filterProducts,
              decoration: InputDecoration(
                hintText: "Buscar productos...",
                prefixIcon: const Icon(Icons.search, color: Colors.blueAccent),
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: stockViewModel.isLoading
                ? const Center(child: CircularProgressIndicator())
                : stockViewModel.errorMessage != null
                    ? Center(
                        child: Text(
                          "Error: ${stockViewModel.errorMessage}",
                          style: const TextStyle(color: Colors.red),
                        ),
                      )
                    : GridView.builder(
                        padding: const EdgeInsets.all(8.0),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, // Dos columnas
                          crossAxisSpacing: 8.0, // Espaciado horizontal
                          mainAxisSpacing: 8.0, // Espaciado vertical
                          childAspectRatio: 0.8, // Relación de aspecto
                        ),
                        itemCount: stockViewModel.stocks.length,
                        itemBuilder: (context, index) {
                          final stock = stockViewModel.stocks[index];

                          // Filtrar productos por búsqueda
                          if (_searchQuery.isNotEmpty &&
                              !stock.product.name
                                  .toLowerCase()
                                  .contains(_searchQuery)) {
                            return const SizedBox.shrink();
                          }

                          // Decodificar la imagen
                          final firstImageBase64 =
                              stock.images.isNotEmpty ? stock.images[0] : null;

                          return Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProductDetailScreen(
                                      product: stock.product,
                                      stocks: [stock],
                                    ),
                                  ),
                                );
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(12),
                                    ),
                                    child: firstImageBase64 != null
                                        ? Image.memory(
                                            base64Decode(
                                              cleanBase64(firstImageBase64)!,
                                            ),
                                            height: 120,
                                            width: double.infinity,
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stackTrace) =>
                                                    const SizedBox(
                                              height: 120,
                                              child: Center(
                                                child: Icon(
                                                  Icons
                                                      .image_not_supported_outlined,
                                                  size: 40,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ),
                                          )
                                        : const SizedBox(
                                            height: 120,
                                            child: Center(
                                              child: Icon(
                                                Icons.image_not_supported,
                                                size: 40,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          stock.product.name,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '\$${stock.price.toStringAsFixed(2)}',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13,
                                            color: Colors.blueAccent,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Stock: ${stock.quantity}',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
          BottomNavigationBarItem(
              icon: Icon(Icons.category), label: 'Categorías'),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart), label: 'Carrito'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        currentIndex: 1, // Índice para la categoría
        onTap: (index) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreen(initialIndex: index),
            ),
          );
        },
      ),
    );
  }
}
