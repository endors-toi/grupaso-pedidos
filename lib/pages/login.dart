import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController user = TextEditingController();
  TextEditingController pass = TextEditingController();
  String mensajeError = "";
  String usuarioValido = "admin@grupasocorp.cl";
  String contrasenaValida = "admin123";

  void validarDatos() {
    setState(() {
      if (user.text.isEmpty || pass.text.isEmpty) {
        mensajeError = 'Uno o mas campos no pueden estar vacios';
        showDialog(
          context: context, 
          builder: (BuildContext context){
            return AlertDialog(
              title: Text("Error al iniciar sesion"),
              content: Text("$mensajeError"),
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
      } else if (user.text != "admin@grupasocorp.cl" || pass.text != "admin123"){
        mensajeError = 'Datos invalidos';
        showDialog(
          context: context, 
          builder: (BuildContext context){
            return AlertDialog(
              title: Text("Error al iniciar sesion"),
              content: Text("$mensajeError"),
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

      if (mensajeError == ""){
        showDialog(
          context: context, 
          builder: (BuildContext context){
            return AlertDialog(
              title: Text("Sesion Iniciada"),
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
    });
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
                    validarDatos();
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
