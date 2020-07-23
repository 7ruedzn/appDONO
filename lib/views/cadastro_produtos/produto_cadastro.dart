import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:obaratao/blocs/bloc_produto.dart';
import 'package:obaratao/models/exceptionManager.dart';
import 'package:obaratao/models/produtoDados.dart';
import 'package:obaratao/utils/messages.dart';
import 'package:obaratao/utils/nav.dart';
import 'package:obaratao/views/atualizar_produto/lista_produtos.dart';
import 'package:obaratao/widgets/cus_text_form_field.dart';
import 'package:obaratao/widgets/layout_color.dart';
import 'package:toast/toast.dart';

class ProdutoCadastro extends StatefulWidget {
  @override
  _ProdutoCadastroState createState() => _ProdutoCadastroState();
}

class _ProdutoCadastroState extends State<ProdutoCadastro> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  BlocProduto blocProduto = BlocProduto();
  bool _isLoading = false; //bool para acionar o circular progresss indicator
  bool _isLoadingImage = false;
  ProdutoDados _produtoDados = ProdutoDados();
  String _image = "";

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return new WillPopScope(
      onWillPop: () async => false, // bloqueia o retorno, exceto pelo icone
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                push(context, ListaProdutos());
              }),
          title: Text("Cadastre seu produto"),
          centerTitle: true,
          backgroundColor: LayoutColor.secondaryColor,
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.rotate_left),
                onPressed: () {
                  Navigator.pop(context);
                  push(context, ProdutoCadastro());
                  Toast.show("Página recarregada!", context,
                      duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
                })
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Text(
                    "Tire a foto do seu produto:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 15,
                  ),
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
                            : Text(
                                "Nenhuma imagem\n selecionada",
                                textAlign: TextAlign.center,
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
                  SizedBox(
                    height: 15,
                  ),
                  CusTextFormField(
                    labelText: "Nome do Produto",
                    controller: blocProduto.nomeController,
                    validator: blocProduto.validateNome,
                    keyboardType: TextInputType.text,
                    hintText: "Ex: Cerveja Brahma 350ml Lata",
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  CusTextFormField(
                    labelText: "Descrição do Produto",
                    controller: blocProduto.descricaoController,
                    validator: blocProduto.validateDescricao,
                    keyboardType: TextInputType.text,
                    hintText: "Ex: Cerveja Pilsen",
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  CusTextFormField(
                    labelText: "Preço do Produto",
                    controller: blocProduto.precoController,
                    textInputFormatter: <TextInputFormatter>[
                      WhitelistingTextInputFormatter.digitsOnly
                    ],
                    validator: blocProduto.validatePreco,
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  CusTextFormField(
                    labelText: "Quantidade em Estoque",
                    controller: blocProduto.estoqueController,
                    textInputFormatter: <TextInputFormatter>[
                      WhitelistingTextInputFormatter.digitsOnly
                    ],
                    validator: blocProduto.validateEstoque,
                    keyboardType: TextInputType.number,
                    hintText: "Ex: 100",
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    "Selecione a categoria",
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 36.0,
                    child: GridView(
                      padding: EdgeInsets.symmetric(vertical: 4.0),
                      scrollDirection: Axis.horizontal,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 1,
                          mainAxisSpacing: 8.0,
                          childAspectRatio: 0.34),
                      children: _produtoDados.categorias
                          .map(
                            (String ctgry) => GestureDetector(
                              onTap: () {
                                setState(() {
                                  blocProduto.categoriaController.text = ctgry;
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4.0)),
                                  border: Border.all(
                                    color: ctgry ==
                                            blocProduto.categoriaController.text
                                        ? LayoutColor.primaryColor
                                        : Colors.grey[500],
                                    width: 3.0,
                                  ),
                                ),
                                width: 50.0,
                                alignment: Alignment.center,
                                child: Text(
                                  ctgry,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  _isLoading
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : FlatButton(
                          onPressed: _onClickCadastrateProduct,
                          color: LayoutColor.primaryColor,
                          child: Text(
                            "Cadastrar produtos",
                            style: TextStyle(color: Colors.white),
                          )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onClickCadastrateProduct() async {
    if (_formKey.currentState.validate()) {
      if (blocProduto.categoriaController.text == null ||
          blocProduto.categoriaController.text == "") {
        _showSnackBar(
            "Erro ao cadastrar produto, tente novamente!", Colors.redAccent);
      } else {
        if (_image != "") {
          try {
            setState(() {
              _isLoading = true;
            });

            await blocProduto.cadastrarProduto(_image);
            setState(() {
              _isLoading = false;
              _image = "";
            });
            _showSnackBar(
                "Produto cadastrado com sucesso!", LayoutColor.primaryColor);
          } catch (e) {
            ExceptionManager.catchUpdateError(e);
            _showSnackBar("Erro ao cadastrar produto, tente novamente!",
                Colors.redAccent);
          }
        } else {
          _showSnackBar("Adicione a foto do produto", Colors.redAccent);
        }
      }
    } else {
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
