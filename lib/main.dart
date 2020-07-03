import 'package:flutter/material.dart';
import 'package:obaratao/pedidos_widget.dart';
import 'layout_color.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  final routes = <String, WidgetBuilder>{
    PedidosWidget.tag: (BuildContext context) => PedidosWidget(),
  };

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: LayoutColor.secondaryColor,
      ),
      home: PedidosWidget(),
      //routes: routes,
    );
  }
}
