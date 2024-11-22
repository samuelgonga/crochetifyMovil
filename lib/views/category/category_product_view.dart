import 'package:flutter/material.dart';
import 'package:crochetify_movil/models/product.dart';
import 'package:crochetify_movil/services/product_service.dart';

class CategoryProductView extends StatefulWidget {
  const CategoryProductView({super.key});

  @override
  _CategoryProductViewState createState() => _CategoryProductViewState();
}

class _CategoryProductViewState extends State<CategoryProductView> {
  late Future<List<Product>> _fetchProductsFuture;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _fetchProductsFuture = ProductService().fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Productos'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Column(
        children: [
          // Campo de búsqueda
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Buscar productos...',
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                prefixIcon: const Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              },
            ),
          ),
          // FutureBuilder para mostrar la lista de productos
          Expanded(
            child: FutureBuilder<List<Product>>(
              future: _fetchProductsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      "Error al cargar los productos:\n${snapshot.error}",
                      textAlign: TextAlign.center,
                    ),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text("No hay productos disponibles"),
                  );
                } else {
                  // Filtra productos según la búsqueda
                  final filteredProducts = snapshot.data!.where((product) {
                    return product.name.toLowerCase().contains(_searchQuery);
                  }).toList();

                  return filteredProducts.isEmpty
                      ? const Center(
                          child: Text("No se encontraron productos"),
                        )
                      : GridView.builder(
                          padding: const EdgeInsets.all(8.0),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, // Dos tarjetas por fila
                            crossAxisSpacing: 5.0,
                            mainAxisSpacing: 5.0,
                            childAspectRatio: 0.75,
                          ),
                          itemCount: filteredProducts.length,
                          itemBuilder: (context, index) {
                            final product = filteredProducts[index];
                            return Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                              elevation: 5.0,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Imagen del producto
                                  Container(
                                    height: 100.0,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(16.0),
                                        topRight: Radius.circular(16.0),
                                      ),
                                      image: DecorationImage(
                                        image: AssetImage(
                                            'assets/images/ness.jpeg'),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Nombre del producto
                                        Text(
                                          product.name,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16.0,
                                          ),
                                        ),
                                        const SizedBox(height: 10.0),
                                        // Descripción del producto
                                        Text(
                                          product.description,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 12.0,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        const SizedBox(height: 10.0),
                                        // Precio
                                        Text(
                                          '\$235', // Ajusta con el precio real si está disponible
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16.0,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Botón de añadir al carrito
                                  Align(
                                    alignment: Alignment.bottomRight,
                                    child: Container(
                                      width: 50.0, // Ancho del contenedor
                                      height: 50.0, // Alto del contenedor
                                      decoration: BoxDecoration(
                                        shape:
                                            BoxShape.circle, // Forma circular
                                        color: Colors.blue.withOpacity(
                                            0.08), // Color de fondo opcional
                                      ),
                                      child: IconButton(
                                        iconSize: 40.0, // Tamaño del ícono
                                        icon: const Icon(
                                          Icons.add_circle,
                                          color: Colors.blue,
                                        ),
                                        onPressed: () {
                                          // Acción al añadir al carrito
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
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
