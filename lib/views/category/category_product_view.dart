import 'dart:convert'; // Para decodificar imágenes Base64
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
  @override
  void initState() {
    super.initState();
    // Ejecuta la carga inicial de los stocks de forma segura
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<StockViewModel>(context, listen: false)
          .fetchStocksByCategory(widget.categoryId);
    });
  }
  Future<void> _refreshStocks(BuildContext context) async {
  try {
    await Provider.of<StockViewModel>(context, listen: false)
        .fetchStocksByCategory(widget.categoryId); // Refresca los productos
  } catch (e) {
    // Mostrar un AlertDialog en caso de error
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0)),
          title: Row(
            children: [
              const Icon(Icons.error, color: Colors.red, size: 30),
              const SizedBox(width: 10),
              const Text('Error'),
            ],
          ),
          content: Text(
            'Error al refrescar los productos: $e',
            style: const TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Aceptar',
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
            ),
          ],
        );
      },
    );
  }
}

@override
Widget build(BuildContext context) {
  final stockViewModel = Provider.of<StockViewModel>(context);

  return Scaffold(
    appBar: AppBar(
      title: Text(
        widget.categoryTitle,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.of(context).pop(),
      ),
    ),
    body: RefreshIndicator(
      onRefresh: () => _refreshStocks(context), // Conecta al método de refresco
      child: stockViewModel.isLoading
          ? const Center(child: CircularProgressIndicator())
          : stockViewModel.errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error, color: Colors.red, size: 60),
                      const SizedBox(height: 10),
                      Text(
                        "Error: ${stockViewModel.errorMessage}",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          stockViewModel
                              .fetchStocksByCategory(widget.categoryId);
                        },
                        child: const Text("Reintentar"),
                      ),
                    ],
                  ),
                )
              : stockViewModel.stocks.isEmpty
                  ? const Center(
                      child: Text(
                        "No hay productos disponibles en esta categoría.",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.all(8.0),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 8.0,
                        mainAxisSpacing: 8.0,
                        childAspectRatio: 0.8,
                      ),
                      itemCount: stockViewModel.stocks.length,
                      itemBuilder: (context, index) {
                        final stock = stockViewModel.stocks[index];

                        // Decodificación de la primera imagen en Base64
                        final firstImageBase64 = stock.images.isNotEmpty
                            ? stock.images[0]
                            : null;

                        return Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: InkWell(
                            onTap: () {
                              // Navegación a la vista de detalles del producto
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProductDetailScreen(
                                    product: stock.product,
                                    stocks: [
                                      stock
                                    ], // Pasar el stock seleccionado
                                  ),
                                ),
                              );
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(10),
                                    ),
                                    child: firstImageBase64 != null
                                        ? Image.memory(
                                            base64Decode(
                                              firstImageBase64.replaceFirst(
                                                  'data:image/jpeg;base64,',
                                                  ''),
                                            ),
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                              return const Center(
                                                child: Icon(Icons
                                                    .image_not_supported),
                                              );
                                            },
                                          )
                                        : const Center(
                                            child: Icon(
                                                Icons.image_not_supported),
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
                                        stock.product.description,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Precio: \$${stock.price.toStringAsFixed(2)}',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Cantidad: ${stock.quantity}',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.black87,
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
  );
}
}