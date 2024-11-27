import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:crochetify_movil/viewmodels/product_viewmodel.dart';
import 'package:crochetify_movil/viewmodels/user_viewmodel.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'viewmodels/session_viewmodel.dart';
import 'widget/navigation/bottom_navigation.dart';
import 'viewmodels/stock_viewmodel.dart';
import 'viewmodels/category_viewmodel.dart'; // Importa el CategoryViewModel
import 'services/product_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  Stripe.publishableKey =
      'pk_test_51P0B7yIweajk9UR5c7fsrfhPDgEuiztt2ayVoPhHQ8WSNFz3dzLr6ismE4QPQxFAFvPlvg33NPvbMjlQD3tFzepB007z42Ukd9';

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
        ChangeNotifierProvider(create: (_) => ProductViewModel(ProductService())),
        ChangeNotifierProvider(create: (_) => UserViewModel()),
        ChangeNotifierProvider(create: (_) => CategoryViewModel()), // Registra el CategoryViewModel
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: HomeScreen(),
      ),
    );
  }
}
