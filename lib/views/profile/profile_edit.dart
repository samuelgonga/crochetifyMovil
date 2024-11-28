import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:crochetify_movil/services/user_service.dart';
import 'package:provider/provider.dart';
import 'package:crochetify_movil/viewmodels/session_viewmodel.dart';
import 'package:crochetify_movil/utils/image_utils.dart';

class ProfileEdit extends StatefulWidget {
  @override
  _ProfileEditScreenState createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEdit> {
  PickedFile? _image;
  final ImagePicker _picker = ImagePicker();
  final UserService _userService = UserService();

  bool _isLoading = true;

  // Método para cargar datos del usuario
  Future<void> _loadUserData() async {
    try {
      final userData = await _userService.fetchUser();
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print("Error al cargar datos del usuario: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadUserData(); // Cargar datos al iniciar la vista
  }

  Future<void> _pickImage() async {
  try {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      // Verifica si el archivo seleccionado tiene un formato válido
      final String filePath = pickedFile.path;
      final file = File(filePath);

      if (file.existsSync()) {
        final String fileExtension = filePath.split('.').last.toLowerCase();
        if (['jpg', 'jpeg', 'png', 'gif'].contains(fileExtension)) {
          setState(() {
            _image = PickedFile(filePath);
          });
        } else {
          _showErrorDialog('Formato de imagen no válido. Por favor, selecciona una imagen en formato JPG, PNG o GIF.');
        }
      } else {
        _showErrorDialog('La imagen seleccionada no existe o está corrupta.');
      }
    }
  } catch (e) {
    _showErrorDialog('Error al seleccionar la imagen: $e');
  }
}

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthViewModel>(context).user;
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
                              : (user?.image != null
                                      ? NetworkImage(user!.image)
                                      : AssetImage('assets/images/default_avatar.png'))
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
                    initialValue: user?.name ?? '',
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
                    onChanged: (value) {
                      final user =
                          Provider.of<AuthViewModel>(context, listen: false)
                              .user;
                      if (user != null) {
                        final updatedUser = user.copyWith(name: value);
                        Provider.of<UserService>(context, listen: false)
                            .updateUser(
                          userId: updatedUser.id,
                          name: updatedUser.name,
                          imageBase64:
                              null, // Si no hay imagen nueva, pasa null
                        );
                      }
                    },
                  ),
                  SizedBox(height: 20),
                  ElevatedButton( 
                    style: ButtonStyle(
                      backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.blueGrey),
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
                                child: Text('Cancelar',
                                    style: TextStyle(color: Colors.white)),
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
                                child: Text('Guardar',
                                    style: TextStyle(color: Colors.white)),
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

                        // try {
                        //   String? imageBase64;
                        //   if (_image != null) {
                        //     File imageFile = File(_image!.path);
                        //     imageBase64 = await compressAndConvertImageToBase64(
                        //         imageFile);
                        //   }

                        //   final success = await _userService.updateUser(
                        //     userId: user!.id,
                        //     name: user.name,
                        //     imageBase64:
                        //         imageBase64, // Pasar la imagen como base64
                        //   );

                        //   Navigator.pop(
                        //       context); // Cierra el indicador de carga

                        //   if (success) {
                        //     ScaffoldMessenger.of(context).showSnackBar(
                        //       SnackBar(
                        //           content:
                        //               Text('Perfil actualizado con éxito')),
                        //     );
                        //     Navigator.pop(context, true);
                        //   } else {
                        //     ScaffoldMessenger.of(context).showSnackBar(
                        //       SnackBar(
                        //           content:
                        //               Text('Error al actualizar el perfil')),

                        //     );
                        //   }
                        // } catch (e) {
                        //   Navigator.pop(
                        //       context); // Cierra el indicador de carga
                        //   _showErrorDialog('Error al guardar los cambios: $e');
                        // }
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
