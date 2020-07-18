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
    return Scaffold(
      appBar: AppBar(
        title: Text('Atualizar Produto'),
        centerTitle: true,
        backgroundColor: LayoutColor.secondaryColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Container(
                  height: 200,
                  width: 200,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.blue,
                      image: _isLoadingImage
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : DecorationImage(
                              image: NetworkImage(produto.foto),
                              fit: BoxFit.fill,
                            )),
                ),
                SizedBox(height: 20.0),
                Container(
                  padding: EdgeInsets.all(5.0),
                  color: LayoutColor.primaryColor,
                  child: IconButton(
                    color: Colors.amber,
                    icon: Icon(Icons.photo_camera),
                    //tentar att a pagina quando tirar a foto;
                    onPressed: () async {
                      _isLoadingImage = true;
                      await productBloc.loadImage();
                      _isLoadingImage = false;
                    },
                  ),
                ),
                SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Nome:"),
                    Container(
                      height: 40,
                      width: 200,
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
                    Container(
                      height: 60,
                      width: 35,
                      color: Colors.red,
                      child: IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            setState(() {
                              _editName = !_editName;
                            });
                          }),
                    ),
                  ],
                ),
                SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Descrição:"),
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
                    Container(
                      height: 60,
                      width: 35,
                      color: Colors.red,
                      child: IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            setState(() {
                              _editDescription = !_editDescription;
                            });
                          }),
                    ),
                  ],
                ),
                SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Preço:"),
                    Container(
                      height: 40,
                      width: 200,
                      child: CusTextFormField( 
                        labelText: _editPrice ? "" : 'R\$ ' + produto.preco.toString().replaceAll(".", ","),
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
                    Container(
                      height: 60,
                      width: 35,
                      color: Colors.red,
                      child: IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            setState(() {
                              _editPrice = !_editPrice;
                            });
                          }),
                    ),
                  ],
                ),
                SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Estoque:"),
                    Container(
                      height: 40,
                      width: 200,
                      child: CusTextFormField( 
                        labelText: _editEstoque ? "" : produto.estoque.toString().replaceAll(".", ","),
                        controller: _editEstoque ? productBloc.estoqueController : null,
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
                    Container(
                      height: 60,
                      width: 35,
                      color: Colors.red,
                      child: IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            setState(() {
                              _estoqueDoNotChanged = !_estoqueDoNotChanged;
                              _editEstoque = !_editEstoque;
                            });
                          }),
                    ),
                  ],
                ),
                SizedBox(height: 20.0),
                FlatButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0)),
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      _checkInputs();
                      await productBloc.atualizarProduto(
                          produto.id, produto.categoria);
                          push(context, ListaProdutos(), replace: true);
                    }
                  },
                  color: LayoutColor.primaryColor,
                  child: Text(
                    "Atualizar Produto",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25.0,
                    ),
                  ),
                ),
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
}
