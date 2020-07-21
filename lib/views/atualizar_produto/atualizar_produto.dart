import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:obaratao/blocs/bloc_produto.dart';
import 'package:obaratao/models/produtoDados.dart';
import 'package:obaratao/utils/messages.dart';
import 'package:obaratao/utils/nav.dart';
import 'package:obaratao/widgets/cus_text_form_field.dart';
import 'package:obaratao/widgets/layout_color.dart';

import 'lista_produtos.dart';

class AtualizarProduto extends StatefulWidget {
  ProdutoDados produto;
  BlocProduto bloc;
  AtualizarProduto(this.produto, this.bloc);

  @override
  _AtualizarProdutoState createState() => _AtualizarProdutoState(produto, bloc);
}

class _AtualizarProdutoState extends State<AtualizarProduto> {
  ProdutoDados produto;
  BlocProduto bloc;
  _AtualizarProdutoState(this.produto, this.bloc);

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  var productBloc = BlocProduto();
  bool _isLoading = false; //bool para acionar o circular progresss indicator
  bool _isLoadingImage = false;
  bool _editName = false;
  bool _editDescription = false;
  bool _editPrice = false;
  bool _editEstoque = false;
  bool _estoqueDoNotChanged = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        title: Text('Atualizar Produto'),
        centerTitle: true,
        backgroundColor: LayoutColor.secondaryColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 5.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                //FOTO

                StreamBuilder(
                    stream: productBloc.outFoto,
                    builder: (context, AsyncSnapshot<String> snapshot) {
                      return Container(
                        height: size.height / 4,
                        width: size.width / 2,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                          border: Border(
                            top: BorderSide(color: Colors.black),
                            left: BorderSide(color: Colors.black),
                            right: BorderSide(color: Colors.black),
                            bottom: BorderSide(color: Colors.black), 
                          ),
                        ),
                        child: snapshot.connectionState ==
                                    ConnectionState.waiting &&
                                _isLoadingImage == true
                            ? Center(
                                child: CircularProgressIndicator(),
                              )
                            : ClipRRect(
                              borderRadius: BorderRadius.circular(15.0),
                              child: Image.network(produto.foto, fit: BoxFit.fill),
                            ),
                      );
                    }),
                SizedBox(height: 20.0),

                //ICONE DA CÂMERA

                Container(
                  //padding: EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50.0),
                    border: Border(
                      top: BorderSide(color: Colors.black),
                      left: BorderSide(color: Colors.black),
                      right: BorderSide(color: Colors.black),
                      bottom: BorderSide(color: Colors.black),
                    ),
                  ),
                  child: MaterialButton(
                    height: 50.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                    //tentar att a pagina quando tirar a foto;
                    onPressed: () async {
                      setState(() {
                        _isLoadingImage = true;
                      });
                      await productBloc.loadImage();
                    },
                    child: Icon(
                      Icons.photo_camera,
                      size: 40.0,
                    ),
                  ),
                ),
                SizedBox(height: 20.0),

                //NOME FORMS

                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Nome:"),
                    Spacer(),
                    Container(
                      //color: Colors.black,
                      height: 40,
                      width: 200,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: CusTextFormField(
                          labelText: _editName ? "" : "${produto.nome}",
                          controller: productBloc.nomeController,
                          validator: (_value) {
                            _value == null
                                ? "Coloque o nome do produto"
                                : productBloc.nomeController.text == produto.nome
                                    ? "O valor digitado é igual ao atual"
                                    : null;
                          },
                          keyboardType: TextInputType.text,
                          hintText: "Ex: Pão Francês",
                          enabled: _editName,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0),
                      child: SizedBox(
                        width: 50.0,
                        height: 32.0,
                        child: MaterialButton(
                          color: Colors.yellow,
                          padding: EdgeInsets.zero,
                          minWidth: double.infinity,
                          onPressed: () {
                            setState(() {
                              _editName = !_editName;
                            });
                          },
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              color: Colors.black,
                            ),
                            borderRadius: BorderRadius.circular(13),
                          ),
                          child: Icon(
                            Icons.edit,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.0),

                //DESCRICAO FORM

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Descrição:"),
                    Spacer(),
                    Container(
                      height: 40,
                      width: 200,
                      child: CusTextFormField(
                        labelText:
                            _editDescription ? "" : "${produto.descricao}",
                        controller: productBloc.descricaoController,
                        validator: (_value) {
                          _value.contains(new RegExp(r'[@#^?"{}|]'))
                              ? "Não coloque caracteres especiais"
                              : productBloc.descricaoController.text ==
                                      produto.descricao
                                  ? "O valor digitado é igual ao atual"
                                  : null;
                        },
                        keyboardType: TextInputType.text,
                        hintText: "Ex: Cerveja Pilsen",
                        enabled: _editDescription,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0),
                      child: SizedBox(
                        width: 50.0,
                        height: 32.0,
                        child: MaterialButton(
                          color: Colors.yellow,
                          padding: EdgeInsets.zero,
                          minWidth: double.infinity,
                          onPressed: () {
                            setState(() {
                              _editDescription = !_editDescription;
                            });
                          },
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              color: Colors.black,
                            ),
                            borderRadius: BorderRadius.circular(13),
                          ),
                          child: Icon(
                            Icons.edit,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.0),

                //PRECO FORM

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Preço:"),
                    Spacer(),
                    Container(
                      height: 40,
                      width: 200,
                      child: CusTextFormField(
                        labelText: _editPrice
                            ? ""
                            : 'R\$ ' +
                                produto.preco.toString().replaceAll(".", ","),
                        controller:
                            _editPrice ? productBloc.precoController : null,
                        validator: (_value) {
                          productBloc.precoController.numberValue == 0
                              ? "Coloque o preço do produto"
                              : productBloc.precoController.numberValue ==
                                      produto.preco
                                  ? "O valor digitado é igual ao atual"
                                  : null;
                        },
                        keyboardType: TextInputType.number,
                        enabled: _editPrice,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0),
                      child: SizedBox(
                        width: 50.0,
                        height: 32.0,
                        child: MaterialButton(
                          color: Colors.yellow,
                          padding: EdgeInsets.zero,
                          minWidth: double.infinity,
                          onPressed: () {
                            setState(() {
                              _editPrice = !_editPrice;
                            });
                          },
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              color: Colors.black,
                            ),
                            borderRadius: BorderRadius.circular(13),
                          ),
                          child: Icon(
                            Icons.edit,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.0),

                //ESTOQUE FORM

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Estoque:"),
                    Spacer(),
                    Container(
                      height: 40,
                      width: 200,
                      child: CusTextFormField(
                        labelText: _editEstoque
                            ? ""
                            : produto.estoque.toString().replaceAll(".", ","),
                        controller:
                            _editEstoque ? productBloc.estoqueController : null,
                        validator: (_value) {
                          productBloc.estoqueController.numberValue ==
                                  produto.estoque
                              ? "O valor digitado é igual ao atual"
                              : null;
                        },
                        keyboardType: TextInputType.number,
                        hintText: "Ex: 100",
                        enabled: _editEstoque,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0),
                      child: SizedBox(
                        width: 50.0,
                        height: 32.0,
                        child: MaterialButton(
                          color: Colors.yellow,
                          padding: EdgeInsets.zero,
                          minWidth: double.infinity,
                          onPressed: () {
                            setState(() {
                              _estoqueDoNotChanged = !_estoqueDoNotChanged;
                              _editEstoque = !_editEstoque;
                            });
                          },
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              color: Colors.black,
                            ),
                            borderRadius: BorderRadius.circular(13),
                          ),
                          child: Icon(
                            Icons.edit,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.0),

                //ATUALIZAR PRODUTO BUTTON

                Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 30.0),
                    child: Container(
                      padding: EdgeInsets.only(top: 3.0, left: 3.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50.0),
                          border: Border(
                            top: BorderSide(color: Colors.black),
                            left: BorderSide(color: Colors.black),
                            right: BorderSide(color: Colors.black),
                            bottom: BorderSide(color: Colors.black),
                          )),
                      child: MaterialButton(
                        minWidth: double.infinity,
                        height: 60.0,
                        onPressed: () async {
                          try {
                            if (_formKey.currentState.validate()) {
                              _checkInputs();
                              await productBloc.atualizarProduto(
                                  produto.id, produto.categoria);
                              push(context, ListaProdutos(), replace: true);
                            }
                          } catch (e) {
                            _onFail();
                          }
                        },
                        color: Colors.yellow,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Icon(
                          Icons.cloud_upload,
                          size: 40.0,
                        ),
                      ),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _checkInputs() {
    if (productBloc.nomeController.text == "") {
      productBloc.nomeController.text = produto.nome;
    }
    if (productBloc.descricaoController.text == "") {
      productBloc.descricaoController.text = produto.descricao;
    }
    if (productBloc.fotoController.text == "") {
      productBloc.fotoController.text = produto.foto;
    }
    if (productBloc.precoController.numberValue == 0.0) {
      productBloc.precoController.updateValue(produto.preco + 0.0);
    }
    if (productBloc.estoqueController.numberValue == 0.0 &&
        _estoqueDoNotChanged) {
      productBloc.estoqueController.updateValue(produto.estoque + 0.0);
    }
  }

  void _onFail() {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(
        "Falha ao atualizar o produto, tente novamente",
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.black,
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: Colors.redAccent,
      duration: Duration(seconds: 2),
    ));
  }
}
