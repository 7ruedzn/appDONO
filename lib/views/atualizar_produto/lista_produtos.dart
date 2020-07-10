import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:obaratao/models/produtoDados.dart';
import 'package:obaratao/utils/nav.dart';
import 'package:obaratao/views/atualizar_produto/atualizar_widget.dart';

class ListaProdutos extends StatefulWidget {
  @override
  _ListaProdutosState createState() => _ListaProdutosState();
}

class _ListaProdutosState extends State<ListaProdutos> {
  ProdutoDados produto;
  List<ProdutoDados> listProducts = [];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Atualizar Produto'),
      ),
      body: FutureBuilder(
      future: Firestore.instance.collection("produtos").getDocuments().then((value) {
        List<DocumentSnapshot> _listDocuments = value.documents;
        _listDocuments.forEach((_doc){
          produto = ProdutoDados.fromDocument(_doc);
          listProducts.add(produto);
        });
      }),
      builder: (context, snapshot) {
        switch (snapshot.connectionState){
          case ConnectionState.none:
            return Center(
              child: Text('Verifique sua conexão!', style: TextStyle(color: Colors.black),),
            );
          case ConnectionState.waiting:
            return Center(
              child: CircularProgressIndicator(),
            );
          default:
            return ListView.builder(
              padding: EdgeInsets.all(5.0),
              scrollDirection: Axis.vertical,
              itemCount: listProducts.length,
              itemBuilder: (BuildContext context, int index){
                return Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Column(
                    children: <Widget>[
                      InkWell(
                        onTap: (){
                          push(context, AtualizarProduto(listProducts[index]));
                        },
                        borderRadius: BorderRadius.circular(10.0),
                        child: Card(
                          elevation: 3.0,
                          child: Container(
                            width: 300,
                            height: 50,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                alignment: Alignment.centerLeft,
                                image: NetworkImage(listProducts[index].icon),
                                fit: BoxFit.contain,
                              ),
                            ),
                            child: Center(child: Text(listProducts[index].title)),
                          ),
                        ),
                      )
                    ],
                  ),
                );
              }
            );
        }
      }
      ),
    );
  }
}