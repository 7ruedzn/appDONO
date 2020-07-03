import 'package:flutter/material.dart';
import 'layoutApp.dart';
import 'recebePedido.dart';

class PedidosWidget extends StatelessWidget {
  static String tag = 'pedidos';
  @override
  Widget build(BuildContext context) {
    final content = Pedidos();
    return LayoutTeste.getLayoutTesteContent(context, content);
  }
}

class Pedidos extends StatefulWidget {
  @override
  _PedidosState createState() => _PedidosState();
}

class _PedidosState extends State<Pedidos> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          color: Colors.blue,
          width: 300,
          height: 100,
        )
      ],
    );
  }
}