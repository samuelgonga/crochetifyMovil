import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileEdit extends StatefulWidget {
  @override
  _ProfileEditScreenState createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEdit> {
  PickedFile? _image;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.getImage(source: ImageSource.gallery);
    setState(() {
      _image = pickedFile;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            // Acción al presionar el ícono de cerrar
            Navigator.pop(context);
          },
        ),
        title: Text('Mi Perfil'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: _image != null
                        ? FileImage(File(_image!.path))
                        : AssetImage('assets/images/ness.jpeg')
                            as ImageProvider,
                    backgroundColor: Colors.grey[200],
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: _pickImage,
                      child: CircleAvatar(
                        backgroundColor: Colors.blue,
                        radius: 20,
                        child: Icon(
                          Icons.edit,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              initialValue: 'Chris',
              decoration: InputDecoration(
                labelText: 'Nombre',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              initialValue: 'Vergara',
              decoration: InputDecoration(
                labelText: 'Apellidos',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              initialValue: 'correo@gmail.com',
              decoration: InputDecoration(
                labelText: 'Correo',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 10),
            TextFormField(
              initialValue: 'contraseña',
              decoration: InputDecoration(
                labelText: 'Contraseña Actual',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            SizedBox(height: 10),
            TextFormField(
              initialValue: 'contraseña',
              decoration: InputDecoration(
                labelText: 'Nueva Contraseña',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            SizedBox(height: 10),
                TextFormField(
              initialValue: 'contraseña',
              decoration: InputDecoration(
                labelText: 'Repetir Contraseña',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            SizedBox(height: 10),
            TextFormField(
              initialValue:
                  'Diego Sanchez Limoneros, Manzana 31 Lote 9 Lagunilla del salto México, 7777936572',
              maxLines: 2,
              decoration: InputDecoration(
                labelText: 'Dirección de envío',
              border: OutlineInputBorder(),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                ),
                onPressed: () async {
                  bool? shouldSave = await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Confirmación'),
                        content: Text('¿Realmente desea guardar los cambios?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(false);
                            },
                            child: Text('Cancelar'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop(true);
                            },
                            child: Text('Guardar'),
                          ),
                        ],
                      );
                    },
                  );

                  if (shouldSave == true) {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                    );
                    await Future.delayed(Duration(seconds: 2));
                    Navigator.pop(context);
                    Navigator.pop(context);
                  }
                },
                child: Text(
                  "Guardar Cambios",
                  style: TextStyle(color: Colors.white),
                )),
          ],
        ),
      ),
    );
  }
}
