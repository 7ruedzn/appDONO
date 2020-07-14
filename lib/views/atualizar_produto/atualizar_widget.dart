import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:obaratao/blocs/bloc_produto.dart';
import 'package:obaratao/models/produtoDados.dart';
import 'package:obaratao/utils/messages.dart';
import 'package:obaratao/widgets/cus_text_field.dart';
import 'package:obaratao/widgets/layout_color.dart';

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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Atualizar Produto'),
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
                    image: _isLoadingImage ? 
                    Center(
                      child: CircularProgressIndicator(),
                    ) : DecorationImage(
                      image: NetworkImage(produto.foto),
                      fit: BoxFit.fill,
                    )
                  ),
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
                CusTextField(
                  controller: productBloc.nomeController,
                  labelText: "Alterar Nome do Produto",
                  hint: "Ex: Pão Francês -> Pão de Forma",
                  validator: (_value) {
                    _value == null ? "Coloque o nome do produto" : null;
                  },
                ),
                SizedBox(height: 20.0),
                CusTextField(
                  controller: productBloc.descricaoController,
                  labelText: "Alterar Descrição do Produto",
                  hint: "Ex: Cerveja Pilsen",
                  validator: (_value) {
                    _value.contains(new RegExp(r'[@#^?"{}|]'))
                        ? "Não coloque caracteres especiais"
                        : null;
                  },
                ),
                SizedBox(height: 20.0),
                CusTextField(
                  controller: productBloc.precoController,
                  keyboardType: TextInputType.number,
                  labelText: "Alterar Preço do Produto",
                  validator: (_value) {
                    productBloc.precoController.numberValue > 0
                        ? "Coloque o preço do produto"
                        : null;
                  },
                ),
                SizedBox(height: 20.0),
                CusTextField(
                  controller: productBloc.estoqueController,
                  keyboardType: TextInputType.number,
                  labelText: "Quantidade em Estoque",
                  hint: "Ex: 100",
                  validator: (_value) {
                    _value == null ? "Coloque a quantidade em estoque" : null;
                  },
                ),
                SizedBox(height: 20.0),
                FlatButton(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                  onPressed: () async {
                    await productBloc.atualizarProduto();
                    productBloc.updateToFirestore(produto.id);
                    //Erro context fora do Scaffold;
                    //BarataoUtils.showMessage('Produto atualizado com sucesso!', context);
                    print('id do produto ${produto.id}');
                    print('categoria do produto ${produto.categoria}');
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
}