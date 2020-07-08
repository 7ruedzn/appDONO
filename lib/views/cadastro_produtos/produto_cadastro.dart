import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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
  String urlImage;
  File imgFile;
  final _nomeController = TextEditingController();
  final _descricaoController = TextEditingController();
  final _precoController = TextEditingController();
  //final _disponibilidadeController = TextEditingController();

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
      body: ListView(
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
          IconButton(
            icon: Icon(Icons.photo_camera),
            onPressed: () async {
              imgFile =
                  // ignore: deprecated_member_use
                  await ImagePicker.pickImage(source: ImageSource.camera);
              if (imgFile == null) {
                return;
              }
            },
          ),
          Container(
            child: Center(
              child: urlImage == null
                  ? Container()
                  : Image.network(
                      urlImage,
                      width: 200,
                      height: 200,
                    ),
            ),
          ),
          FlatButton(
            onPressed: () {
              _cadastrarProduto();
            },
            child: Text("Cadastrar produtos"),
          ),
        ],
      ),
    );
  }

  Future<void> _cadastrarProduto() async {
    if (imgFile != null) {
      await _cadastrarImagem(imgFile);
    }
    data['nome'] = _nomeController.text;
    data['descricao'] = _descricaoController.text;
    data['preco'] = double.parse(_precoController.text);
    _sendToFirestore(data);
    _dispose();
  }

  void _sendToFirestore(data) {
    Firestore.instance.collection('bebidas').add(data);
  }

  void _dispose() {
    _nomeController.clear();
    _descricaoController.clear();
    _precoController.clear();
  }

  void _cadastrarImagem(File imgFile) async {
    StorageUploadTask task = FirebaseStorage.instance
        .ref()
        .child(DateTime.now()
            .millisecondsSinceEpoch
            .toString()) // coloca em String a data atual, nome único para cada foto
        .putFile(imgFile);

    StorageTaskSnapshot taskSnapshot = await task.onComplete;
    urlImage = await await taskSnapshot.ref.getDownloadURL();
    data['foto'] = urlImage;
  }
}
