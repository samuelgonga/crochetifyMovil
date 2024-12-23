import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:crochetify_movil/views/cart/cart_empty_view.dart';
import 'package:crochetify_movil/views/profile/profile_view.dart';
import 'package:crochetify_movil/views/home/home_view.dart';
import 'package:crochetify_movil/views/shipping/shipping_view.dart';
import 'package:crochetify_movil/views/cart/cart_view.dart';
import 'package:crochetify_movil/views/login/login_view.dart';
import 'package:crochetify_movil/viewmodels/session_viewmodel.dart';
import 'package:crochetify_movil/viewmodels/cart_viewmodel.dart';
import 'package:crochetify_movil/widget/home/noLoging.dart';
import 'package:crochetify_movil/views/category/category_product_view.dart';
import 'package:crochetify_movil/views/category/category_view.dart';

class HomeScreen extends StatefulWidget {
  final int initialIndex; // Índice inicial para la pestaña activa

  const HomeScreen({Key? key, this.initialIndex = 0}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex; // Usa el índice inicial al cargar la pantalla
  }

  /// Maneja el cambio de pestañas en la barra de navegación
  void _onItemTapped(int index) {
    // Verifica si la pestaña seleccionada es la del carrito
    if (index == 2) {
      // Obtén el userId si está disponible
      final userId =
          Provider.of<AuthViewModel>(context, listen: false).user?.id;

      // Si el usuario está logueado, realiza el fetch del carrito
      if (userId != null) {
        final cartViewModel =
            Provider.of<CartViewModel>(context, listen: false);
        cartViewModel
            .fetchCart(userId); // Llama al método para actualizar el carrito
      }
    }

    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<AuthViewModel, CartViewModel>(
      builder: (context, authViewModel, cartViewModel, child) {
        // Verifica si el usuario está autenticado
        final bool isLoggedIn = authViewModel.isLoggedIn;

        // Obtén el userId del AuthViewModel
        final int? userId = authViewModel.user?.id;

        // Verifica si hay productos en el carrito
        final bool cartHasProducts =
            cartViewModel.cartProducts.isNotEmpty; // Verifica la lista de productos

        // Vistas para usuarios autenticados
        final List<Widget> _viewsLogin = [
          const ProductList(), // Página de productos
          CategoryScreen(), // Página de categorías
          cartHasProducts && userId != null
              ? CartView(userId: userId) // Se asegura de que userId no sea nulo
              : CartEmpty(), // Página del carrito vacío
          ProfileScreen(), // Página del perfil
        ];

        // Vistas para usuarios no autenticados
        final List<Widget> _views = [
          const ProductList(), // Página de productos
          LoginPromptWidget(), // Mensaje de inicio de sesión requerido
          LoginPromptWidget(), // Mensaje de inicio de sesión requerido
          LoginView(), // Vista de inicio de sesión
        ];

        // Cambia dinámicamente las vistas según el estado de autenticación
        final List<Widget> currentViews = isLoggedIn ? _viewsLogin : _views;

        return Scaffold(
          body: currentViews[_selectedIndex],
          bottomNavigationBar: BottomNavigationBar(
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.category), label: 'Categorías'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.shopping_cart), label: 'Carrito'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.person), label: 'Perfil'),
            ],
            selectedItemColor: Colors.blue,
            unselectedItemColor: Colors.grey,
            currentIndex: _selectedIndex,
            onTap: _onItemTapped, // Al seleccionar una pestaña, se ejecuta el onTap
          ),
        );
      },
    );
  }
}
