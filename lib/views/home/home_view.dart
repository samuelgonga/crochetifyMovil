import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:crochetify_movil/viewmodels/stock_viewmodel.dart';
import 'package:crochetify_movil/widget/home/custom_buttom.dart';
import 'package:crochetify_movil/widget/home/carousel.dart';
import 'package:crochetify_movil/widget/home/card.dart';

class ProductList extends StatefulWidget {
  const ProductList({Key? key}) : super(key: key);

  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  String _searchQuery = ""; // Texto de búsqueda

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<StockViewModel>(context, listen: false)
          .fetchStocksByCategory(0);
    });
  }

  Future<void> _refreshStocks(BuildContext context) async {
    try {
      await Provider.of<StockViewModel>(context, listen: false)
          .fetchStocksByCategory(0); // Refresca los productos
    } catch (e) {
      _showAlert(
        context,
        title: 'Error',
        message: 'Error al refrescar productos: $e',
        icon: Icons.error,
        iconColor: Colors.red,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fondo azul
          Container(
            height: 350,
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 113, 191, 254), // Fondo azul claro
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
          ),
          Column(
            children: [
              const SizedBox(height: 60), // Espaciado para la barra de estado
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 16.0, horizontal: 20.0), // Ajuste horizontal
                child: Container(
                  height: 50, // Altura mejorada para la barra de búsqueda
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value.toLowerCase();
                      });
                    },
                    decoration: const InputDecoration(
                      hintText: 'Buscar...',
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.search, color: Colors.grey),
                      contentPadding: EdgeInsets.symmetric(vertical: 14.0),
                    ),
                  ),
                ),
              ),
              const Center(
                child: ImageCarousel(imageUrls: [
                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSLjweO621wvjrO9HHSo1isiOTylj863MH8og&s',
                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSjLuwuNoCuQRGEk5CGHX27AJpCAXE-ZEQi-w&s',
                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSjNvdGJI4KEWPt6udwktpY9sU4MAde0c5z0w&s',
                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR1tk9RcAATj7yolyR0XwmunPH676MejY7n7g&s'
                ]),
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () => _refreshStocks(context),
                  child: StockGrid(searchQuery: _searchQuery),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showAlert(
    BuildContext context, {
    required String title,
    required String message,
    required IconData icon,
    required Color iconColor,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          title: Row(
            children: [
              Icon(icon, color: iconColor, size: 30),
              const SizedBox(width: 10),
              Text(title),
            ],
          ),
          content: Text(
            message,
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
