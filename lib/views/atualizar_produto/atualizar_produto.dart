import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:obaratao/blocs/bloc_produto.dart';
import 'package:obaratao/models/exceptionManager.dart';
import 'package:obaratao/models/produtoDados.dart';
import 'package:obaratao/utils/messages.dart';
import 'package:obaratao/utils/nav.dart';
import 'package:obaratao/widgets/cus_text_form_field.dart';
import 'package:obaratao/widgets/layout_color.dart';
import 'package:toast/toast.dart';

import 'lista_produtos.dart';

class AtualizarProduto extends StatefulWidget {
  final ProdutoDados produto;
  final BlocProduto blocProduto;
  AtualizarProduto(this.produto, this.blocProduto);

  @override
  _AtualizarProdutoState createState() =>
      _AtualizarProdutoState(produto, blocProduto);
}

class _AtualizarProdutoState extends State<AtualizarProduto> {
  ProdutoDados produto;
  BlocProduto blocProduto;
  _AtualizarProdutoState(this.produto, this.blocProduto);

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isLoadingImage = false;
  bool _editName = false;
  bool _editDescription = false;
  bool _editPrice = false;
  bool _editEstoque = false;
  bool _estoqueDoNotChanged = true;
  String _image = "";

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return new WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                push(context, ListaProdutos(), replace: true);
              }),
          elevation: 0,
          title: Text('Atualizar Produto'),
          centerTitle: true,
          backgroundColor: LayoutColor.secondaryColor,
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.rotate_left),
                onPressed: () {
                  Navigator.pop(context);
                  push(context, AtualizarProduto(produto, blocProduto));
                  Toast.show("Página recarregada!", context,
                      duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
                })
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 5.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  //FOTO

                  Container(
                    height: size.height / 4,
                    width: size.width / 2,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.blueGrey,
                        border: Border(
                          top: BorderSide(color: Colors.black),
                          left: BorderSide(color: Colors.black),
                          right: BorderSide(color: Colors.black),
                          bottom: BorderSide(color: Colors.black),
                        )),
                    child: _isLoadingImage == true
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : _image != ""
                            ? Image.network(
                                _image,
                                fit: BoxFit.cover,
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(15.0),
                                child: Image.network(produto.foto,
                                    fit: BoxFit.fill),
                              ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Container(
                      padding: EdgeInsets.all(2.0),
                      color: LayoutColor.primaryColor,
                      child: IconButton(
                        color: Colors.white,
                        icon: Icon(Icons.photo_camera),
                        onPressed: _image == ""
                            ? () async {
                                setState(() {
                                  _isLoadingImage = true;
                                });
                                await blocProduto.takePicture().then((url) {
                                  setState(() {
                                    _image = url;
                                    _isLoadingImage = false;
                                  });
                                });
                              }
                            : () {},
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      padding: EdgeInsets.all(2.0),
                      color: LayoutColor.primaryColor,
                      child: IconButton(
                        color: Colors.white,
                        icon: Icon(Icons.image),
                        onPressed: _image == ""
                            ? () async {
                                setState(() {
                                  _isLoadingImage = true;
                                });
                                await blocProduto
                                    .selectFromGallery()
                                    .then((url) {
                                  setState(() {
                                    _image = url;
                                    _isLoadingImage = false;
                                  });
                                });
                              }
                            : () {},
                      ),
                    ),
                  ]),
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
                            controller: blocProduto.nomeController,
                            validator: (_value) {
                              if (_value == "") {
                                return null;
                              } else {
                                if (_value == produto.nome) {
                                  return "O valor digitado é o mesmo já cadastrado!";
                                } else {
                                  return blocProduto.validateNome(_value);
                                }
                              }
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
                          controller: blocProduto.descricaoController,
                          validator: (_value) {
                            if (_value == "") {
                              return null;
                            } else {
                              if (blocProduto.descricaoController.text ==
                                  produto.descricao) {
                                return "O valor digitado é o mesmo já cadastrado!";
                              } else {
                                return blocProduto.validateDescricao(_value);
                              }
                            }
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
                                  produto.preco
                                      .toStringAsFixed(2)
                                      .replaceAll(".", ","),
                          controller:
                              _editPrice ? blocProduto.precoController : null,
                          validator: (_value) {
                            if (blocProduto.precoController.numberValue == 0) {
                              return null;
                            } else {
                              if (blocProduto.precoController.numberValue ==
                                  produto.preco) {
                                return "O valor digitado é o mesmo já cadastrado!";
                              } else {
                                String response =
                                    blocProduto.validatePreco(_value);
                                return response;
                              }
                            }
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
                              : produto.estoque.toStringAsFixed(0),
                          controller: _editEstoque
                              ? blocProduto.estoqueController
                              : null,
                          validator: (_value) {
                            if (_value == "") {
                              return null;
                            } else {
                              if (_value == produto.estoque.toString()) {
                                return "O valor digitado é o mesmo já cadastrado!";
                              } else {
                                String response =
                                    blocProduto.validateEstoque(_value);
                                return response;
                              }
                            }
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

                          /// VALIDAÇÕES
                          onPressed: _onClickUpdateProduct,
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
      ),
    );
  }

  void _onClickUpdateProduct() async {
    String _img;
    if (_formKey.currentState.validate() &&
        !blocProduto.checkUpdateInputs(_estoqueDoNotChanged, produto, _image)) {
      try {
        _image != "" ? _img = _image : _img = produto.foto;
        await blocProduto.atualizarProduto(produto.id, produto.categoria, _img);
        push(context, ListaProdutos(), replace: true);
      } catch (e) {
        _image = "";
        blocProduto.clearAll();
        await ExceptionManager.catchUpdateError(e);
        _showSnackBar(
            "Erro ao cadastrar produto, tente novamente!", Colors.redAccent);
        return;
      }
    } else {
      _image = "";
      blocProduto.clearAll();
      _showSnackBar(
          "Erro ao cadastrar produto, tente novamente!", Colors.redAccent);
    }
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
