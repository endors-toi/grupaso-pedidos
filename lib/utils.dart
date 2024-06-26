import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';

/// Muestra un popup de error.
///
/// [error] es el mensaje de error a mostrar.
///
/// [duration] es para cambiar la duración del popup.
///
/// Dura 3 segundos por defecto.
void easyError(String error, [int? duration = null]) {
  EasyLoading.showError(
    error,
    duration: Duration(seconds: duration ?? 3),
    dismissOnTap: true,
  );
}

/// Muestra un popup de éxito.
///
/// [message] es el mensaje de éxito a mostrar.
/// Opcional.
///
/// [duration] es para cambiar la duración del popup.
///
/// Dura 3 segundos por defecto.
void easySuccess([String? message, int? duration = null]) {
  EasyLoading.showSuccess(
    message ?? '',
    duration: Duration(seconds: duration ?? 3),
    dismissOnTap: true,
  );
}

/// Muestra un popup de información.
///
/// [message] es el mensaje de información a mostrar.
///
/// [duration] es para cambiar la duración del popup.
///
/// Dura 3 segundos por defecto.
void easyInfo(String message, [int? duration = null]) {
  EasyLoading.showInfo(
    message,
    duration: Duration(seconds: duration ?? 3),
    dismissOnTap: true,
  );
}

/// Muestra animación de carga.
///
/// [message] es el mensaje de carga a mostrar.
/// Opcional.
///
/// Debe cerrarse manualmente usando dismissLoading().
void loadingStart([String? message = null]) {
  EasyLoading.show(
    status: message,
  );
}

/// Cierra animación de carga.
void loadingStop() {
  EasyLoading.dismiss();
}

/// Convierte un objeto a formato JSON.
///
/// [data] es el objeto a convertir.
///
/// Retorna un string en formato JSON.
String stringify(dynamic data) {
  return jsonEncode(data);
}

/// ```
/// String data: "{\"name\": \"John Doe\", \"age\": 30}"
/// String data: "[15, 30, 42]"
/// ```
///
/// Convierte un string formato JSON a un objeto Dart.
///
/// Para objetos con propiedades, Dart retorna un Map<String, dynamic>.
///
///       Map<String, dynamic> ejemplo = {
///         "name": "John Doe",
///         "age": 30
///       }
///
/// Para arrays/listas, Dart retorna una List\<dynamic>.
///
///       List<dynamic> ejemplo = [
///         "John Doe",
///         30
///       ]
dynamic parse(String data) {
  return jsonDecode(data);
}

/// Convierte un objeto DateTime a Timestamp para usar en Firestore.
///
/// [date] es el objeto DateTime a convertir.
///
/// Retorna un Timestamp.
Timestamp getTimestamp(DateTime date) {
  return Timestamp.fromDate(date);
}

/// Navega al widget (página) especificado.
///
/// [context] es el contexto actual. Siempre se escribe `context`.
///
/// [page] es el widget (página) al que se quiere navegar.
///
/// Soporta retorno de valores desde la pantalla a la que se navega.
///
/// ```
/// final result = await navigate(context, Page());
/// ```
///
/// Para retornar un valor desde la pantalla destino, se especifica dentro del Navigator.pop():
///
/// ```
/// Navigator.pop(context, "Hello, father.");
/// ```
Future<T?> navigate<T>(BuildContext context, Widget page) {
  Navigator.pop(context);
  return Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => page),
  );
}
