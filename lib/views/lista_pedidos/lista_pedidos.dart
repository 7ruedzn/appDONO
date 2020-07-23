import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:obaratao/widgets/order_tile.dart';

class ListPedidos extends StatefulWidget {
  @override
  _ListPedidosState createState() => _ListPedidosState();
}

class _ListPedidosState extends State<ListPedidos> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: Firestore.instance.collection("orders").getDocuments(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return ListView(
            children: snapshot.data.documents
                .map((doc) => ListaPedidos(doc.documentID))
                .toList(),
          );
        }
      },
    );
  }
}
