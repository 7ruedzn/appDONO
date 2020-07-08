import 'package:flutter/material.dart';
import 'package:obaratao/utils/nav.dart';
import 'package:obaratao/views/cadastro_produtos/categoria_cadastro.dart';
import 'package:obaratao/views/cadastro_produtos/produto_cadastro.dart';
import '../../widgets/layoutApp.dart';
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
        Center(
          child: Column(children: [
            FlatButton(
              onPressed: () {
                push(context, ProdutoCadastro());
              },
              child: Text("Cadastro de Produtos"),
            ),
            FlatButton(
              onPressed: () {
                push(context, CategoriaCadastro());
              },
              child: Text("Criar Categorias"),
            ),
          ]),
        )
      ],
    );
  }
}
