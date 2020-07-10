import 'package:flutter/material.dart';
import 'package:obaratao/blocs/bloc_produto.dart';
import 'package:obaratao/models/produtoDados.dart';
import 'package:obaratao/widgets/cus_text_field.dart';
import 'package:obaratao/widgets/layout_color.dart';

class AtualizarProduto extends StatefulWidget {
  ProdutoDados produto;
  AtualizarProduto(this.produto);

  @override
  _AtualizarProdutoState createState() => _AtualizarProdutoState(produto);
}

class _AtualizarProdutoState extends State<AtualizarProduto> {

  ProdutoDados produto;
  _AtualizarProdutoState(this.produto);

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
        title: Text('Atualizar Produto'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Container(
                  height: 200,
                  width: 200,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    image: DecorationImage(
                      image: NetworkImage(produto.foto),
                    )
                  ),
                ),
                SizedBox(height: 20.0),
                CusTextField(
                  controller: productBloc.nomeController,
                  labelText: "Mudar Nome do Produto",
                ),
                SizedBox(height: 20.0),
                CusTextField(
                  controller: productBloc.descricaoController,
                  labelText: "Mudar Descrição do produto",
                ),
                SizedBox(height: 20.0),
                CusTextField(
                  controller: productBloc.precoController,
                  keyboardType: TextInputType.number,
                  labelText: "Mudar Preço do produto",
                ),
                SizedBox(height: 20.0),
                FlatButton(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                  onPressed: () {
                    productBloc.atualizarProduto();
                  },
                  color: LayoutColor.primaryColor,
                  child: Text(
                    "Atualizar Produto",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                    ),
                    ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}