import 'package:flutter/material.dart';
import 'package:obaratao/models/user_model.dart';
import 'package:obaratao/views/lista_pedidos/lista_pedidos.dart';
import 'package:obaratao/views/login/loginpage.dart';
import 'package:scoped_model/scoped_model.dart';
import 'screens/home_screen.dart';
import 'widgets/layout_color.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModel<UserModel>(
      model: UserModel(),
      child: ScopedModelDescendant<UserModel>(
        builder: (context, child, model) {
          print(model.isLoggedIn());
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primarySwatch: LayoutColor.secondaryColor,
            ),
            home: model.isLoggedIn() ? HomeScreen() : LoginPage(),
          );
        },
      ),
    );
  }
}
