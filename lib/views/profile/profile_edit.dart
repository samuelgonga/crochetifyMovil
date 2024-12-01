import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:crochetify_movil/services/user_service.dart';
import 'package:crochetify_movil/models/user.dart';

class ProfileEdit extends StatefulWidget {
  @override
  _ProfileEditScreenState createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEdit> {
  final UserService _userService = UserService();
  final ImagePicker _imagePicker = ImagePicker();
  final TextEditingController _nameController = TextEditingController();

  bool _isLoading = true;
  User? _user;
  File? _selectedImage;
  ImageProvider? _decodedImage;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final userData = await _userService.getLoggedUser();
      setState(() {
        _user = userData;
        _nameController.text = _user?.name ?? ''; // Inicializa el nombre
        _isLoading = false;

        // Decodifica la imagen de base64 si existe
        if (_user?.image != null && _user!.image!.isNotEmpty) {
          _decodedImage = MemoryImage(base64Decode(_user!.image!));
        }
      });
    } catch (e) {
      print('Error al cargar datos del usuario: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _pickImage() async {
    try {
      final pickedFile =
          await _imagePicker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
          _decodedImage =
              FileImage(_selectedImage!); // Actualiza la imagen seleccionada
        });
      }
    } catch (e) {
      print('Error al seleccionar la imagen: $e');
    }
  }

  Future<void> _saveChanges() async {
    try {
      final success = await _userService.updateUserProfile(
        name: _nameController.text,
        imageFile: _selectedImage,
      );

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Perfil actualizado con éxito')),
        );

        // Regresa a la vista anterior con un indicador de éxito
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al actualizar el perfil')),
        );
      }
    } catch (e) {
      print('Error al guardar los cambios: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al guardar los cambios')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Perfil'),
        centerTitle: true,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _user == null
              ? Center(
                  child: Text(
                    'No se pudo cargar la información del usuario.',
                    style: TextStyle(fontSize: 18, color: Colors.red),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Imagen del Usuario
                      Stack(
                        children: [
                          CircleAvatar(
                            radius: 60,
                            backgroundImage: _decodedImage ??
                                AssetImage('assets/images/default_avatar.png')
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
                      SizedBox(height: 20),

                      // Campo de texto para el nombre
                      TextField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: 'Nombre',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 20),

                      // Correo Electrónico (solo lectura)
                      Text(
                        'Correo Electronico: ${_user!.email}',
                        style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                      ),
                      SizedBox(height: 20),

                      SizedBox(height: 20),

                      // Botón para guardar cambios
                      ElevatedButton(
                        onPressed: _saveChanges,
                        child: Text('Guardar Cambios'),
                      ),
                    ],
                  ),
                ),
    );
  }
}
