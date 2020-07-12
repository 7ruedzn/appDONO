import 'package:flutter/material.dart';
import 'package:obaratao/utils/nav.dart';
import 'package:obaratao/views/atualizar_produto/atualizar_widget.dart';
import 'package:obaratao/views/atualizar_produto/lista_produtos.dart';
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
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.list),
              onPressed: () {
                push(context, ListaProdutos());
              }),
        ],
      ),
      body: ProdutoCadastro(),
    );
  }
}
