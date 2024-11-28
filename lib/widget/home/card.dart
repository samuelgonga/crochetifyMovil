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
          childAspectRatio: 0.8,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
        ),
        itemCount: groupedStocks.length,
        itemBuilder: (context, index) {
          final productId = groupedStocks.keys.toList()[index];
          final productStocks = groupedStocks[productId]!;

          final stock = productStocks.first;
          final firstImage = stock.images.isNotEmpty ? stock.images[0] : '';

          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 4.0),
            child: Card(
              elevation: 4,
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(4)),
                        child: Image.network(
                          firstImage,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          errorBuilder: (context, error, stackTrace) =>
                              const Center(
                            child: Icon(Icons.image_not_supported),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Text(
                              stock.product.name,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            stock.product.description,
                            style: const TextStyle(
                                fontSize: 8, color: Colors.black87),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: productStocks.map((stock) {
                              return Container(
                                margin: const EdgeInsets.only(right: 4.0),
                                width: 16.0,
                                height: 16.0,
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
                                  fontSize: 14),
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
