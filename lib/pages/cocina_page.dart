import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grupaso_pedidos/utils.dart';

class CocinaPage extends StatefulWidget {
  @override
  CocinaPageState createState() => CocinaPageState();
}

class CocinaPageState extends State<CocinaPage> {
  Future<List<String>> getNombresProductos(List<dynamic> idsProductos) async {
    List<String> nombresProductos = [];
    for (var id in idsProductos) {
      var querySnapshot = await FirebaseFirestore.instance
          .collection('productos')
          .where('id', isEqualTo: id)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        nombresProductos.add(querySnapshot.docs.first['nombre']);
      }
    }
    return nombresProductos;
  }

  Future<void> updateEstadoPedido(String pedidoId) async {
    await FirebaseFirestore.instance
        .collection('pedidos')
        .doc(pedidoId)
        .update({'estado': 'PREPARADO'});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pedidos Pendientes'),
      ),
      body: Container(
        margin: EdgeInsets.all(10),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('pedidos')
              .where('estado', isEqualTo: 'PENDIENTE')
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  var doc = snapshot.data!.docs[index];
                  return Card(
                    child: ListTile(
                      title: Text('Pedido ${doc['id']}'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Productos: '),
                          FutureBuilder(
                            future:
                                getNombresProductos(parse(doc['productos'])),
                            builder: (context,
                                AsyncSnapshot<List<String>> snapshot) {
                              if (!snapshot.hasData) {
                                return Text('Cargando productos...');
                              } else {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: snapshot.data!
                                      .map((nombre) => Text('  $nombre'))
                                      .toList(),
                                );
                              }
                            },
                          ),
                          Text('Estado ${doc['estado']}')
                        ],
                      ),
                      trailing: ElevatedButton(
                        child: Text('Preparado'),
                        onPressed: () {
                          updateEstadoPedido(doc.id);
                        },
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
