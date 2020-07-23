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
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  BlocProduto blocProduto = BlocProduto();
  ProdutoDados produto = ProdutoDados();
  List<ProdutoDados> productList = [];
  bool _onRefresh = false;

  @override
  void initState() {
    super.initState();
    blocProduto.getAllProducts();
    print(">> init bloc.getAllProducts");
  }

  @override
  void dispose() {
    super.dispose();
    print(">> dispose bloc.getAllProducts");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Clique no + para adicionar produtos!",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        CircularProgressIndicator(),
                      ]),
                );
              default:
                productList = snapshot.data;
                if (productList.length != 0 ||
                    productList != [] ||
                    productList != null) {
                  return ListView.builder(
                    itemCount: productList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () {
                          push(
                              context,
                              AtualizarProduto(
                                  productList[index], blocProduto));
                        },
                        child: Card(
                          color: productList[index].estoque < 15
                              ? Colors.red
                              : Colors.white,
                          child: ListTile(
                            leading: Container(
                              alignment: Alignment.centerLeft,
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(),
                              child: Image.network(
                                productList[index].foto,
                                fit: BoxFit.scaleDown,
                              ),
                            ),
                            title: Text(productList[index].nome),
                            subtitle: Text(
                              'R\$ ' +
                                  productList[index]
                                      .preco
                                      .toStringAsFixed(2)
                                      .replaceAll(".", ",") +
                                  ' - Estoque: ' +
                                  productList[index].estoque.toStringAsFixed(0),
                              maxLines: 2,
                              overflow: TextOverflow.clip,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            trailing: SizedBox(
                              width: 50.0,
                              height: 32.0,
                              child: MaterialButton(
                                color: Colors.yellow,
                                padding: EdgeInsets.zero,
                                minWidth: double.infinity,
                                onPressed: () => blocProduto
                                    .deleteProduct(productList[index].categoria,
                                        productList[index])
                                    .whenComplete(() {
                                  blocProduto.getAllProducts();
                                  _showSnackBar("Produto excluído com sucesso!",
                                      LayoutColor.secondaryColor);
                                }),
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
                } else {
                  return Center(
                    child: Text("Nenhum produto cadastrado ainda!"),
                  );
                }
            }
          }),
      floatingActionButton: FloatingActionButton(
          backgroundColor: LayoutColor.primaryColor,
          child: Icon(Icons.add, color: Colors.white),
          onPressed: () {
            push(context, ProdutoCadastro());
            dispose();
          }),
    );
  }

  void _showSnackBar(String msg, Color cor) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(
        msg,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.black,
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: cor,
      duration: Duration(seconds: 2),
    ));
  }
}
