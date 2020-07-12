import 'package:flutter/material.dart';
import 'package:obaratao/views/lista_pedidos/pedidos_widget.dart';
import 'screens/home_screen.dart';
import 'widgets/layout_color.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final routes = <String, WidgetBuilder>{
    PedidosWidget.tag: (BuildContext context) => PedidosWidget(),
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: LayoutColor.primaryColor,
      ),
      home: HomeScreen(),
      //routes: routes,
    );
  }
}
