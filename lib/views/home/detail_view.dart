import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:crochetify_movil/models/product.dart';

class ProductDetail extends StatefulWidget {
  final Product product;

  const ProductDetail({super.key, required this.product});

  @override
  _ProductDetailState createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  int _selectedColorIndex = 0; // Para manejar el índice del color seleccionado
  int _currentImageIndex = 0; // Para manejar el índice de la imagen actual

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalles del Producto'),
        actions: [
          // Estrella de valoración en el AppBar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                const Icon(Icons.star, color: Colors.yellow, size: 34),
                const SizedBox(width: 4),
                Text(
                  "${product.valoracion}",
                  style: const TextStyle(color: Colors.black, fontSize: 24),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Carrusel de imágenes del color seleccionado
              if (product.imagenesPorColor.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius:
                          BorderRadius.circular(16.0), // Borde redondeado
                      child: CarouselSlider(
                        options: CarouselOptions(
                          height: 250,
                          autoPlay: true,
                          enlargeCenterPage: true,
                          onPageChanged: (index, reason) {
                            setState(() {
                              _currentImageIndex =
                                  index; // Actualiza el índice de la imagen actual
                            });
                          },
                        ),
                        items: product
                            .imagenesPorColor[_selectedColorIndex].imagenes
                            .map((imageUrl) => Builder(
                                  builder: (BuildContext context) {
                                    return Image.network(
                                      imageUrl,
                                      width: MediaQuery.of(context).size.width,
                                      fit: BoxFit.cover,
                                    );
                                  },
                                ))
                            .toList(),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Puntos del carrusel
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        product.imagenesPorColor[_selectedColorIndex].imagenes
                            .length,
                        (index) {
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 3),
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: index == _currentImageIndex
                                  ? Colors.blue
                                  : Colors.grey,
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Selección de colores
                    Center(
                      child: Wrap(
                        spacing: 8.0,
                        children: product.imagenesPorColor
                            .asMap()
                            .entries
                            .map((entry) {
                          int index = entry.key;
                          String color = entry.value.color;
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedColorIndex =
                                    index; // Cambiar el color seleccionado
                                _currentImageIndex =
                                    0; // Reinicia el índice de imagen al cambiar de color
                              });
                            },
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(int.parse(
                                        '0xff${entry.value.colorHex.substring(1)}')), // Color del círculo
                                    border: Border.all(
                                      color: _selectedColorIndex == index
                                          ? const Color.fromARGB(255, 248, 248,
                                              248) // Color del borde
                                          : const Color.fromARGB(255, 83, 81,
                                              81), // Color del borde cuando no está seleccionado
                                      width: 0.5,
                                    ),
                                  ),
                                  width: 40,
                                  height: 40,
                                ),
                                if (_selectedColorIndex ==
                                    index) // Muestra la palomita solo si está seleccionado
                                  const Icon(
                                    Icons.check,
                                    color: Colors.white, // Color de la palomita
                                    size: 24, // Tamaño del icono
                                  ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),

              const SizedBox(height: 16),
              // Nombre y precio
              Center(
                child: Text(
                  product.name,
                  textAlign: TextAlign.center, // Alineación centrada
                  style: const TextStyle(
                    fontWeight: FontWeight.bold, // Texto en negrita
                    fontSize: 25, // Ajusta el tamaño según lo necesites
                  ),
                ),
              ),
              // Center(
              //   child: Text(
              //     '\$${product.precio.toStringAsFixed(2)}', //Comentare esto
              //     textAlign: TextAlign.center, // Alineación centrada
              //     style: const TextStyle(
              //         fontWeight: FontWeight.bold, // Texto en negrita
              //         fontSize: 22, // Ajusta el tamaño según lo necesites
              //         color: Colors.blue),
              //   ),
              // ),
              // Descripción
              const SizedBox(height: 16),
              Text(product.description),
              const SizedBox(height: 16),

              // Comentarios
              if (product.comentariosProducto.isNotEmpty) ...[
                const Text(
                  "Comentarios:",
                  style: TextStyle(
                    fontWeight: FontWeight.bold, // Texto en negrita
                    fontSize: 20, // Ajusta el tamaño según lo necesites
                  ),
                ),
                const SizedBox(height: 8),
                Column(
                  children: product.comentariosProducto
                      .map((comentario) => Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 4.0), // Margen entre comentarios
                            padding:
                                const EdgeInsets.all(8.0), // Espaciado interno
                            decoration: BoxDecoration(
                              color: Colors.blue[50], // Fondo azul claro
                              borderRadius: BorderRadius.circular(
                                  8.0), // Bordes redondeados
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.comment),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(comentario.comentario),
                                      Row(
                                        children: [
                                          const Icon(Icons.star,
                                              color: Colors.yellow,
                                              size: 16), // Estrella
                                          const SizedBox(width: 4),
                                          Text(
                                              "Valoración: ${comentario.valoracion}"),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ))
                      .toList(),
                ),
                // Al final de tu Column
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '\$${product.precio.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Colors.green, // Color verde
                        fontSize: 18, // Tamaño del texto
                        fontWeight: FontWeight.bold, // Negrita
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: () {
                            // Lógica para disminuir la cantidad
                          },
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5.0, vertical: 8.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                                8.0), // Bordes redondeados
                          ),
                          child: const Text(
                            '1', // Aquí puedes manejar el estado para mostrar la cantidad actual
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () {
                            // Lógica para aumentar la cantidad
                          },
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Lógica para agregar al carrito
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue, // Color del botón
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 12.0), // Padding del botón
                      ),
                      child: const Row(
                        children: [
                          Text(
                            'Agregar al carrito',
                            style: TextStyle(
                                color: Colors.white), // Color de la letra
                          ),
                          SizedBox(width: 8),
                          Icon(Icons.arrow_forward,
                              color: Colors.white), // Flecha hacia la derecha
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
