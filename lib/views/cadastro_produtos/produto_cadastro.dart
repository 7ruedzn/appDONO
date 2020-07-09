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
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var productBloc = BlocProduto();

  @override
  void initState() {
    super.initState();
  }

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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                CusTextField(
                  controller: productBloc.nomeController,
                  labelText: "nome do produto",
                ),
                CusTextField(
                  controller: productBloc.descricaoController,
                  labelText: "descrição do produto",
                ),
                CusTextField(
                  controller: productBloc.precoController,
                  keyboardType: TextInputType.number,
                  labelText: "preço do produto",
                ),
                IconButton(
                  icon: Icon(Icons.photo_camera),
                  onPressed: () async {
                    await productBloc.loadImage();
                  },
                ),
                FlatButton(
                  onPressed: () {
                    productBloc.cadastrarProduto();
                  },
                  child: Text("Cadastrar produtos"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
