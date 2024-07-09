import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grupaso_pedidos/utils.dart';

class CocinaPage extends StatefulWidget {
  @override
  CocinaPageState createState() => CocinaPageState();
}

class CocinaPageState extends State<CocinaPage> {
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
              // .where('estado', isEqualTo: 'PENDIENTE')
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
                          Text('Productos: \n${parse(doc['productos'])}'),
                          Text('Estado ${doc['estado']}')
                        ],
                      ),
                      trailing: ElevatedButton(
                        child: Text('Preparado'),
                        onPressed: () {
                          int id = doc['id'];
                          String docId = id.toString();
                          documentUpdate(
                              collection: 'pedidos',
                              docId: docId,
                              document: {
                                'estado': 'PREPARADO',
                              });
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
