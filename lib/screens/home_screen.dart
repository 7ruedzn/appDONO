import 'package:flutter/material.dart';
import 'package:obaratao/utils/nav.dart';
import 'package:obaratao/views/atualizar_produto/atualizar_produto.dart';
import 'package:obaratao/views/atualizar_produto/lista_produtos.dart';
import 'package:obaratao/views/cadastro_produtos/produto_cadastro.dart';
import 'package:obaratao/widgets/layout_color.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            Container(
              height: 70,
            ),
            ListTile(
              title: Text("Seus produtos cadastrados"),
              trailing: Icon(Icons.arrow_right),
              onTap: () {
                push(context, ListaProdutos());
              },
            ),
            ListTile(
              title: Text("Logout"),
              trailing: Icon(Icons.arrow_right),
              onTap: () {
                push(context, ListaProdutos());
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text("Lista de Pedidos"),
        centerTitle: true,
        backgroundColor: LayoutColor.secondaryColor,
      ),
      body: Container(),
    );
  }
}
