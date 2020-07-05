import 'package:flutter/material.dart';
import 'package:obaratao/models/produto.dart';
import 'package:obaratao/utils/nav.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'lista_produtos.dart';

class ProdutoCadastro extends StatefulWidget {
  Produto produto = Produto();
  @override
  _ProdutoCadastroState createState() => _ProdutoCadastroState();
}

class _ProdutoCadastroState extends State<ProdutoCadastro> {
  Produto produto2 = Produto();
  Map<String, dynamic> data = {};
  final _nomeController = TextEditingController();
  final _descricaoController = TextEditingController();
  final _precoController = TextEditingController();
  final _disponibilidadeController = TextEditingController();

  _textField(
      {String labelText,
      TextEditingController controller,
      TextInputType keyboardType,
      bool obscureText = false,
      void Function(String) onChanged,
      String Function() errorText}) {
    return TextField(
      keyboardType: keyboardType,
      controller: controller,
      obscureText: obscureText,
      onChanged: onChanged,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: labelText,
        errorText: errorText == null ? null : errorText(),
      ),
    );
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
      body: _body(),
    );
  }

  _body() {
    return ListView(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(8.0),
          child: _textField(
            controller: _nomeController,
            labelText: "nome do produto",
          ),
        ),
        Container(
          padding: EdgeInsets.all(8.0),
          child: _textField(
            controller: _descricaoController,
            labelText: "descrição do produto",
          ),
        ),
        Container(
          padding: EdgeInsets.all(8.0),
          child: _textField(
            controller: _precoController,
            keyboardType: TextInputType.number,
            labelText: "preço do produto",
          ),
        ),
        Container(
          padding: EdgeInsets.all(8.0),
          child: _textField(
            controller: _disponibilidadeController,
            onChanged: (number) {},
            keyboardType: TextInputType.number,
            labelText: "disponibilidade do produto",
          ),
        ),
        FlatButton(
          onPressed: () {
            _cadastrarProduto();
          },
          child: Text("Cadastrar produtos"),
        ),
      ],
    );
  }

  void _cadastrarProduto() {
    widget.produto.nome = _nomeController.text;
    widget.produto.descricao = _descricaoController.text;
    widget.produto.preco = double.parse(_precoController.text);
    widget.produto.disponibilidade =
        double.parse(_disponibilidadeController.text);
    _sendToFirestore();
    _dispose();
  }

  void _sendToFirestore() {
    data['nome'] = widget.produto.nome;
    data['descricao'] = widget.produto.descricao;
    data['preco'] = widget.produto.preco;
    data['disponibilidade'] = widget.produto.disponibilidade;

    Firestore.instance.collection('teste').add(data);
  }

  void _dispose() {
    _nomeController.clear();
    _descricaoController.clear();
    _precoController.clear();
    _disponibilidadeController.clear();
  }
}
