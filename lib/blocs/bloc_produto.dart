import 'dart:async';
import 'dart:io';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class BlocProduto extends BlocBase {
  File imgFile;
  Map<String, dynamic> data = {};
  String urlImage;

  var nomeController = TextEditingController();
  var descricaoController = TextEditingController();
  var precoController = TextEditingController();
  //final _disponibilidadeController = TextEditingController();

  loadImage() async {
    imgFile =
        // ignore: deprecated_member_use
        await ImagePicker.pickImage(source: ImageSource.camera);
    if (imgFile == null) {
      return;
    }
  }

  Future<void> cadastrarProduto() async {
    if (imgFile != null) {
      await _cadastrarImagem(imgFile);
    }
    data['nome'] = nomeController.text;
    data['descricao'] = descricaoController.text;
    data['preco'] = double.parse(precoController.text);
    _sendToFirestore(data);
    _dispose();
  }

  void _sendToFirestore(data) {
    Firestore.instance.collection('bebidas').add(data);
  }

  void _dispose() {
    nomeController.clear();
    descricaoController.clear();
    precoController.clear();
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
