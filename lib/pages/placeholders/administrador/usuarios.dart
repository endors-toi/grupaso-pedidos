import 'package:flutter/material.dart';
import 'package:grupaso_pedidos/pages/administrador/registrar_usuario_page.dart';

class PlaceHolderUsuario extends StatelessWidget {
  const PlaceHolderUsuario({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Container(
          child: Center(
            child: Column(
              children: [
                Text("GESTION DE USUARIOS!!!!!!!"),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 8,
                    fixedSize: Size(250, 50),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RegistrarUsuarioPage()),
                    );
                  },
                  child: Text("Registrar Usuario",
                      style: TextStyle(
                        fontSize: 20,
                      )),
                ),
              ],
            ),
          ),
        ));
  }
}
