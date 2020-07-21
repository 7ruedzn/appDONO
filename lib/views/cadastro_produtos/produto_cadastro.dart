import 'package:flutter/material.dart';
import 'package:obaratao/blocs/bloc_produto.dart';
import 'package:obaratao/models/produtoDados.dart';
import 'package:obaratao/utils/messages.dart';
import 'package:obaratao/widgets/cus_text_form_field.dart';
import 'package:obaratao/widgets/layout_color.dart';

class ProdutoCadastro extends StatefulWidget {
  @override
  _ProdutoCadastroState createState() => _ProdutoCadastroState();
}

class _ProdutoCadastroState extends State<ProdutoCadastro> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
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
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Cadastre seu produto"),
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
                Text(
                  "Tire a foto do seu produto:",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 15,
                ),
                StreamBuilder(
                    stream: productBloc.outFoto,
                    builder: (context, AsyncSnapshot<String> snapshot) {
                      return Container(
                        height: size.height / 4,
                        width: size.width / 2,
                        child: snapshot.connectionState ==
                                    ConnectionState.waiting &&
                                _isLoadingImage == true
                            ? Center(
                                child: CircularProgressIndicator(),
                              )
                            : snapshot.data != null
                                ? Image.network(
                                    snapshot.data,
                                    fit: BoxFit.fill,
                                  )
                                : Container(),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.blueGrey,
                            border: Border(
                              top: BorderSide(color: Colors.black),
                              left: BorderSide(color: Colors.black),
                              right: BorderSide(color: Colors.black),
                              bottom: BorderSide(color: Colors.black),
                            )),
                      );
                    }),
                SizedBox(
                  height: 10,
                ),
                Container(
                  padding: EdgeInsets.all(2.0),
                  color: LayoutColor.primaryColor,
                  child: IconButton(
                    color: Colors.white,
                    icon: Icon(Icons.photo_camera),
                    onPressed: () async {
                      setState(() {
                        _isLoadingImage = true;
                      });
                      await productBloc.loadImage();
                    },
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                CusTextFormField(
                  labelText: "Nome do Produto",
                  controller: productBloc.nomeController,
                  validator: (_value) {
                    _value == null ? "Coloque o nome do produto" : null;
                  },
                  keyboardType: TextInputType.text,
                  hintText: "Ex: Cerveja Brahma 350ml Lata",
                ),
                SizedBox(
                  height: 15,
                ),
                CusTextFormField(
                  labelText: "Descrição do Produto",
                  controller: productBloc.descricaoController,
                  validator: (_value) {
                    _value.contains(new RegExp(r'[@#^?"{}|]'))
                        ? "Não coloque caracteres especiais"
                        : null;
                  },
                  keyboardType: TextInputType.text,
                  hintText: "Ex: Cerveja Pilsen",
                ),
                SizedBox(
                  height: 15,
                ),
                CusTextFormField(
                  labelText: "Preço do Produto",
                  controller: productBloc.precoController,
                  validator: (_value) {
                    productBloc.precoController.numberValue + 0.0 > 0
                        ? "Coloque o preço do produto"
                        : null;
                  },
                  keyboardType: TextInputType.number,
                ),
                SizedBox(
                  height: 15,
                ),
                CusTextFormField(
                  labelText: "Quantidade em Estoque",
                  controller: productBloc.estoqueController,
                  validator: (_value) {
                    _value == null ? "Coloque a quantidade em estoque" : null;
                  },
                  keyboardType: TextInputType.number,
                  hintText: "Ex: 100",
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
                          try {
                            if (_formKey.currentState.validate() &&
                                productBloc.fotoController.text != "") {
                              _isLoading = true;
                              await productBloc.cadastrarProduto();
                              _isLoading = false;
                              productBloc.fotoController = null;
                              BarataoUtils.showMessage(
                                  "Produto cadastrado com sucesso!", context);
                            } else {
                              BarataoUtils.showMessage(
                                  "Adicione a foto do produto", context);
                            }
                          } catch (e) {
                            _onFail();
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

  void _onFail() {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(
        "Falha ao cadastrar o produto, tente novamente",
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
