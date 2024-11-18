import 'package:crochetify_movil/views/home/home_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:crochetify_movil/viewmodels/product_viewmodel.dart';
import 'package:crochetify_movil/viewmodels/user_viewmodel.dart';
import 'viewmodels/session_viewmodel.dart';
import 'widget/navigation/bottom_navigation.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()..checkSession()),
        ChangeNotifierProvider(create: (_) => ProductViewModel()),
        ChangeNotifierProvider(
            create: (_) => UserViewModel()), // Añadir UserViewModel aquí
      ],
      child: MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: HomeScreen(),
      ),
    );
  }
}
