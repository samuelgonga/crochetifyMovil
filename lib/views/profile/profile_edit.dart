import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:crochetify_movil/models/user.dart';
import 'package:crochetify_movil/services/user_service.dart';

class ProfileEdit extends StatefulWidget {
  @override
  _ProfileEditScreenState createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEdit> {
  PickedFile? _image;
  final ImagePicker _picker = ImagePicker();
  final UserService _userService =
      UserService(); // Servicio para obtener datos del usuario
  User? _user;

  bool _isLoading = true; // Indicador de carga

  // Método para cargar datos del usuario desde el servicio
  Future<void> _loadUserData() async {
    try {
      final userData = await _userService.fetchUser();
      setState(() {
        _user = userData;
        _isLoading = false;
      });
    } catch (e) {
      print("Error al cargar datos del usuario: $e");
      setState(() {
        _isLoading =
            false; // Detenemos el indicador de carga incluso si hay error
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadUserData(); // Cargar datos al iniciar la vista
  }

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
            Navigator.pop(context);
          },
        ),
        title: Text('Editar Perfil'),
        centerTitle: true,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator()) // Indicador de carga
          : Padding(
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
                              : (_user?.image != null
                                      ? NetworkImage(_user!.image!)
                                      : AssetImage('assets/default_avatar.png'))
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
                  // Campo para el nombre
                  TextFormField(
                    initialValue: _user?.name ?? '',
                    decoration: InputDecoration(
                      labelText: 'Nombre',
                      labelStyle: TextStyle(color: Color(0xFF3A86FF)),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF3A86FF)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF3A86FF)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF44B7AC)),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  // Campo para el correo electrónico
                  TextFormField(
                    initialValue: _user?.email ?? '',
                    decoration: InputDecoration(
                      labelText: 'Correo Electrónico',
                      labelStyle: TextStyle(color: Color(0xFF3A86FF)),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF3A86FF)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF3A86FF)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF44B7AC)),
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF768ABA),
                    ),
                    onPressed: () async {
                      bool? shouldSave = await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Confirmación'),
                            content:
                                Text('¿Realmente desea guardar los cambios?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(false);
                                },
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.blueGrey),
                                ),
                                child: Text(
                                  'Cancelar',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pop(true);
                                },
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Color(0xFF768ABA)),
                                ),
                                child: Text(
                                  'Guardar',
                                  style: TextStyle(color: Colors.white),
                                ),
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
                              child: CircularProgressIndicator(
                                color: Color(0xFF768ABA),
                              ),
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
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
