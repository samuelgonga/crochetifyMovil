import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:crochetify_movil/viewmodels/user_viewmodel.dart';
import 'package:crochetify_movil/models/user.dart';

class AddressesScreen extends StatefulWidget {
  @override
  _AddressesScreenState createState() => _AddressesScreenState();
}

class _AddressesScreenState extends State<AddressesScreen> {
  @override
  void initState() {
    super.initState();
    // Carga el usuario solo una vez
    Provider.of<UserViewModel>(context, listen: false).fetchUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mis Direcciones'),
      ),
      body: Consumer<UserViewModel>(
        builder: (context, userViewModel, child) {
          // Verifica si los datos del usuario han sido cargados
          if (userViewModel.user == null) {
            return Column(
              children: [CircularProgressIndicator()],
            );
          }
          // Obtiene las direcciones del usuario
          User user = userViewModel.user!;
          List<Address> addresses = user.address;

          return SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Botón para agregar nueva dirección
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    icon: Icon(Icons.add),
                    label: Text('Agregar nueva dirección'),
                    onPressed: () {
                      // Lógica para agregar nueva dirección
                    },
                    style: TextButton.styleFrom(
                      iconColor: Colors.blue, // Color del texto e ícono
                    ),
                  ),
                ),

                // Mostrar direcciones en tarjetas con sombra
                for (var address in addresses) _AddressCard(address: address),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _AddressCard extends StatelessWidget {
  final Address address;

  _AddressCard({required this.address});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
        title: Row(
          children: [
            Text(
              address.name,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            if (address
                .main) // Si la dirección es principal, mostrar el texto "Principal"
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  'Predeterminada',
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
        subtitle:
            Text('${address.address}, ${address.colonia}, ${address.country}'),
        trailing: Icon(Icons.arrow_forward_ios),
        onTap: () {
          if (address.main) {
            // Si es la dirección principal, mostrar opciones de editar y descartar
            _showEditDialog(context);
          } else {
            // Si no es la dirección principal, permitir establecerla como principal
            _showSetMainDialog(context);
          }
        },
      ),
    );
  }

  void _showEditDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Editar Dirección'),
          content: Text('¿Deseas editar esta dirección?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Cierra el diálogo sin hacer nada
              },
              child: Text('Descartar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Lógica para editar la dirección
              },
              child: Text('Editar'),
            ),
          ],
        );
      },
    );
  }

  void _showSetMainDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Establecer como Principal'),
          content: Text(
              '¿Estás seguro de que deseas establecer esta dirección como principal?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                    context); // Lógica para cambiar la dirección principal
              },
              child: Text('Aceptar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Cierra el diálogo sin hacer nada
              },
              child: Text('Cancelar'),
            ),
          ],
        );
      },
    );
  }
}
