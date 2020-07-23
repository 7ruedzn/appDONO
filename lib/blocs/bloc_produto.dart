import 'dart:async';
import 'dart:io';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:obaratao/models/produtoDados.dart';
import 'package:obaratao/service/firestore_service.dart';
import 'package:obaratao/utils/nav.dart';
import 'package:obaratao/views/atualizar_produto/lista_produtos.dart';
import 'package:obaratao/widgets/layout_color.dart';

class BlocProduto extends BlocBase {
  final StreamController<List<ProdutoDados>> _productsController$ =
      StreamController<List<ProdutoDados>>();

  Stream<List<ProdutoDados>> get outProducts => _productsController$.stream;

  var nomeController = TextEditingController();
  var descricaoController = TextEditingController();
  var categoriaController = TextEditingController();
  var precoController = new MoneyMaskedTextController(
      leftSymbol: 'R\$ ', precision: 2, decimalSeparator: ".");
  var estoqueController = TextEditingController();

  Future<String> takePicture() async {
    File _imgFile =
        // ignore: deprecated_member_use
        await ImagePicker.pickImage(source: ImageSource.camera);
    if (_imgFile == null) {
      return "";
    } else {
      File _fileCropped = await _cropImage(_imgFile);
      String _urlReturn = await _cadastrarImagem(_fileCropped);
      return _urlReturn;
    }
  }

  Future<String> selectFromGallery() async {
    File _imgFile =
        // ignore: deprecated_member_use
        await ImagePicker.pickImage(source: ImageSource.gallery);
    if (_imgFile == null) {
      return "";
    } else {
      File _fileCropped = await _cropImage(_imgFile);
      String _urlReturn = await _cadastrarImagem(_fileCropped);
      return _urlReturn;
    }
  }

  Future<String> _cadastrarImagem(File imgFile) async {
    StorageUploadTask task = FirebaseStorage.instance
        .ref()
        .child(DateTime.now()
            .millisecondsSinceEpoch
            .toString()) // coloca em String a data atual, nome único para cada foto
        .putFile(imgFile);

    StorageTaskSnapshot taskSnapshot = await task.onComplete;
    String _urlImage = await taskSnapshot.ref.getDownloadURL();
    return _urlImage;
  }

  Future<File> _cropImage(File _image) async {
    File cropped = await ImageCropper.cropImage(
      androidUiSettings: AndroidUiSettings(
        showCropGrid: true,
        cropGridColor: Colors.black,
        cropFrameColor: Colors.black,
        backgroundColor: Colors.black,
        toolbarWidgetColor: Colors.white,
        activeControlsWidgetColor: LayoutColor.primaryColor,
        toolbarTitle: 'Recorte a imagem',
        toolbarColor: LayoutColor.primaryColor,
        statusBarColor: Colors.white,
      ),
      compressQuality: 80,
      sourcePath: _image.path,
      aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
      //maxHeight: int.fromEnvironment("cropImage"),
    );
    return cropped;
  }

  Future<void> cadastrarProduto(String _image) async {
    Map<String, dynamic> _data = {};
    _data['nome'] = nomeController.text;
    _data['descricao'] = descricaoController.text;
    _data['preco'] = precoController.numberValue + 0.0;
    _data['estoque'] = double.parse(estoqueController.text) + 0.0;
    _data['foto'] = _image;
    String _categoria = categoriaController.text;
    _sendToFirestore(
      _data,
      _categoria,
    );
    clearAll();
  }

  Future<void> deleteProduct(String categoria, ProdutoDados p) async {
    await Firestore.instance
        .collection("produtos")
        .document(categoria)
        .collection("produtos")
        .document(p.id)
        .delete();
  }

  Future<void> atualizarProduto(
      String id, String categoria, String _img) async {
    Map<String, dynamic> _data = {};
    _data['nome'] = nomeController.text;
    _data['descricao'] = descricaoController.text;
    _data['preco'] = precoController.numberValue + 0.0;
    _data['estoque'] = double.parse(estoqueController.text) + 0.0;
    _data['foto'] = _img;
    await _updateToFirestore(id, _data, categoria);

    //String _categoria = categoriaController.text;
  }

  Future<void> _updateToFirestore(
      String id, Map<String, dynamic> data, String categoria) async {
    await Firestore.instance
        .collection("produtos")
        .document(categoria)
        .collection("produtos")
        .document(id)
        .setData(data, merge: true);
    clearAll();
  }

  void _sendToFirestore(Map<String, dynamic> data, String categoria) {
    Firestore.instance
        .collection("produtos")
        .document(categoria)
        .collection("produtos")
        .add(data);
  }

  void clearAll() {
    nomeController.clear();
    descricaoController.clear();
    precoController.updateValue(0.0);
    estoqueController.clear();
    categoriaController.clear();
  }

  Future<void> getAllProducts() async {
    List<ProdutoDados> _productList = [];
    QuerySnapshot querySnapshot;
    ProdutoDados _produto = ProdutoDados();

    _produto.categorias.forEach((_category) async {
      ProdutoDados _produto = ProdutoDados();
      Service _service = Service();
      querySnapshot = await _service.getDocumentsByCategory(_category);

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

  bool checkUpdateInputs(
      bool _estoqueDoNotChanged, ProdutoDados _p, String _img) {
    if (nomeController.text.isEmpty &&
        descricaoController.text.isEmpty &&
        precoController.numberValue == 0.0 &&
        estoqueController.text.isEmpty &&
        _img.isEmpty) {
      return true;
    } else {
      if (nomeController.text == "") {
        nomeController.text = _p.nome;
      }
      if (descricaoController.text == "") {
        descricaoController.text = _p.descricao;
      }
      if (precoController.numberValue == 0.0) {
        precoController.updateValue(_p.preco + 0.0);
      }
      if (estoqueController.text == "" && _estoqueDoNotChanged) {
        estoqueController.text = _p.estoque.toString();
        print(estoqueController.text);
      }
      return false;
    }
  }

  String validateEstoque(String _value) {
    if (_value == null || _value.isEmpty || _value == "") {
      return "Preencha o campo corretamente";
    } else {
      if (double.parse(estoqueController.text) > 100000) {
        return "Preencha o campo corretamente";
      } else {
        return null;
      }
    }
  }

  String validatePreco(String _value) {
    if (_value == null || _value.isEmpty || _value == "") {
      return "Preencha o campo corretamente";
    } else {
      if (precoController.numberValue > 10000 ||
          precoController.numberValue < 0.1) {
        return "Preencha o campo corretamente";
      } else {
        return null;
      }
    }
  }

  String validateNome(String _value) {
    if (_value == null || _value.isEmpty || _value == "" || _value.length < 3) {
      return "Preencha o campo corretamente";
    } else {
      if (_value.contains(new RegExp(r'[@#^?"{}|]'))) {
        return "Preencha o campo corretamente";
      } else {
        return null;
      }
    }
  }

  String validateDescricao(String _value) {
    if (_value == null || _value.isEmpty || _value == "") {
      return "Preencha o campo corretamente";
    } else {
      if (_value.contains(new RegExp(r'[@#^?"{}|]'))) {
        return "Preencha o campo corretamente";
      } else {
        return null;
      }
    }
  }

  @override
  void dispose() {
    _productsController$.close();
    super.dispose();
  }
}
