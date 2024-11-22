import 'package:crochetify_movil/widget/home/card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:crochetify_movil/widget/home/custom_buttom.dart';
import 'package:crochetify_movil/widget/home/carousel.dart';
import 'package:crochetify_movil/viewmodels/stock_viewmodel.dart';

class ProductList extends StatefulWidget {
  const ProductList({super.key});

  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  late Future<void> _fetchStocksFuture;

  @override
  void initState() {
    super.initState();
    // Usamos addPostFrameCallback para asegurarnos de que el contexto esté disponible.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchStocksFuture =
          Provider.of<StockViewModel>(context, listen: false).fetchStocks();
    });
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
          Expanded(
            child: StockGrid(),
          ),
        ],
      ),
    );
  }
}
