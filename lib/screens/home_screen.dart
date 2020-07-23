import 'package:flutter/material.dart';
import 'package:obaratao/models/user_model.dart';
import 'package:obaratao/utils/nav.dart';
import 'package:obaratao/views/atualizar_produto/atualizar_produto.dart';
import 'package:obaratao/views/atualizar_produto/lista_produtos.dart';
import 'package:obaratao/views/cadastro_produtos/produto_cadastro.dart';
import 'package:obaratao/views/lista_pedidos/lista_pedidos.dart';
import 'package:obaratao/views/login/loginpage.dart';
import 'package:obaratao/widgets/layout_color.dart';
import 'package:scoped_model/scoped_model.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height / 2.5,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/initialpage.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Text(
              'Bem vindo!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30.0,
              ),
            ),
            SizedBox(height: 10.0),
            ListTile(
              title: Text("Seus produtos cadastrados"),
              trailing: SizedBox(
                width: 42.0,
                height: 32.0,
                child: MaterialButton(
                  color: Colors.yellow,
                  padding: EdgeInsets.zero,
                  minWidth: double.infinity,
                  onPressed: () => push(context, ListaProdutos()),
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      color: Colors.black,
                    ),
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: Icon(Icons.arrow_forward_ios),
                ),
              ),
            ),
            ListTile(
              title: Text("Logout"),
              trailing: SizedBox(
                width: 42.0,
                height: 32.0,
                child: MaterialButton(
                  color: Colors.yellow,
                  padding: EdgeInsets.zero,
                  minWidth: double.infinity,
                  onPressed: () async {
                    await UserModel.of(context).signOut();
                    push(context, LoginPage(), replace: true);
                  },
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      color: Colors.black,
                    ),
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: Icon(Icons.exit_to_app),
                ),
              ),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text("Lista de Pedidos"),
        centerTitle: true,
        backgroundColor: LayoutColor.secondaryColor,
      ),
      body: ListPedidos(),
    );
  }
}
