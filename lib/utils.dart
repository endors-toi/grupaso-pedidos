import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';

//MARK: Popups

/// ```
/// Muestra un popup de error.
///     [error] es el mensaje de error a mostrar.
///     [duration] es para cambiar la duración del popup.
///
/// Dura 3 segundos por defecto.
/// ```
void easyError(String error, [int? duration = null]) {
  EasyLoading.showError(
    error,
    duration: Duration(seconds: duration ?? 3),
    dismissOnTap: true,
  );
}

/// ```
/// Muestra un popup de éxito.
///     [message] es el mensaje de éxito a mostrar. Opcional.
///     [duration] es para cambiar la duración del popup.
///
/// Dura 3 segundos por defecto.
/// ```
void easySuccess([String? message, int? duration = null]) {
  EasyLoading.showSuccess(
    message ?? '',
    duration: Duration(seconds: duration ?? 3),
    dismissOnTap: true,
  );
}

/// ```
/// Muestra un popup de información.
///     [message] es el mensaje de información a mostrar.
///     [duration] es para cambiar la duración del popup.
///
/// Dura 3 segundos por defecto.
/// ```
void easyInfo(String message, {int? duration = null}) {
  EasyLoading.showInfo(
    message,
    duration: Duration(seconds: duration ?? 3),
    // dismissOnTap: true,
  );
}

/// ```
/// Muestra animación de carga.
///     [message] es el mensaje de carga a mostrar. Opcional.
///
/// Debe detenerse manualmente usando loadingStop().
/// ```
void loadingStart([String? message = null]) {
  EasyLoading.show(
    status: message,
  );
}

/// ```
/// Detiene animación de carga.
/// ```
void loadingStop() {
  EasyLoading.dismiss();
}

//MARK: JSON

/// ```
/// Convierte un objeto a formato JSON.
///     [data] es el objeto a convertir.
///
/// Retorna un String.
/// ```
String stringify(dynamic data) {
  return jsonEncode(data);
}

/// ```
/// Convierte un string formato JSON a un objeto Dart.
///     [data] es el string en formato JSON.
///       ej: '{"nombre": "John Doe", "edad": 30}'
///       ej: '[7, 30, 12]'
///
/// Para objetos con propiedades, retorna un Map<String, dynamic>.
///     Map<String, dynamic> ejemplo = {
///       "nombre": "John Doe",
///       "edad": 30
///     }
///
/// Para arrays/listas, retorna un List<dynamic>.
///     List<dynamic> ejemplo = [7, 30, 12]
/// ```
dynamic parse(String data) {
  try {
    return jsonDecode(data);
  } catch (e) {
    easyError('Formato JSON inválido.');
    return null;
  }
}

//MARK: Navigate

/// ```
/// Navega al widget (página) especificado.
///     [context] == 'context'.
///     [page] es el widget (página) al que se quiere navegar.
///
/// Soporta retorno de valores desde la pantalla a la que se navega.
///     final result = await navigate(context, Page());
///
/// Para retornar un valor desde [page], se debe cerrar con:
///     Navigator.pop(valor);
///
/// ```
Future<T?> navigate<T>(BuildContext context, Widget page) {
  Navigator.pop(context);
  return Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => page),
  );
}

//MARK: Firestore

/// ```
/// Convierte un objeto DateTime a Timestamp para usar en Firestore.
///     [date] es el objeto DateTime a convertir.
///
/// Retorna un Timestamp.
/// ```
Timestamp getTimestamp(DateTime date) {
  return Timestamp.fromDate(date);
}

/// ```
/// Retorna el Stream de una colección de Firestore.
///     [collection] es el nombre de la colección.
///
///   ordenar (opcional):
///     [orderBy] es el campo por el que se quiere ordenar la colección.
///     [descending] es para ordenar de forma descendente.
///
///   filtrar (opcional):
///     [where] es el campo por el que se quiere filtrar la colección.
///     [condition] es el tipo de operación a aplicar.
///     [value] es el valor a comparar.
///
///     Condiciones:
///         'isEqualTo', 'arrayContains',
///         'isGreaterThan', 'isLessThan',
///         'isGreaterThanOrEqualTo', 'isLessThanOrEqualTo'.
///
/// Ejemplo:
///     collectionStream(
///        collection: 'usuarios',
///        orderBy: 'nombre',
///        descending: false,
///        where: 'edad',
///        condition: 'isGreaterThan',
///        value: 18,
///     );
/// ```
///
collectionStream({
  required String collection,

  // ordenar
  String? orderBy,
  bool descending = false,

  // filtrar
  String? where,
  String condition = 'isEqualTo',
  dynamic value,
}) {
  if (orderBy != null) {
    if (where != null) {
      return FirebaseFirestore.instance
          .collection(collection)
          .where(where)
          .orderBy(orderBy, descending: descending)
          .snapshots();
    } else {
      return FirebaseFirestore.instance
          .collection(collection)
          .orderBy(orderBy, descending: descending)
          .snapshots();
    }
  } else {
    if (where != null) {
      return FirebaseFirestore.instance
          .collection(collection)
          .where(where)
          .snapshots();
    } else {
      return FirebaseFirestore.instance.collection(collection).snapshots();
    }
  }
}

/// ```
/// Añade un documento a una colección de Firestore.
///    [collection] es el nombre de la colección.
///    [document] es el documento a añadir.
///       ejemplo = {
///          "nombre": "John Doe",
///          "edad": 30
///       }
///
/// Retorna la referencia al documento añadido, obteniendo así su docID.
/// ```
Future<DocumentReference> documentAdd(
    {required Map<String, dynamic> document,
    required String collection}) async {
  return FirebaseFirestore.instance.collection(collection).add(document);
}

/// ```
/// Edita un documento de una colección de Firestore.
///   [collection] es el nombre de la colección.
///   [document] es el objeto con los campos a cambiar.
///   [docId] es el ID del documento a actualizar.
///
/// No retorna nada. En cambio, se comprueba en el Stream.
/// ```
Future<void> documentUpdate(
    {required Map<String, dynamic> document,
    required String collection,
    required String docId}) async {
  return FirebaseFirestore.instance
      .collection(collection)
      .doc(docId)
      .update(document);
}

/// ```
/// Elimina un documento de una colección de Firestore.
///   [collection] es el nombre de la colección.
///   [id] es el ID del documento a eliminar.
///
/// No retorna nada. En cambio, se comprueba en el Stream.
Future<void> documentDelete(
    {required String collection, required String id}) async {
  return FirebaseFirestore.instance.collection(collection).doc(id).delete();
}
