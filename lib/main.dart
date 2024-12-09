import 'package:crochetify_movil/viewmodels/order_viewmodel.dart';
import 'package:crochetify_movil/viewmodels/shipment_viewmodel.dart';
import 'package:crochetify_movil/views/cart/cart_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:crochetify_movil/viewmodels/product_viewmodel.dart';
import 'package:crochetify_movil/viewmodels/user_viewmodel.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:crochetify_movil/viewmodels/session_viewmodel.dart';
import 'package:crochetify_movil/widget/navigation/bottom_navigation.dart';
import 'package:crochetify_movil/viewmodels/stock_viewmodel.dart';
import 'package:crochetify_movil/viewmodels/category_viewmodel.dart';
import 'package:crochetify_movil/services/product_service.dart';
import 'package:crochetify_movil/services/cart_service.dart';
import 'package:crochetify_movil/viewmodels/cart_viewmodel.dart';
import 'package:crochetify_movil/viewmodels/comment_viewmodel.dart';
import 'package:crochetify_movil/services/comment_service.dart';
import 'package:crochetify_movil/views/profile/direction_view.dart';
import 'package:crochetify_movil/views/profile/direction_create_view.dart';
import 'package:crochetify_movil/views/cart/choose_direction.dart';

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
        ChangeNotifierProvider(
            create: (_) => ProductViewModel(ProductService())),
        ChangeNotifierProvider(create: (_) => UserViewModel()),
        ChangeNotifierProvider(create: (_) => CategoryViewModel()),
        ChangeNotifierProvider(
          create: (_) => CartViewModel(cartService: CartService()),
        ),
        ChangeNotifierProvider(
          create: (_) => OrderViewmodel(),
        ),
        ChangeNotifierProvider(create: (_) => ShipmentViewModel()),
        ChangeNotifierProvider(
          create: (_) => ReviewViewModel(
            reviewService: CommentService(),
          ),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: HomeScreen(),
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case '/direction':
              return MaterialPageRoute(
                builder: (context) => DirectionView(),
              );
            case '/addDirection':
              return MaterialPageRoute(
                builder: (context) => DirectionForm(),
              );
            case '/cart':
              final userId = settings.arguments as int;
              return MaterialPageRoute(
                builder: (context) => CartView(userId: userId),
              );
            case '/selectDirection':
              final userId = settings.arguments as int;
              return MaterialPageRoute(
                builder: (context) => SelectDirectionView(userId: userId),
              );
            default:
              return MaterialPageRoute(
                builder: (context) => HomeScreen(),
              );
          }
        },
      ),
    );
  }
}
