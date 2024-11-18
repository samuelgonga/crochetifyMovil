import 'package:flutter/material.dart';
import 'package:crochetify_movil/views/profile/profile_view.dart';
import 'package:crochetify_movil/views/home/home_view.dart';
import 'package:crochetify_movil/views/shipping/shipping_view.dart';
import 'package:crochetify_movil/views/cart/cart_view.dart';
import 'package:crochetify_movil/views/login/login_view.dart';
import 'package:provider/provider.dart';
import 'package:crochetify_movil/viewmodels/session_viewmodel.dart';
import 'package:crochetify_movil/widget/home/noLoging.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _viewsLogin = [
    const ProductList(),
    const ViewOrders(),
    CartView(),
    ProfileScreen(),
  ];

  final List<Widget> _views = [
    const ProductList(),
    LoginPromptWidget(),
    LoginPromptWidget(),
    LoginView(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthViewModel>(
      builder: (context, authViewModel, child) {
        if (authViewModel.isLoggedIn) {
          return Scaffold(
            body: _viewsLogin[_selectedIndex],
            bottomNavigationBar: BottomNavigationBar(
              items: const [
                BottomNavigationBarItem(
                    icon: Icon(Icons.home), label: 'Inicio'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.calendar_today), label: 'Envíos'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.shopping_cart), label: 'Carrito'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.person), label: 'Perfil'),
              ],
              selectedItemColor: Colors.blue,
              unselectedItemColor: Colors.grey,
              currentIndex: _selectedIndex,
              onTap: _onItemTapped,
            ),
          );
        } else {
          return Scaffold(
            body: _views[_selectedIndex],
            bottomNavigationBar: BottomNavigationBar(
              items: const [
                BottomNavigationBarItem(
                    icon: Icon(Icons.home), label: 'Inicio'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.calendar_today), label: 'Envíos'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.shopping_cart), label: 'Carrito'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.person), label: 'Perfil'),
              ],
              selectedItemColor: Colors.blue,
              unselectedItemColor: Colors.grey,
              currentIndex: _selectedIndex,
              onTap: _onItemTapped,
            ),
          );
        }
      },
    );
  }
}
