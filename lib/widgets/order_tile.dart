import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ListaPedidos extends StatelessWidget {
  final String orderId;
  ListaPedidos(this.orderId);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: StreamBuilder<DocumentSnapshot>(
            stream: Firestore.instance
                .collection("orders")
                .document(orderId)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData)
                return Center(
                  child: CircularProgressIndicator(),
                );
              else {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("Código do pedido: ${snapshot.data.documentID}", style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.normal,
                      fontStyle: FontStyle.italic,
                    ),),
                    SizedBox(height: 4.0),
                    Text(_buildProductsText(snapshot.data), style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w700,
                    ),),
                  ],
                );
              }
            }),
      ),
    );
  }

  String _buildProductsText(DocumentSnapshot snapshot) {
    String text = "Descrição:\n";
    for (LinkedHashMap p in snapshot.data["products"]) {
      text +=
          "${p["quantidade"]} x ${p["produto"]["nome"]} (R\$ ${p["produto"]["preco"].toStringAsFixed(2)})\n";
    }
    text += "Total: R\$ ${snapshot.data["totalPrice"].toStringAsFixed(2)}";
    return text;
  }
}
