import 'dart:async';
import 'dart:io';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:image_picker/image_picker.dart';
import 'package:obaratao/models/produtoDados.dart';
import 'package:obaratao/service/firestore_service.dart';

class BlocProduto extends BlocBase {
  File imgFile;
  Map<String, dynamic> data = {};
  String urlImage;
  ProdutoDados produto = ProdutoDados();
  Service service = Service();

  final StreamController<List<ProdutoDados>> _productsController$ =
      StreamController<List<ProdutoDados>>();

  Stream<List<ProdutoDados>> get outProducts => _productsController$.stream;

  var nomeController = TextEditingController();
  var descricaoController = TextEditingController();
  var fotoController = TextEditingController();
  var categoriaController = TextEditingController();
  var precoController = new MoneyMaskedTextController(leftSymbol: 'R\$ ', precision: 2);
  var estoqueController =
      new MoneyMaskedTextController(precision: 0, decimalSeparator: "");

  loadImage() async {
    imgFile =
        // ignore: deprecated_member_use
        await ImagePicker.pickImage(source: ImageSource.camera);
    if (imgFile == null) {
      return;
    } else {
      _cadastrarImagem(imgFile);
    }
  }

  Future<void> cadastrarProduto() async {
    data['nome'] = nomeController.text;
    data['descricao'] = descricaoController.text;
    data['preco'] = precoController.numberValue;
    data['estoque'] = estoqueController.numberValue;
    data['foto'] = fotoController.text;
    String _categoria = categoriaController.text;
    _sendToFirestore(
      data,
      _categoria,
    );
    _dispose();
  }

  validarProduto() {
    validarNome() {}
  }

  Future<void> atualizarProduto(String id, String categoria) async {
    Map<String, dynamic> _data = {};
    _data['nome'] = nomeController.text;
    _data['descricao'] = descricaoController.text;
    _data['preco'] = precoController.numberValue;
    _data['estoque'] = estoqueController.numberValue;
    _data['foto'] = fotoController.text;
    await _updateToFirestore(id, _data, categoria);

    //String _categoria = categoriaController.text;
  }

  Future<void> _updateToFirestore(String id, Map<String, dynamic> data, String categoria) async {
    await Firestore.instance.
    collection("produtos").
    document(categoria).
    collection("produtos").
    document(id).
    setData(data, merge: true);
    _dispose();
  }

  void _sendToFirestore(Map<String, dynamic> data, String categoria) {
    Firestore.instance
        .collection("produtos")
        .document(categoria)
        .collection("produtos")
        .add(data);
  }

  void _dispose() {
    nomeController.clear();
    descricaoController.clear();
    precoController.updateValue(0.0);
    estoqueController.clear();
    fotoController.clear();
    categoriaController.clear();
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
    fotoController.text = urlImage;
  }

  Future<void> getAllProducts() async {
    List<ProdutoDados> _productList = [];
    QuerySnapshot querySnapshot;

    produto.categorias.forEach((_category) async {
      ProdutoDados _produto = ProdutoDados();
      querySnapshot = await service.getDocumentsByCategory(_category);

      if (querySnapshot.documents.isNotEmpty ||
          querySnapshot.documents.length > 0) {
        querySnapshot.documents.forEach((_doc) {
          _produto = ProdutoDados.fromDocument(_doc);
          _produto.categoria = _category;
          _productList.add(_produto);
        });
        _productsController$.add(_productList);
      }
    });
  }

  @override
  void dispose() {
    _productsController$.close();
    super.dispose();
  }
}
