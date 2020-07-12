import 'package:flutter/material.dart';
import 'package:obaratao/views/cadastro_produtos/produto_cadastro.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cadastre seus produtos"),
        centerTitle: true,
      ),
      body: ProdutoCadastro(),
    );
  }
}
