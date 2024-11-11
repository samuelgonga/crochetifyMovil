import 'package:flutter/material.dart';
import 'package:crochetify_movil/models/category.dart';
import 'package:crochetify_movil/views/profile/category_product_view.dart';

class CategoryScreen extends StatefulWidget {
  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoryScreen> {
  List<Category> categories = [
    Category(id: 1, name: 'Videojuegos', status: 1),
    Category(id: 2, name: 'Caricaturas', status: 1),
    Category(id: 3, name: 'Peliculas', status: 1),
    Category(id: 4, name: 'Anime', status: 1),
    Category(id: 5, name: 'Animales', status: 1),
    Category(id: 6, name: 'Fantasia', status: 1),
    Category(id: 7, name: 'Monstruos', status: 1),
    Category(id: 8, name: 'Flores', status: 1),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Categorias',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.only(
            top: 30.0), // Ajusta el valor para más o menos espacio
        child: ListView.builder(
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            return ListTile(
              title: Text(
                category.name,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              trailing: Icon(
                Icons.arrow_forward_rounded,
                color: Colors.blue,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CategoryProductView(),
                  ),
                );
              },
            );
          },
        ),
      ),
      //bottomNavigationBar: HomeScreen(),
    );
  }
}
