import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:obaratao/models/produtoDados.dart';

class PedidoDados {
  String orderId;
  String clientId;
  int discount;
  var products = [];
  double productsPrice;
  double shipPrice;
  int status;
  double totalPrice;

  ProdutoDados produto = ProdutoDados();

  PedidoDados.fromDocument(DocumentSnapshot snapshot) {
    clientId = snapshot.data["clientId"];
    discount = snapshot.data["discount"];
    orderId = snapshot.documentID;
    productsPrice = snapshot.data["productsPrice"];
    shipPrice = snapshot.data["shipPrice"];
    status = snapshot.data["status"];
    totalPrice = snapshot.data["totalPrice"];
    products = snapshot.data["products"];
  }
}
