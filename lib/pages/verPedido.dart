import 'package:flutter/material.dart';

import 'crearPedido_page.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class VerPedidoPage extends StatefulWidget {
  const VerPedidoPage({super.key});

  @override
  State<VerPedidoPage> createState() => _VerPedidoPageState();
}

class _VerPedidoPageState extends State<VerPedidoPage> {
  // Lista de ejemplo de pedidos
  final List<Pedido> pedidos = [
    Pedido(
      id: 1,
      productos: [
        Producto(
            id: 1,
            nombre: 'Producto 1',
            descripcion: 'Descripción 1',
            precio: 1000),
        Producto(
            id: 2,
            nombre: 'Producto 2',
            descripcion: 'Descripción 2',
            precio: 1500),
      ],
      mesa: 'Mesa 1',
      fecha: DateTime.parse('2024-07-09 17:09'),
      estado: 'PENDIENTE',
      valor: 2500,
    ),
    Pedido(
      id: 2,
      productos: [
        Producto(
            id: 3,
            nombre: 'Producto 3',
            descripcion: 'Descripción 3',
            precio: 2000),
      ],
      mesa: 'Mesa 2',
      fecha: DateTime.parse('2024-07-09 17:35'),
      estado: 'PENDIENTE',
      valor: 2000,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pedidos en curso.'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(8),
              child: ListView.builder(
                itemCount: pedidos.length,
                itemBuilder: (context, index) {
                  final pedido = pedidos[index];
                  return Column(
                    children: [
                      ListTile(
                        title: Text('Pedido ${pedido.id} - ${pedido.mesa}'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Fecha: ${pedido.fecha}'),
                            Text('Estado: ${pedido.estado}'),
                            Text('Valor: ${pedido.valor} \$'),
                            SizedBox(height: 8),
                            Text('Productos:'),
                            ...pedido.productos
                                .map((producto) => Text(
                                    '${producto.nombre} - ${producto.precio} \$'))
                                .toList(),
                          ],
                        ),
                        leading: Icon(
                          MdiIcons.food,
                          size: 35,
                          color: Color.fromARGB(255, 243, 174, 24),
                        ),
                      ),
                      Divider(),
                    ],
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 30, bottom: 60),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF7C03FF),
                padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 15.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CrearPedidoPage()),
                );
              },
              child: Text("Crear pedido",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
