import 'package:flutter/material.dart';

class RegistrarUsuarioPage extends StatefulWidget {
  const RegistrarUsuarioPage({super.key});

  @override
  State<RegistrarUsuarioPage> createState() => _RegistrarUsuarioPageState();
}

class _RegistrarUsuarioPageState extends State<RegistrarUsuarioPage> {
  TextEditingController nombre = TextEditingController();
  TextEditingController correo = TextEditingController();
  TextEditingController contrasena = TextEditingController();
  String? rol;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 100),
                child: Text(
                  "Registrar Usuario",
                  style: TextStyle(fontSize: 30),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 15),
                      child: TextField(
                        controller: nombre,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.person),
                          hintText: 'Nombre',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 15),
                      child: TextField(
                        controller: correo,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.mail),
                          hintText: 'Correo',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 15),
                      child: TextField(
                        controller: contrasena,
                        obscureText: true,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.key),
                          hintText: 'Contraseña',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.only(bottom: 15),
                        child: DropdownButtonFormField(
                          borderRadius: BorderRadius.circular(10.0),
                          dropdownColor: Colors.white,
                          hint: Text('Rol'),
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.key),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          items: [
                            DropdownMenuItem(
                              child: Text('Garzon'),
                              value: 'GARZON',
                            ),
                            DropdownMenuItem(
                              child: Text('Cocina'),
                              value: 'COCINA',
                            ),
                            DropdownMenuItem(
                              child: Text('Caja'),
                              value: 'CAJA',
                            ),
                          ],
                          onChanged: (value) => (rol = value),
                        )),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        elevation: 8,
                        fixedSize: Size(250, 50),
                      ),
                      onPressed: () {
                        print(nombre.text);
                        print(rol);
                      },
                      child: Text("Registrar",
                          style: TextStyle(
                            fontSize: 20,
                          )),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
