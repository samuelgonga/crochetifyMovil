import 'dart:convert'; // Import para decodificar Base64
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:crochetify_movil/viewmodels/stock_viewmodel.dart';
import 'package:crochetify_movil/views/home/detail_view.dart';
import 'package:crochetify_movil/models/stock.dart';

class StockGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<StockViewModel>(builder: (context, stockViewModel, child) {
      if (stockViewModel.isLoading) {
        return const Center(child: CircularProgressIndicator());
      }
      if (stockViewModel.stocks.isEmpty) {
        return const Center(child: Text('No hay stocks disponibles'));
      }
      // Agrupar los stocks por `idProduct`
      Map<int, List<Stock>> groupedStocks = {};
      for (var stock in stockViewModel.stocks) {
        final productId = stock.product.idProduct;
        if (!groupedStocks.containsKey(productId)) {
          groupedStocks[productId] = [];
        }
        groupedStocks[productId]?.add(stock);
      }

      return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.85, // Ajusta la proporción de cada celda
          crossAxisSpacing: 4.0, // Espaciado entre columnas
          mainAxisSpacing: 4.0, // Espaciado entre filas
        ),
        itemCount: groupedStocks.length,
        itemBuilder: (context, index) {
          final productId = groupedStocks.keys.toList()[index];
          final productStocks = groupedStocks[productId]!;

          final stock = productStocks.first;
          final firstImageBase64 =
              stock.images.isNotEmpty ? stock.images[0] : null;

          return Container(
            margin: EdgeInsets.zero, // Sin margen adicional
            child: Card(
              elevation: 2, // Reducción de la sombra del `Card`
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
                  mainAxisSize: MainAxisSize.min, // Ajusta el tamaño de la columna
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(4)),
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
                      padding: const EdgeInsets.all(8.0), // Reducción del padding
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
        },
      );
    });
  }
}
