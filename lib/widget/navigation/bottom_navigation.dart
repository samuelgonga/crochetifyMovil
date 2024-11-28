import 'package:crochetify_movil/views/category/category_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:crochetify_movil/views/profile/profile_view.dart';
import 'package:crochetify_movil/views/home/home_view.dart';
import 'package:crochetify_movil/views/shipping/shipping_view.dart';
import 'package:crochetify_movil/views/cart/cart_view.dart';
import 'package:crochetify_movil/views/login/login_view.dart';
import 'package:crochetify_movil/viewmodels/session_viewmodel.dart';
import 'package:crochetify_movil/widget/home/noLoging.dart';
import 'package:crochetify_movil/views/category/category_product_view.dart';
import 'package:crochetify_movil/views/category/category_view.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // Vistas para usuarios autenticados
  final List<Widget> _viewsLogin = [
    const ProductList(), // Página de productos
    CategoryScreen(),
    //CategoryProductView(),
    CartView(
      cartId: 5,
    ), // Página del carrito
    ProfileScreen(), // Página del perfil
  ];

  // Vistas para usuarios no autenticados
  final List<Widget> _views = [
    const ProductList(), // Página de productos
    LoginPromptWidget(), // Mensaje de inicio de sesión requerido
    LoginPromptWidget(), // Mensaje de inicio de sesión requerido
    LoginView(), // Vista de inicio de sesión
  ];

  /// Maneja el cambio de pestañas en la barra de navegación
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthViewModel>(
      builder: (context, authViewModel, child) {
        // Verifica si el usuario está autenticado
        final bool isLoggedIn = authViewModel.isLoggedIn;

        // Cambia dinámicamente las vistas según el estado de autenticación
        final List<Widget> currentViews = isLoggedIn ? _viewsLogin : _views;

        return Scaffold(
          body: currentViews[_selectedIndex],
          bottomNavigationBar: BottomNavigationBar(
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.category), label: 'Categorias'),
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
      },
    );
  }
}
