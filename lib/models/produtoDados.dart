import 'package:cloud_firestore/cloud_firestore.dart';

class ProdutoDados {
  String categoria;
  String id;
  String title;
  String icon;

  String nome;
  String descricao;
  String foto;

  double preco;
  double estoque;

  List images;
  List tamanhos;

  List<String> categorias;
  ProdutoDados() {
    this.categorias = [
      'Bebidas',
      'Churrasco',
      'Congelados',
      'Depósito',
      'Enlatados',
      'Frios',
      'Higiene',
      'Hortifrúti',
      'Padaria',
      'Diversos',
    ];
  }

  ProdutoDados.fromDocument(DocumentSnapshot snapshot) {
    title = snapshot.data["title"];
    icon = snapshot.data["icon"];
    id = snapshot.documentID;
    nome = snapshot.data["nome"];
    descricao = snapshot.data["descricao"];
    preco = snapshot.data["preco"] + (0.0);
    estoque = snapshot.data["estoque"];
    images = snapshot.data["images"];
    tamanhos = snapshot.data["tamanhos"];
    foto = snapshot.data["foto"];
  }
}
