import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:crochetify_movil/viewmodels/product_viewmodel.dart';
import 'package:crochetify_movil/viewmodels/user_viewmodel.dart';
import 'viewmodels/session_viewmodel.dart';
import 'widget/navigation/bottom_navigation.dart';
import 'viewmodels/stock_viewmodel.dart';
import 'services/stock_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void fetchStocks() async {
  final url = Uri.parse(
      'http://localhost:8080/api/crochetify/stock'); // Cambia según tu caso
  try {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      // Decodifica la respuesta JSON
      final data = jsonDecode(response.body);
      print('Stocks recibidos: $data');
    } else {
      // Maneja errores del servidor
      print('Error del servidor: ${response.statusCode}');
    }
  } catch (e) {
    // Maneja errores de red
    print('Error de red o servidor: $e');
  }
}

void main() {
  fetchStocks();
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
