import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:grupaso_pedidos/firebase_options.dart';
import 'package:grupaso_pedidos/pages/dev/dev_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Grupaso Pedidos',
      home: DevPage(),
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 200, 0, 255)),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      builder: EasyLoading.init(),
    );
  }
}
