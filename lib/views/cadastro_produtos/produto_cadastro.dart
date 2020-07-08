import 'package:flutter/material.dart';
import 'package:obaratao/blocs/bloc_produto.dart';
import 'package:obaratao/utils/nav.dart';
import 'package:obaratao/widgets/cus_text_field.dart';

import 'lista_produtos.dart';

class ProdutoCadastro extends StatefulWidget {
  @override
  _ProdutoCadastroState createState() => _ProdutoCadastroState();
}

class _ProdutoCadastroState extends State<ProdutoCadastro> {
  BlocProduto bloc;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastro de Produtos'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.list),
            onPressed: () {
              push(context, ProductsList());
            },
          )
        ],
      ),
      body: ListView(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(8.0),
            child: CusTextField(
              controller: bloc.nomeController,
              labelText: "nome do produto",
            ),
          ),
          Container(
            padding: EdgeInsets.all(8.0),
            child: CusTextField(
              controller: bloc.descricaoController,
              labelText: "descrição do produto",
            ),
          ),
          Container(
            padding: EdgeInsets.all(8.0),
            child: CusTextField(
              controller: bloc.precoController,
              keyboardType: TextInputType.number,
              labelText: "preço do produto",
            ),
          ),
          IconButton(
            icon: Icon(Icons.photo_camera),
            onPressed: () async {
              await bloc.loadImage();
            },
          ),
          FlatButton(
            onPressed: () {
              bloc.cadastrarProduto();
            },
            child: Text("Cadastrar produtos"),
          ),
        ],
      ),
    );
  }
}
