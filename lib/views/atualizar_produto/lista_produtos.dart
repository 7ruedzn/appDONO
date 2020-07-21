import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:obaratao/blocs/bloc_produto.dart';
import 'package:obaratao/models/produtoDados.dart';
import 'package:obaratao/screens/home_screen.dart';
import 'package:obaratao/utils/nav.dart';
import 'package:obaratao/views/cadastro_produtos/produto_cadastro.dart';
import 'package:obaratao/widgets/layout_color.dart';

import 'atualizar_produto.dart';

class ListaProdutos extends StatefulWidget {
  @override
  _ListaProdutosState createState() => _ListaProdutosState();
}

class _ListaProdutosState extends State<ListaProdutos> {
  BlocProduto blocProduto;
  ProdutoDados produto = ProdutoDados();
  List<ProdutoDados> productList = [];
  bool _onRefresh = false;

  @override
  void initState() {
    super.initState();
    blocProduto = BlocProduto();
    blocProduto.getAllProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Produtos'),
        backgroundColor: LayoutColor.secondaryColor,
        centerTitle: true,
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              push(context, HomeScreen(), replace: true);
            }),
      ),
      body: StreamBuilder(
          stream: _onRefresh ? null : blocProduto.outProducts,
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return Center(
                  child: Text(
                    'Verifique sua conexão!',
                    style: TextStyle(color: Colors.black),
                  ),
                );
              case ConnectionState.waiting:
                return Center(
                  child: CircularProgressIndicator(),
                );
              default:
                productList = snapshot.data;
                return ListView.builder(
                  itemCount: productList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () => push(context,
                            AtualizarProduto(productList[index], blocProduto)),
                      child: Card(
                        child: ListTile(
                          leading: Container(
                            alignment: Alignment.centerLeft,
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                            ),
                            child: Image.network(
                              productList[index].foto,
                              fit: BoxFit.scaleDown,
                            ),
                          ),
                          title: Text(productList[index].nome),
                          subtitle: Text('R\$ ' +
                            productList[index]
                            .preco
                            .toStringAsFixed(2)
                            .replaceAll(".", ",")),
                          trailing: SizedBox(
                            width: 50.0,
                            height: 32.0,
                            child: MaterialButton(
                              color: Colors.yellow,
                              padding: EdgeInsets.zero,
                              minWidth: double.infinity,
                              onPressed: () => _deleteProduct(
                                  productList[index].categoria,
                                  productList[index]),
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  color: Colors.black,
                                ),
                                borderRadius: BorderRadius.circular(13),
                              ),
                              child: Icon(Icons.delete_forever),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
            }
          }),
      floatingActionButton: FloatingActionButton(
          backgroundColor: LayoutColor.primaryColor,
          child: Icon(Icons.add, color: Colors.white),
          onPressed: () {
            push(context, ProdutoCadastro());
          }),
    );
  }

  Future<void> _deleteProduct(String categoria, ProdutoDados p) async {
    DocumentReference productIdRef = Firestore.instance
        .collection("produtos")
        .document(categoria)
        .collection("produtos")
        .document(p.id);
    await productIdRef.delete();
    push(context, ListaProdutos(), replace: true);
  }
}
