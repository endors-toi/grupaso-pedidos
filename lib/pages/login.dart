import 'package:flutter/material.dart';
import 'package:grupaso_pedidos/pages/administrador/administrador_page.dart';
import 'package:grupaso_pedidos/pages/caja_page.dart';
import 'package:grupaso_pedidos/pages/cocina_page.dart';
import 'package:grupaso_pedidos/pages/verPedido.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController user = TextEditingController();
  TextEditingController pass = TextEditingController();
  String mensajeError = "";

  void iniciarSesion() {
    String mensajeError = '';

    if (user.text.isEmpty || pass.text.isEmpty) {
      mensajeError = 'Uno o más campos no pueden estar vacíos';
      mostrarDialogoError(mensajeError);
    } else if (!validarCredenciales(user.text, pass.text)) {
      mensajeError = 'Usuario o contraseña incorrectos';
      mostrarDialogoError(mensajeError);
    } else {
      redirigirPagina(user.text);
    }
  }

  bool validarCredenciales(String usuario, String contrasena) {
    Map<String, String> usuariosValidos = {
      "admin@grupaso.cl": "admin123",
      "cocina@grupaso.cl": "cocina123",
      "garzon@grupaso.cl": "garzon123",
      "caja@grupaso.cl": "caja123"
    };

    if (usuariosValidos.containsKey(usuario) && usuariosValidos[usuario] == contrasena) {
      return true;
    }
    return false;
  }

  void mostrarDialogoError(String mensajeError) {
    showDialog(
      context: context, 
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Error al iniciar sesión"),
          content: Text(mensajeError),
          actions: <Widget>[
            TextButton(
              child: Text('Aceptar'),
              onPressed: () {
                mensajeError = "";
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      }
    );
  }

  void redirigirPagina(String usuario) {
    Widget paginaDestino;

    switch (usuario) {
      case "admin@grupaso.cl":
        paginaDestino = AdministradorPage();
        break;
      case "cocina@grupaso.cl":
        paginaDestino = CocinaPage();
        break;
      case "garzon@grupaso.cl":
        paginaDestino = VerPedidoPage();
        break;
      case "caja@grupaso.cl":
        paginaDestino = CajaPage();
        break;
      default:
        mostrarDialogoError("No se encontró una página para el usuario.");
        return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => paginaDestino),
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 10.0),
                Image(image: AssetImage("assets/images/grupaso.png"), height: 150),
                SizedBox(height: 50.0),
                TextField(
                  controller: user,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.person),
                    hintText: 'Username',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                SizedBox(height: 20.0),
                TextField(
                  controller: pass,
                  obscureText: true,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock),
                    hintText: 'Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                SizedBox(height: 10.0),
                SizedBox(height: 20.0),
                ElevatedButton( 
                  onPressed: (){
                    iniciarSesion();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF7C03FF),
                    padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 15.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: Text(
                    'Login',
                    style: TextStyle(fontSize: 18.0, color: Colors.white),
                  ),
                ),
                SizedBox(height: 10.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
