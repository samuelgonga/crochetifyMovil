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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CategoryViewModel>(context, listen: false)
          .initializeCategories();
    });
  }

  Color getRandomColor() {
    Random random = Random();
    return Color.fromRGBO(
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
      1,
    );
  }

  Future<void> _refreshCategories(BuildContext context) async {
    try {
      await Provider.of<CategoryViewModel>(context, listen: false)
          .fetchCategories();
    } catch (e) {
      _showAlert(
        context,
        title: 'Error',
        message: 'Error al refrescar categorías: $e',
        icon: Icons.error,
        iconColor: Colors.red,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoryViewModel = Provider.of<CategoryViewModel>(context);

    return Scaffold(
      body: Stack(
        children: [
          // Fondo azul detrás de las categorías
          Container(
            height: 200,
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 113, 191, 254),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
          ),
          Column(
            children: [
              const SizedBox(height: 40),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  'Categorías',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () => _refreshCategories(context),
                  child: categoryViewModel.isLoading
                      ? const Center(child: CircularProgressIndicator(color: Colors.blue))
                      : categoryViewModel.errorMessage != null
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.error,
                                      color: Colors.red, size: 60),
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
                                    onPressed:
                                        categoryViewModel.fetchCategories,
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
                                    itemCount:
                                        categoryViewModel.categories.length,
                                    itemBuilder: (context, index) {
                                      final category = categoryViewModel
                                          .categories[index];
                                      return Card(
                                        elevation: 3,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: ListTile(
                                          contentPadding:
                                              const EdgeInsets.all(10.0),
                                          leading: CircleAvatar(
                                            backgroundColor: getRandomColor(),
                                            child: Text(
                                              category.name
                                                  .substring(0, 1)
                                                  .toUpperCase(),
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
                                                builder: (context) =>
                                                    CategoryProductView(
                                                  categoryTitle: category.name,
                                                  categoryId:
                                                      category.idCategory,
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      );
                                    },
                                  ),
                                ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showAlert(
    BuildContext context, {
    required String title,
    required String message,
    required IconData icon,
    required Color iconColor,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          title: Row(
            children: [
              Icon(icon, color: iconColor, size: 30),
              const SizedBox(width: 10),
              Text(title),
            ],
          ),
          content: Text(
            message,
            style: const TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Aceptar',
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
            ),
          ],
        );
      },
    );
  }
}
