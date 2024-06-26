import 'dart:math';
import 'package:flutter/services.dart' show rootBundle;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:grupaso_pedidos/services/firestore_service.dart';
import 'package:grupaso_pedidos/utils.dart';

class ExamplePage extends StatefulWidget {
  const ExamplePage({super.key});

  @override
  State<ExamplePage> createState() => _ExamplePageState();
}

class _ExamplePageState extends State<ExamplePage> {
  bool _conTexto = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('grupaso incorporated'),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => easyInfo(randomTip()),
                  child: Text('showInfo'),
                ),
                ElevatedButton(
                  onPressed: () => easyError("*extremely loud buzzer*"),
                  child: Text('showError'),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Checkbox(
                      value: _conTexto,
                      onChanged: (value) => setState(() {
                        _conTexto = value!;
                      }),
                    ),
                    Text('Con texto'),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_conTexto) {
                      easySuccess("WENA :3");
                    } else {
                      easySuccess();
                    }
                  },
                  child: Text('showSuccess'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_conTexto) {
                      loadingStart("Cargando...");
                    } else {
                      loadingStart();
                    }

                    Future.delayed(Duration(seconds: 3), () {
                      loadingStop();
                    });
                  },
                  child: Text('showLoading'),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Chat()),
            );
          },
          child: Icon(
            FeatherIcons.messageCircle,
            size: 30,
          ),
          elevation: 5,
          backgroundColor: Colors.amber,
        ));
  }
}

//MARK: Tips
String randomTip() {
  const List<String> x = [
    "Hot reload te permite experimentar rápidamente y con facilidad.",
    "Todo en Flutter es un widget.",
    "Los widgets son los bloques constructivos de una aplicación Flutter.",
    "Construye tu layout con Column y Row.",
    "Expanded le dice a un widget que use todo el espacio disponible.",
    "Expanded debe estar dentro de un Column o Row.",
    "StatefulWidget es mutable.",
    "StatelessWidget es inmutable.",
    "Flutter tiene su propio motor de renderizado.",
    "Puedes crear layouts responsivos con MediaQuery.",
    "Edita ThemeData para aplicar estilos a toda la app.",
    "Flutter Inspector ayuda a visualizar y explorar árboles de widgets.",
    "pubspec.yaml configura dependencias.",
    "Usa keys para gestionar widgets con estados dinámicos.",
    "Los botones más comunes son ElevatedButton FilledButton y TextButton.",
    "Navigator gestiona rutas en tu app.",
    "ListView.builder() para la creación de listas dinámicas.",
    "Haz cualquier cosa 'clickeable' con InkWell.",
    "Flutter ofrece librerías ricas en animaciones.",
    "Obtén todo lo que necesitas desde pub.dev",
    "Usa FutureBuilder para operaciones de datos asíncronos.",
    "Visualiza Streams de datos con StreamBuilder.",
    "Los Streams permiten la programación por eventos.",
    "CustomPaint puede dibujar diseños personalizados.",
    "Usa BoxDecoration para sombras, bordes y formas.",
    "Hero ofrece transiciones animadas entre widgets.",
  ];
  return x[Random().nextInt(x.length)];
}

//MARK: Chat Widget
var _user = "";
var _selectedAvatar = "airplane";

class Chat extends StatefulWidget {
  const Chat({super.key});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final TextEditingController _mensajeController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('xd'),
        actions: [
          IconButton(
            icon: Icon(FeatherIcons.image),
            onPressed: () async {
              var selectedImage = await _showAvatarDialog(context);
              if (selectedImage != null) {
                _selectedAvatar = selectedImage;
              }
            },
          ),
          _user != ""
              ? IconButton(
                  icon: Icon(FeatherIcons.user),
                  onPressed: () async {
                    var username = await _showUsernameDialog(context);
                    if (username != false) {
                      easySuccess("\"$_user\" ->\"$username\"");
                      setState(() {
                        _user = username;
                      });
                    } else {
                      easyError("NO USERNAME");
                    }
                  },
                )
              : SizedBox(),
          SizedBox(
            width: 10,
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(child: _chat()),
          _input(),
        ],
      ),
    );
  }

  Widget _chat() {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
      child: StreamBuilder(
        stream: FirestoreService().chatStream(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
            reverse: true,
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var doc = snapshot.data!.docs[index];
              return ListTile(
                leading: FramedAvatar(avatar: doc['avatar']),
                title: Text(
                  doc['autor'],
                  style: TextStyle(fontSize: 12, color: Colors.blueGrey[700]),
                ),
                subtitle: Text(
                  doc['msg'],
                  style: TextStyle(
                      fontSize: 16, color: Color.fromARGB(255, 102, 0, 149)),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _input() {
    return Container(
      margin: const EdgeInsets.all(10),
      child: Form(
        key: _formKey,
        child: Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _mensajeController,
                decoration: InputDecoration(
                  hintText: 'Escribe tu mensaje',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, escribe un mensaje';
                  }
                  return null;
                },
              ),
            ),
            IconButton(
              icon: Icon(FeatherIcons.send),
              onPressed: () async {
                if (!_user.isEmpty) {
                  if (_formKey.currentState!.validate()) {
                    FirestoreService().addMessage(
                        _mensajeController.text, _user, _selectedAvatar);
                    _mensajeController.clear();
                  }
                } else {
                  var username = await _showUsernameDialog(context);
                  if (username != false) {
                    easySuccess("\"$username\"");
                    setState(() {
                      _user = username;
                    });
                  } else {
                    easyError("NO USERNAME");
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class FramedAvatar extends StatelessWidget {
  final String avatar;

  FramedAvatar({required this.avatar, super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 40,
          height: 40,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Image.asset(
              'assets/images/avatars/$avatar.jpg',
              width: 40,
              height: 40,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Image.asset(
          'assets/images/av_frame.png',
          width: 53,
          height: 53,
        ),
      ],
    );
  }
}

// MARK: Dialog: Username
Future<dynamic> _showUsernameDialog(BuildContext context) async {
  TextEditingController _usernameController = TextEditingController();
  await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Ingresa username'),
        content: TextField(
          controller: _usernameController,
          decoration: InputDecoration(),
        ),
        actions: [
          TextButton(
            child: Text('Nah'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );

  var user = _usernameController.text.trim();
  return user != "" ? user : false;
}

// MARK: Dialog: Avatar
Future<dynamic> _showAvatarDialog(BuildContext context) async {
  final imageNames = await _loadAvatarImageNames();
  easyInfo(stringify(imageNames));
  String? selectedImage;

  await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Selecciona un avatar'),
        content: Container(
          width: double.maxFinite,
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 4.0,
              mainAxisSpacing: 4.0,
            ),
            itemCount: imageNames.length,
            itemBuilder: (context, index) {
              final imageName = imageNames[index];
              print(imageName);
              return GestureDetector(
                onTap: () {
                  selectedImage = imageName;
                },
                child: GridTile(
                  child: Image.asset('assets/images/avatars/$imageName.jpg'),
                ),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            child: Text('Nah'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.of(context).pop(selectedImage);
            },
          ),
        ],
      );
    },
  );

  return selectedImage;
}

Future<List<String>> _loadAvatarImageNames() async {
  final manifestContent = await rootBundle.loadString('AssetManifest.json');
  final Map<String, dynamic> manifestMap = parse(manifestContent);
  final imagePaths = manifestMap.keys
      .where((String key) =>
          key.startsWith('assets/images/avatars') && key.endsWith('.jpg'))
      .toList();
  return imagePaths
      .map((path) => path.split('/').last.replaceAll('.jpg', ''))
      .toList();
}
