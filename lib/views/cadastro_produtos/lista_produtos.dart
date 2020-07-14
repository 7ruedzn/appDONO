import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:obaratao/models/produto.dart';

class ProductsList extends StatefulWidget {
  @override
  _ProductsListState createState() => _ProductsListState();
}

class _ProductsListState extends State<ProductsList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de Produtos"),
      ),
      body: Column(children: [
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance.collection('teste').snapshots(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  default:
                    List<DocumentSnapshot> produtos = snapshot.data.documents;
                    return ListView.builder(
                      itemCount: produtos.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(produtos[index].data['nome']),
                          subtitle: Text(produtos[index].data['descricao']),
                          trailing:
                              Text(produtos[index].data['preco'].toString()),
                        );
                      },
                    );
                }
              }),
        ),
      ]),
    );
  }
}
