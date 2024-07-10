import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'crearPedido_page.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class Producto {
  final int id;
  final String nombre;
  final String descripcion;
  final int precio;

  Producto({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.precio,
  });

  factory Producto.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Producto(
      id: data['id'],
      nombre: data['nombre'],
      descripcion: data['descripcion'],
      precio: data['precio'],
    );
  }
}

class Pedido {
  final String id; // Cambiado de int a String para coincidir con el ID del documento Firestore
  final int id2; //id interna
  final List<Producto> productos;
  final String mesa;
  final DateTime fecha;
  final String estado;
  final int valor;

  Pedido({
    required this.id,
    required this.id2,
    required this.productos,
    required this.mesa,
    required this.fecha,
    required this.estado,
    required this.valor,
  });

  factory Pedido.fromFirestore(DocumentSnapshot doc, List<Producto> productos) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Pedido(
      id: doc.id, // Usar el ID del documento Firestore
      id2: data['id'],
      productos: productos,
      mesa: data['mesa'],
      fecha: (data['timestamp'] as Timestamp).toDate(),
      estado: data['estado'],
      valor: data['total'],
    );
  }
}

class VerPedidoPage extends StatefulWidget {
  const VerPedidoPage({super.key});

  @override
  State<VerPedidoPage> createState() => _VerPedidoPageState();
}

class _VerPedidoPageState extends State<VerPedidoPage> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<Pedido>> getPedidosPreparados() {
    return _db.collection('pedidos').where('estado', isEqualTo: 'PREPARADO').snapshots().asyncMap((snapshot) async {
      List<Pedido> pedidos = [];
      for (var doc in snapshot.docs) {
        List<int> productoIds;
        try {
          productoIds = List<int>.from(doc['productos']);
        } catch (e) {
          print('Error converting productos field: $e');
          continue;
        }
        List<Producto> productos = [];
        for (int productoId in productoIds) {
          QuerySnapshot productoSnapshot = await _db.collection('productos').where('id', isEqualTo: productoId).get();
          if (productoSnapshot.docs.isNotEmpty) {
            productos.add(Producto.fromFirestore(productoSnapshot.docs.first));
          }
        }
        pedidos.add(Pedido.fromFirestore(doc, productos));
      }
      return pedidos;
    });
  }

  Future<void> actualizarEstadoPedido(String pedidoId) async {
    await _db.collection('pedidos').doc(pedidoId).update({'estado': 'SERVIDO'});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pedidos en curso.'),
      ),
      floatingActionButton: Padding(
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
      body: StreamBuilder<List<Pedido>>(
        stream: getPedidosPreparados(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No hay pedidos pendientes.'));
          }

          final pedidos = snapshot.data!;
          return Column(
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
                            title: Text('Pedido ${pedido.id2} - ${pedido.mesa}'),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Fecha: ${pedido.fecha}'),
                                Text('Estado: ${pedido.estado}'),
                                Text('Valor: ${pedido.valor} \$'),
                                SizedBox(height: 8),
                                Text('Productos:'),
                                ...pedido.productos.map((producto) => Text('${producto.nombre} - ${producto.precio} \$')).toList(),
                                SizedBox(height: 8),
                                ElevatedButton(
                                  onPressed: () async {
                                    bool? confirm = await showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text('Confirmar'),
                                          content: Text('¿Desea marcar este pedido como servido?'),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop(false);
                                              },
                                              child: Text('Cancelar'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop(true);
                                              },
                                              child: Text('Aceptar'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                    if (confirm == true) {
                                      await actualizarEstadoPedido(pedido.id);
                                    }
                                  },
                                  child: Text('Marcar como servido'),
                                ),
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
              
            ],
          );
        },
      ),
    );
  }
}
