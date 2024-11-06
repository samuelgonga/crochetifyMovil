import 'package:flutter/material.dart';

class RegisterView extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
      ),
      body: SingleChildScrollView(
        // Envuelve el contenido en SingleChildScrollView
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Align(
                alignment: Alignment.center,
                child: Text(
                  'Registrate! ',
                  style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ),
              const Align(
                alignment: Alignment.center,
                child: Text(
                  'Crea una cuenta para continuar',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w300,
                      color: Colors.black45),
                ),
              ),
              const SizedBox(height: 32.0),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Nombre: ',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w100),
                ),
              ),
              const TextField(
                decoration: InputDecoration(
                  hintText: 'Juan',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16.0),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Apellido: ',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w100),
                ),
              ),
              const TextField(
                decoration: InputDecoration(
                  hintText: 'Perez',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16.0),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Correo Electronico: ',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w100),
                ),
              ),
              const TextField(
                decoration: InputDecoration(
                  hintText: 'micorreo@gmail.com',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16.0),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Ingresa tu contraseña: ',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w100),
                ),
              ),
              const TextField(
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Contraseña',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16.0),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Confirma tu contraseña: ',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w100),
                ),
              ),
              const TextField(
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Contraseña',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: () {
                  // Acción para "Registrarme"
                },
                child: Text(
                  'Registrarme',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                  backgroundColor: Colors.blue,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
