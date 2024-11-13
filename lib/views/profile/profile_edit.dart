import 'dart:convert';
import 'dart:io';
import 'package:crochetify_movil/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class ProfileEdit extends StatefulWidget {
  @override
  _ProfileEditScreenState createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEdit> {
  PickedFile? _image;
  final ImagePicker _picker = ImagePicker();
  User? _user;

  // Método para cargar datos del usuario desde el archivo JSON
  Future<void> _loadUserData() async {
    final String response = await rootBundle.loadString('assets/user.json');
    final data = json.decode(response);
    setState(() {
      _user = User.fromJson(data);
    });
  }

  @override
  void initState() {
    super.initState();
    _loadUserData();
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
        title: Text('Mi Perfil'),
        centerTitle: true,
      ),
      body: _user == null
          ? Center(child: CircularProgressIndicator())
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
                              : NetworkImage(_user!.image) as ImageProvider,
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
                    initialValue: _user!.name,
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
                    initialValue: _user!.email,
                    decoration: InputDecoration(
                      labelText: 'Correo',
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
                  SizedBox(height: 10),
                  // Campo para la contraseña actual
                  TextFormField(
                    initialValue: _user!.password,
                    decoration: InputDecoration(
                      labelText: 'Contraseña Actual',
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
                    obscureText: true,
                  ),
                  SizedBox(height: 10),
                  // Campo para la nueva contraseña
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Nueva Contraseña',
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
                    obscureText: true,
                  ),
                  SizedBox(height: 10),
                  // Campo para repetir la nueva contraseña
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Repetir Contraseña',
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
                    obscureText: true,
                  ),
                  SizedBox(height: 10),
                  // Campo para mostrar la dirección principal en un solo campo
                  if (_user!.address.isNotEmpty) ...[
                    TextFormField(
                      initialValue: '${_user!.address[0].name}, '
                          '${_user!.address[0].address}, '
                          '${_user!.address[0].colonia}, '
                          '${_user!.address[0].country}, '
                          'Tel: ${_user!.address[0].phone}, '
                          '${_user!.address[0].main ? "Predeterminada" : "No predeterminada"}',
                      decoration: InputDecoration(
                        labelText: 'Dirección Principal',
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
                      maxLines: 3,
                    ),
                  ],
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
                            content: Text('¿Realmente desea guardar los cambios?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(false);
                                },
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(Colors.blueGrey),
                                  overlayColor:
                                      MaterialStateProperty.resolveWith<Color>(
                                    (Set<MaterialState> states) {
                                      if (states.contains(MaterialState.hovered)) {
                                        return Colors.grey.shade400;
                                      }
                                      return Colors.white;
                                    },
                                  ),
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
                                  backgroundColor: MaterialStateProperty.all<Color>(
                                      Color(0xFF768ABA)),
                                  overlayColor:
                                      MaterialStateProperty.resolveWith<Color>(
                                    (Set<MaterialState> states) {
                                      if (states.contains(MaterialState.hovered)) {
                                        return Color(0xFF768ABA).withOpacity(0.8);
                                      }
                                      return Color(0xFF768ABA);
                                    },
                                  ),
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