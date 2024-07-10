import 'package:flutter/material.dart';
import 'package:grupaso_pedidos/utils.dart';

class RegistrarUsuarioPage extends StatefulWidget {
  const RegistrarUsuarioPage({super.key});

  @override
  State<RegistrarUsuarioPage> createState() => _RegistrarUsuarioPageState();
}

class _RegistrarUsuarioPageState extends State<RegistrarUsuarioPage> {
  TextEditingController nombre = TextEditingController();
  TextEditingController correo = TextEditingController();
  TextEditingController contrasena = TextEditingController();
  String? rol = 'GARZON';
  String msgError = '';
  bool error = false;
  List<Usuario> Usuarios = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Container(
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
                            value: 'GARZON',
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
                          if (contrasena.text.length == 0 ||
                              correo.text.length == 0 ||
                              nombre.text.length == 0) {
                            msgError = msgError + " Llene todos los campos ";
                            error = true;
                          }

                          if (contrasena.text.length < 9) {
                            msgError =
                                msgError + " Longitud de contraseña invalido ";
                            error = true;
                          }

                          for (Usuario userantiwo in Usuarios) {
                            if (userantiwo._correo == correo.text) {
                              msgError = msgError + " Cuenta ya creada ";
                              error = true;
                            }
                          }

                          if (error == false) {
                            Usuario user = new Usuario();
                            user._correo = correo.text;
                            user._nombre = nombre.text;
                            user._contrasena = contrasena.text;
                            user._rol = rol!;

                            Usuarios.add(user);

                            easySuccess('Cuenta creada correctamente');
                            Navigator.pop(context);
                          } else {
                            easyError(msgError);
                          }
                          msgError = '';
                          error = false;
                          print(Usuarios);
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
      ),
    );
  }
}

class Usuario {
  String _nombre;
  String _correo;
  String _contrasena;
  String _rol;

  Usuario({nombre = '', correo = '', contrasena = '', rol = ''})
      : _nombre = nombre,
        _correo = correo,
        _contrasena = contrasena,
        _rol = rol;

  String get nombre => this._nombre;
  String get correo => this._correo;
  String get contrasena => this._contrasena;
  String get rol => this._rol;
}
