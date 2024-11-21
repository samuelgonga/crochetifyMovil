import 'package:crochetify_movil/views/login/login_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:crochetify_movil/viewmodels/product_viewmodel.dart';
import 'package:crochetify_movil/viewmodels/user_viewmodel.dart';
import 'package:flutter_stripe/flutter_stripe.dart'; // Importa el paquete de Stripe
import 'viewmodels/session_viewmodel.dart';
import 'widget/navigation/bottom_navigation.dart';
import 'viewmodels/stock_viewmodel.dart';

void main() {
  // Asegura que los plugins se inicializan correctamente
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa Stripe con tu clave pública de prueba
  Stripe.publishableKey =
      'pk_test_51P0B7yIweajk9UR5c7fsrfhPDgEuiztt2ayVoPhHQ8WSNFz3dzLr6ismE4QPQxFAFvPlvg33NPvbMjlQD3tFzepB007z42Ukd9'; // Reemplaza con tu clave pública de Stripe

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => StockViewModel()),
        ChangeNotifierProvider(create: (_) => AuthViewModel()..checkSession()),
        ChangeNotifierProvider(create: (_) => ProductViewModel()),
        ChangeNotifierProvider(create: (_) => UserViewModel()),
      ],
      child: MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: LoginView(),
      ),
    );
  }
}
