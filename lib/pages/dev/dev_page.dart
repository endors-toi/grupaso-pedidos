import 'package:flutter/material.dart';
import 'package:grupaso_pedidos/pages/crearPedido_page.dart';
import 'package:grupaso_pedidos/pages/dev/example_page.dart';

// recuerda recargar ----->
var pages = [
  ExamplePage(),
  CrearPedidoPage(),
];

class DevPage extends StatelessWidget {
  const DevPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 100,
            ),
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  Text(
                    "Dev Page",
                    style: TextStyle(
                      fontSize: 30,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 6,
              child: Column(
                children: _generateButtons(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _generateButtons(BuildContext context) {
    List<Widget> buttons = [];

    for (var page in pages) {
      buttons.add(
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              elevation: 8,
              fixedSize: Size(250, 50),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => page),
              );
            },
            child: Text(page.toString().split('Page')[0],
                style: TextStyle(
                  fontSize: 20,
                )),
          ),
        ),
      );
    }

    return buttons;
  }
}
