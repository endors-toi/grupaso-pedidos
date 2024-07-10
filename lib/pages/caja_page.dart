import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  final String id;
  final int id2;
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
      id: doc.id,
      id2: data['id'],
      productos: productos,
      mesa: data['mesa'],
      fecha: (data['timestamp'] as Timestamp).toDate(),
      estado: data['estado'],
      valor: data['total'],
    );
  }
}

class CajaPage extends StatefulWidget {
  const CajaPage({super.key});

  @override
  State<CajaPage> createState() => _CajaPageState();
}

class _CajaPageState extends State<CajaPage> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<Pedido>> getPedidosServidos() {
    return _db
        .collection('pedidos')
        .where('estado', isEqualTo: 'SERVIDO')
        .snapshots()
        .asyncMap((snapshot) async {
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
          QuerySnapshot productoSnapshot = await _db
              .collection('productos')
              .where('id', isEqualTo: productoId)
              .get();
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
    await _db.collection('pedidos').doc(pedidoId).update({'estado': 'PAGADO'});
  }

  void easySuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
        backgroundColor: const Color.fromARGB(255, 136, 247, 140),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pedidos Servidos'),
      ),
      body: StreamBuilder<List<Pedido>>(
        stream: getPedidosServidos(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No hay pedidos servidos.'));
          }

          final pedidos = snapshot.data!;
          return SingleChildScrollView(
            child: Container(
              child: Center(
                child: Container(
                  margin: EdgeInsets.all(16.0),
                  padding: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 3,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Table(
                    border: TableBorder.all(),
                    columnWidths: {
                      0: FlexColumnWidth(1.2),
                      1: FlexColumnWidth(0.8),
                      2: FlexColumnWidth(1.5),
                      3: FlexColumnWidth(1),
                      4: FlexColumnWidth(1),
                    },
                    children: [
                      TableRow(
                        decoration: BoxDecoration(color: Colors.grey[300]),
                        children: [
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('Estado',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('ID',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('Productos',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('Total',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('Pagar',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ],
                      ),
                      ...pedidos.map((pedido) {
                        return TableRow(
                          children: [
                            TableCell(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(pedido.estado),
                              ),
                            ),
                            TableCell(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(pedido.id2.toString()),
                              ),
                            ),
                            TableCell(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: pedido.productos
                                      .map((producto) => Text(
                                          '${producto.nombre} - ${producto.precio} \$'))
                                      .toList(),
                                ),
                              ),
                            ),
                            TableCell(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('\$${pedido.valor}'),
                              ),
                            ),
                            TableCell(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Color.fromARGB(255, 111, 120, 253),
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    child: IconButton(
                                      icon: Icon(Icons.monetization_on_rounded,
                                          color: Colors.white),
                                      onPressed: () async {
                                        bool? confirm = await showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text('Confirmar'),
                                              content: Text(
                                                  '¿Desea marcar este pedido como pagado?'),
                                              actions: <Widget>[
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context)
                                                        .pop(false);
                                                  },
                                                  child: Text('Cancelar'),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context)
                                                        .pop(true);
                                                  },
                                                  child: Text('Aceptar'),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                        if (confirm == true) {
                                          await actualizarEstadoPedido(
                                              pedido.id);
                                          easySuccess(
                                              'Pedido ${pedido.id2} actualizado a PAGADO.');
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
