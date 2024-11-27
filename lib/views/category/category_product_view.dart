import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:crochetify_movil/viewmodels/stock_viewmodel.dart';

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
      print("Iniciando carga de stocks para la categoría: ${widget.categoryId}");
      Provider.of<StockViewModel>(context, listen: false)
          .fetchStocksByCategory(widget.categoryId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final stockViewModel = Provider.of<StockViewModel>(context);

    print("Estado de carga: ${stockViewModel.isLoading}");
    print("Stocks cargados: ${stockViewModel.stocks}");
    print("Error en la carga: ${stockViewModel.errorMessage}");

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
      body: stockViewModel.isLoading
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
                          print("Reintentando carga de stocks...");
                          stockViewModel.fetchStocksByCategory(widget.categoryId);
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
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.all(8.0),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 8.0,
                        mainAxisSpacing: 8.0,
                        childAspectRatio: 0.8,
                      ),
                      itemCount: stockViewModel.stocks.length,
                      itemBuilder: (context, index) {
                        final stock = stockViewModel.stocks[index];

                        // Uso de imagen de marcador de posición si no hay imágenes disponibles
                        final firstImage = stock.images.isNotEmpty
                            ? stock.images[0]
                            : 'https://via.placeholder.com/150';

                        print("Renderizando stock: ${stock.product.name}");

                        return Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: InkWell(
                            onTap: () {
                              print("Stock seleccionado: ${stock.product.name}");
                              // Aquí puedes implementar navegación a una vista de detalles
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(10),
                                    ),
                                    child: Image.network(
                                      firstImage,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      errorBuilder: (context, error, stackTrace) {
                                        print("Error al cargar imagen: $error");
                                        return const Center(
                                          child: Icon(Icons.image_not_supported),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
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
    );
  }
}
