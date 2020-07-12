import 'package:flutter/material.dart';
import 'package:obaratao/blocs/bloc_produto.dart';
import 'package:obaratao/models/produtoDados.dart';
import 'package:obaratao/utils/messages.dart';
import 'package:obaratao/utils/nav.dart';
import 'package:obaratao/widgets/cus_text_field.dart';
import 'package:obaratao/widgets/layout_color.dart';

import 'lista_produtos.dart';

class ProdutoCadastro extends StatefulWidget {
  @override
  _ProdutoCadastroState createState() => _ProdutoCadastroState();
}

class _ProdutoCadastroState extends State<ProdutoCadastro> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var productBloc = BlocProduto();
  bool _isLoading = false; //bool para acionar o circular progresss indicator
  bool _isLoadingImage = false;
  ProdutoDados _produtoDados = ProdutoDados();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  padding: EdgeInsets.all(2.0),
                  color: LayoutColor.primaryColor,
                  child: _isLoadingImage
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : IconButton(
                          color: Colors.white,
                          icon: Icon(Icons.photo_camera),
                          onPressed: () async {
                            _isLoadingImage = true;
                            await productBloc.loadImage();
                            _isLoadingImage = false;
                          },
                        ),
                ),
                SizedBox(
                  height: 15,
                ),
                CusTextField(
                  controller: productBloc.nomeController,
                  labelText: "Nome do Produto",
                  hint: "Ex: Cerveja Brahma 350ml Lata",
                  validator: (_value) {
                    _value == null ? "Coloque o nome do produto" : null;
                  },
                ),
                SizedBox(
                  height: 15,
                ),
                CusTextField(
                  controller: productBloc.descricaoController,
                  labelText: "Descrição do Produto",
                  hint: "Ex: Cerveja Pilsen",
                  validator: (_value) {
                    _value.contains(new RegExp(r'[@#^?"{}|]'))
                        ? "Não coloque caracteres especiais"
                        : null;
                  },
                ),
                SizedBox(
                  height: 15,
                ),
                CusTextField(
                  controller: productBloc.precoController,
                  keyboardType: TextInputType.number,
                  labelText: "Preço do Produto",
                  validator: (_value) {
                    productBloc.precoController.numberValue > 0
                        ? "Coloque o preço do produto"
                        : null;
                  },
                ),
                SizedBox(
                  height: 15,
                ),
                CusTextField(
                  controller: productBloc.estoqueController,
                  keyboardType: TextInputType.number,
                  labelText: "Quantidade em Estoque",
                  hint: "Ex: 100",
                  validator: (_value) {
                    _value == null ? "Coloque a quantidade em estoque" : null;
                  },
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  "Selecione a categoria",
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
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
                                productBloc.categoriaController.text = ctgry;
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4.0)),
                                border: Border.all(
                                  color: ctgry ==
                                          productBloc.categoriaController.text
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
                        onPressed: () async {
                          if (_formKey.currentState.validate() &&
                              productBloc.fotoController.text != "") {
                            _isLoading = true;
                            await productBloc.cadastrarProduto();
                            _isLoading = false;
                            BarataoUtils.showMessage(
                                "Produto cadastrado com sucesso!", context);
                          } else {
                            BarataoUtils.showMessage(
                                "Adicione a foto do produto", context);
                          }
                        },
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
    );
  }
}
