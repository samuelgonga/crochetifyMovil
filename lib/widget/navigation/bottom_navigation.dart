import 'package:flutter/material.dart';
import 'package:crochetify_movil/views/profile/profile_view.dart';
import 'package:crochetify_movil/views/home/home_view.dart';
import 'package:crochetify_movil/views/shipping/shipping_view.dart';
import 'package:crochetify_movil/views/cart/cart_view.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // Lista de vistas que se muestran según el índice seleccionado
  final List<Widget> _views = [
    const ProductList(),
    const ViewOrders(),
    CartScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Cambia el índice seleccionado
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _views[_selectedIndex], // Muestra la vista según el índice
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today), label: 'Calendario'),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart), label: 'Carrito'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex, // Índice seleccionado actualmente
        onTap: _onItemTapped, // Llama a _onItemTapped cuando se toca un ítem
      ),
    );
  }
}
