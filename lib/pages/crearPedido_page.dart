import 'package:flutter/material.dart';

//  EL FRONT ESTA HASTA ABAJO - DEJE LO RELACIONADO A BACKEND AL PRINCIPIO
//     -ahora aparecen iconos pero seran imagenes, uso iconos mientras para no estar agregando assets aun al programa
//     -las listas y todo eso estan inventadas para testear, luego linkeo a base de datos
//     -el kappan se la come

// Modelo de Producto  (no recuerdo si era asi xdd)
class Producto {
  final int id;
  final String nombre;
  final String descripcion;
  final int precio;

  Producto(
      {required this.id,
      required this.nombre,
      required this.descripcion,
      required this.precio});
}

// Modelo de Pedido
class Pedido {
  final int id;
  final List<Producto> productos;
  final String mesa;
  final DateTime fecha;
  final String estado;
  final int valor;

  Pedido({
    required this.id,
    required this.productos,
    required this.mesa,
    required this.fecha,
    required this.estado,
    required this.valor,
  });
}

// Página de Crear Pedido
class CrearPedidoPage extends StatefulWidget {
  const CrearPedidoPage({super.key});

  @override
  State<CrearPedidoPage> createState() => _CrearPedidoPageState();
}

class _CrearPedidoPageState extends State<CrearPedidoPage> {
  List<Producto> productos = [
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
    Producto(
        id: 3,
        nombre: 'Producto 3',
        descripcion: 'Descripción 3',
        precio: 2000),
  ];

  List<Producto> productosSeleccionados = [];
  int currentIdPedido = 1;

  void toggleProductoSeleccionado(Producto producto) {
    setState(() {
      if (productosSeleccionados.contains(producto)) {
        productosSeleccionados.remove(producto);
      } else {
        productosSeleccionados.add(producto);
      }
    });
  }

  // Lógica para guardar el pedido en la base de datos o donde sea que deba ir
  void confirmarPedido() {
    final valorTotal =
        productosSeleccionados.fold(0, (sum, item) => sum + item.precio);

    final nuevoPedido = Pedido(
      id: currentIdPedido++,
      productos: productosSeleccionados,
      mesa: 'Mesa 1',
      fecha: DateTime.now(),
      estado: 'PENDIENTE',
      valor: valorTotal,
    );

    setState(() {
      productosSeleccionados.clear();
    });

    //mensajito wapo
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Pedido confirmado! Valor total: $valorTotal \$')),
    );
  }

  // Mostrar diálogo de confirmación antes de confirmar el pedido
  Future<void> mensajeConfirmarPedido() async {
    final result = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirmar Pedido'),
        content: Text('¿Estás seguro de que deseas confirmar este pedido?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: Text('No'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: Text('Sí'),
          ),
        ],
      ),
    );

    if (result == true) {
      confirmarPedido();
    }
  }

  // Método para calcular el valor total - quiza no deba ser redundante, pero bueno, tarea del maxi del futuro
  int get valorTotal =>
      productosSeleccionados.fold(0, (sum, item) => sum + item.precio);

  //CANCELAR PEDIDO AL VOLVER
  Future<bool> cancelarPedido() async {
    final result = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirmar cancelación'),
        content: Text('¿Estás seguro de que deseas cancelar este pedido?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: Text('No'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                productosSeleccionados.clear();
              });
              Navigator.of(context).pop(true);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Pedido cancelado')),
              );
            },
            child: Text('Sí'),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  //FRONT
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: cancelarPedido,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Crear Pedido'),
        ),
        body: Column(
          children: [
            //lista productos
            Expanded(
              child: ListView.builder(
                itemCount: productos.length,
                itemBuilder: (context, index) {
                  final producto = productos[index];
                  final isSelected = productosSeleccionados.contains(producto);

                  return ListTile(
                    leading: Icon(Icons.fastfood),
                    title: Text(producto.nombre),
                    subtitle: Text(producto.descripcion),
                    trailing: Text('${producto.precio} \$'),
                    tileColor: isSelected
                        ? const Color.fromARGB(255, 102, 255, 0)
                        : null,
                    onTap: () => toggleProductoSeleccionado(producto),
                  );
                },
              ),
            ),

            //container con productos seleccionados
            if (productosSeleccionados.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  border: Border(top: BorderSide(color: Colors.grey)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Productos Seleccionados:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    ...productosSeleccionados.map((producto) =>
                        Text('${producto.nombre} - \$${producto.precio} ')),
                    SizedBox(height: 8.0),
                    Text(
                      'Valor Total: \$$valorTotal ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),

            //boton confirmar pedido
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: productosSeleccionados.isEmpty
                    ? null
                    : mensajeConfirmarPedido,
                child: Text('Confirmar Pedido'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
