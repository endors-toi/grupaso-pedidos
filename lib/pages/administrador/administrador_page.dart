import 'package:flutter/material.dart';
import 'package:grupaso_pedidos/pages/placeholders/administrador/pedidos.dart';
import 'package:grupaso_pedidos/pages/placeholders/administrador/productos.dart';
import 'package:grupaso_pedidos/pages/placeholders/administrador/usuarios.dart';

class AdministradorPage extends StatefulWidget {
  const AdministradorPage({super.key});

  @override
  State<AdministradorPage> createState() => _AdministradorPageState();
}

class _AdministradorPageState extends State<AdministradorPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 50),
              child: Center(
                  child: Text(
                "Menu administrador",
                style: TextStyle(color: Colors.black, fontSize: 30),
              )),
            ),
            Padding(
              padding: EdgeInsets.only(top: 100),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 30),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 8,
                        fixedSize: Size(250, 50),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PlaceHolderPedidos()),
                        );
                      },
                      child: Text("Historial de Pedidos",
                          style: TextStyle(
                            fontSize: 20,
                          )),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 30),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 8,
                        fixedSize: Size(250, 50),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PlaceHolderUsuario()),
                        );
                      },
                      child: Text("Usuarios",
                          style: TextStyle(
                            fontSize: 20,
                          )),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 30),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 8,
                        fixedSize: Size(250, 50),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PlaceHolderProductos()),
                        );
                      },
                      child: Text("Productos",
                          style: TextStyle(
                            fontSize: 20,
                          )),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
