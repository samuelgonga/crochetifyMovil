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
      if (mounted) {
        // Verifica si el widget está montado
        setState(() {
          _user = userData;
          _nameController.text = _user?.name ?? ''; // Inicializa el nombre
          _isLoading = false;

          // Decodifica la imagen de base64 si existe
          if (_user?.image != null && _user!.image!.isNotEmpty) {
            _decodedImage = MemoryImage(base64Decode(_user!.image!));
          }
        });
      }
    } catch (e) {
      print('Error al cargar datos del usuario: $e');
      if (mounted) {
        // Verifica si el widget está montado
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _pickImage() async {
    try {
      final pickedFile =
          await _imagePicker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null && mounted) {
        // Verifica si el widget está montado
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

  void _showAlert({
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

  Future<void> _saveChanges() async {
    try {
      final success = await _userService.updateUserProfile(
        name: _nameController.text,
        imageFile: _selectedImage,
      );

      if (success) {
        await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0)),
              title: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.green, size: 30),
                  const SizedBox(width: 10),
                  const Text('¡Éxito!'),
                ],
              ),
              content: const Text(
                'Perfil actualizado con éxito.',
                style: TextStyle(fontSize: 16),
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

        // Regresa a la vista anterior con un indicador de éxito
        Navigator.pop(context, true);
      } else {
        _showAlert(
          title: 'Error',
          message: 'Error al actualizar el perfil.',
          icon: Icons.error,
          iconColor: Colors.red,
        );
      }
    } catch (e) {
      print('Error al guardar los cambios: $e');
      _showAlert(
        title: 'Error',
        message: 'Error al guardar los cambios.',
        icon: Icons.error,
        iconColor: Colors.red,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Perfil'),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _user == null
              ? const Center(
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
                                const AssetImage(
                                        'assets/images/default_avatar.png')
                                    as ImageProvider,
                            backgroundColor: Colors.grey[200],
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: _pickImage,
                              child: const CircleAvatar(
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
                      const SizedBox(height: 20),

                      // Campo de texto para el nombre
                      TextField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Nombre',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Correo Electrónico (solo lectura)
                      Text(
                        'Correo Electrónico: ${_user!.email}',
                        style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                      ),
                      const SizedBox(height: 20),

                      // Botón para guardar cambios
                      ElevatedButton(
                        onPressed: _saveChanges,
                           style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        child: const Text('Guardar Cambios',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white
                        ),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}
