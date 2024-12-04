import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:crochetify_movil/viewmodels/stock_viewmodel.dart';
import 'package:crochetify_movil/views/home/detail_view.dart';
import 'package:crochetify_movil/models/stock.dart';

class StockGrid extends StatelessWidget {
  final String searchQuery;

  StockGrid({Key? key, required this.searchQuery}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<StockViewModel>(
      builder: (context, stockViewModel, child) {
        if (stockViewModel.isLoading) {
          return const Center(child: CircularProgressIndicator(color: Colors.blue));
        }
        if (stockViewModel.stocks.isEmpty) {
          return const Center(child: Text('No hay stocks disponibles'));
        }

        // Filtrar stocks según el `searchQuery`
        final filteredStocks = stockViewModel.stocks.where((stock) {
          final productName = stock.product.name.toLowerCase();
          final query = searchQuery.toLowerCase();
          return productName.contains(query);
        }).toList();

        if (filteredStocks.isEmpty) {
          return const Center(child: Text('No se encontraron resultados'));
        }

        // Agrupar los stocks filtrados por `idProduct`
        final groupedStocks = _groupStocksByProductId(filteredStocks);

        return GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.8, // Proporción de las celdas
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
          ),
          itemCount: groupedStocks.length,
          padding: const EdgeInsets.symmetric(
              horizontal: 8.0, vertical: 0.0),
          itemBuilder: (context, index) {
            final productId = groupedStocks.keys.toList()[index];
            final productStocks = groupedStocks[productId]!;
            final stock = productStocks.first; // Usar el primer stock como base
            final firstImageBase64 =
                stock.images.isNotEmpty ? stock.images[0] : null;

            return _buildStockCard(
              context: context,
              stock: stock,
              productStocks: productStocks,
              firstImageBase64: firstImageBase64,
            );
          },
        );
      },
    );
  }

  // Método para agrupar stocks por idProduct
  Map<int, List<Stock>> _groupStocksByProductId(List<Stock> stocks) {
    final groupedStocks = <int, List<Stock>>{};
    for (var stock in stocks) {
      final productId = stock.product.idProduct;
      groupedStocks.putIfAbsent(productId, () => []).add(stock);
    }
    return groupedStocks;
  }

  // Método para construir un Card de Stock
  Widget _buildStockCard({
    required BuildContext context,
    required Stock stock,
    required List<Stock> productStocks,
    required String? firstImageBase64,
  }) {
    return Container(
      margin: EdgeInsets.zero,
      child: Card(
        elevation: 2,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductDetailScreen(
                  product: stock.product,
                  stocks: productStocks,
                ),
              ),
            );
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(4)),
                  child: firstImageBase64 != null
                      ? Image.memory(
                          base64Decode(
                            firstImageBase64.replaceFirst(
                                'data:image/jpeg;base64,', ''),
                          ),
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
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        stock.product.name,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      stock.product.description,
                      style: const TextStyle(
                          fontSize: 10, color: Colors.black87),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: productStocks.map((stock) {
                        return Container(
                          margin: const EdgeInsets.only(right: 2.0),
                          width: 12.0,
                          height: 12.0,
                          decoration: BoxDecoration(
                            color: Color(int.parse(
                                '0xff${stock.color.substring(1)}')),
                            shape: BoxShape.circle,
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 8),
                    Center(
                      child: Text(
                        '\$${stock.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
