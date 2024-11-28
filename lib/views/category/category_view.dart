import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:crochetify_movil/viewmodels/category_viewmodel.dart';
import 'package:crochetify_movil/views/category/category_product_view.dart';
import 'dart:math';

class CategoryScreen extends StatefulWidget {
  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  @override
  void initState() {
    super.initState();
    // Inicializa las categorías de forma segura después de que se construya el widget
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CategoryViewModel>(context, listen: false).initializeCategories();
    });
  }

  // Función para generar colores aleatorios
  Color getRandomColor() {
    Random random = Random();
    return Color.fromRGBO(
      random.nextInt(256), // Rojo
      random.nextInt(256), // Verde
      random.nextInt(256), // Azul
      1, // Opacidad
    );
  }

  @override
  Widget build(BuildContext context) {
    final categoryViewModel = Provider.of<CategoryViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Categorías',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: categoryViewModel.isLoading
          ? const Center(child: CircularProgressIndicator())
          : categoryViewModel.errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error, color: Colors.red, size: 60),
                      const SizedBox(height: 10),
                      Text(
                        categoryViewModel.errorMessage!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: categoryViewModel.fetchCategories,
                        child: const Text("Reintentar"),
                      ),
                    ],
                  ),
                )
              : categoryViewModel.categories.isEmpty
                  ? const Center(
                      child: Text(
                        "No hay categorías disponibles.",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 20.0,
                        horizontal: 10.0,
                      ),
                      child: ListView.builder(
                        itemCount: categoryViewModel.categories.length,
                        itemBuilder: (context, index) {
                          final category = categoryViewModel.categories[index];
                          return Card(
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(10.0),
                              leading: CircleAvatar(
                                backgroundColor: getRandomColor(), // Color aleatorio
                                child: Text(
                                  category.name.substring(0, 1).toUpperCase(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              title: Text(
                                category.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              trailing: const Icon(
                                Icons.arrow_forward_rounded,
                                color: Colors.blue,
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CategoryProductView(
                                      categoryTitle: category.name,
                                      categoryId: category.idCategory,
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
    );
  }
}
