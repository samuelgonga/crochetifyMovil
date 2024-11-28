import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'package:image/image.dart' as img;
import 'dart:typed_data';

Future<String?> compressAndConvertImageToBase64(File imageFile) async {
  try {
    final bytes = await imageFile.readAsBytes();

    img.Image? image = img.decodeImage(Uint8List.fromList(bytes));

    if (image != null) {
      List<int> compressedImage =
          img.encodeJpg(image, quality: 85); // Comprime a JPG

      return base64Encode(compressedImage);
    } else {
      throw Exception('No se pudo decodificar la imagen');
    }
  } catch (e) {
    print('Error al comprimir y convertir la imagen a Base64: $e');
    return null;
  }
}

Future<String?> compressImage(File imageFile) async {
  try {
    final bytes = await imageFile.readAsBytes();

    final image = img.decodeImage(bytes);

    if (image == null) {
      throw Exception("No se pudo decodificar la imagen");
    }

    final resizedImage = img.copyResize(image,
        width: 600); // Opcional: Redimensiona la imagen si es demasiado grande

    final compressedBytes =
        img.encodeJpg(resizedImage, quality: 80); // Comprime la imagen
    return base64Encode(
        compressedBytes); // Convierte la imagen comprimida a base64
  } catch (e) {
    print("Error al comprimir la imagen: $e");
    return null;
  }
}

Future<void> pickImage() async {
  final picker = ImagePicker();
  final pickedFile = await picker.pickImage(source: ImageSource.gallery);

  if (pickedFile != null) {
    final imageFile = File(pickedFile.path);
    print('Ruta de la imagen seleccionada: ${imageFile.path}');
    String? compressedImageBase64 = await compressImage(imageFile);

    if (compressedImageBase64 != null) {
      print("Imagen comprimida: $compressedImageBase64");
    } else {
      print("Error al comprimir la imagen");
    }
  } else {
    print("No se seleccionó ninguna imagen");
  }
}

class ImagePickerExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Seleccionar Imagen")),
      body: Center(
        child: ElevatedButton(
          onPressed: pickImage,
          child: Text("Seleccionar imagen"),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ImagePickerExample(),
  ));
}
