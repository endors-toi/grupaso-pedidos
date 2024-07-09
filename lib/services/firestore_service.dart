import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grupaso_pedidos/pages/crearPedido_page.dart';
import 'package:grupaso_pedidos/utils.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // usuarios
  // productos

  // pedidos
  //*
  Stream<QuerySnapshot> Pedido() {
    return FirebaseFirestore.instance.collection('Pedido').snapshots();
  }

  // chat
  chatStream() {
    return _db
        .collection('chat')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  Future<dynamic> addMessage(String msg, String autor, String avatar) async {
    return _db.collection('chat').add({
      'msg': msg,
      'autor': autor,
      'avatar': avatar,
      'timestamp': getTimestamp(DateTime.now()),
    });
  }

  Future<dynamic> deleteMessage(String id) async {
    return _db.collection('chat').doc(id).delete();
  }
}
