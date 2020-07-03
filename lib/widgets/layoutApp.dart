import 'package:flutter/material.dart';
import 'package:obaratao/views/lista_pedidos/pedidos_widget.dart';
import 'layout_color.dart';

class LayoutTeste {
  static String logo =
      'assets/images/LogoOBaratao.png'; //Trocar logo do mercadinho.

  static int currentIndex = 0; //Muda de acordo com a 'aba' selecionada;
  static final abas = [
    //Cada indice é carrega uma page: 0 - home; 1 - Ofertas; 2 - compras.
    PedidosWidget.tag,
    //Produtos.tag,
  ];

  static Scaffold getLayoutTesteContent(BuildContext context, content) {
    BottomNavigationBar homeBottomNavigationBar = BottomNavigationBar(
      currentIndex: currentIndex, //Indice da 'aba' selecionada
      iconSize: 24.0,
      selectedFontSize: 16.0,
      unselectedFontSize: 14.0,
      type: BottomNavigationBarType.fixed,
      items: [
        BottomNavigationBarItem(
          icon: Icon(
            Icons.list,
            color: LayoutColor.primaryColor,
          ),
          title: Text(
            'PEDIDOS',
            style: TextStyle(color: LayoutColor.primaryColor),
          ),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add_circle, color: LayoutColor.primaryColor),
          title: Text(
            'PRODUTOS',
            style: TextStyle(color: LayoutColor.primaryColor),
          ),
        ),
      ],
      onTap: (int i) {
        currentIndex = i;
        Navigator.of(context).pushNamed(abas[i]);
      },
    );

    Widget _logo = Container(
      height: 50,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage(logo), fit: BoxFit.contain),
      ),
    );

    _gestureDetector({onTap, Widget child}) {
      return GestureDetector(
        onTap: onTap,
        child: Padding(padding: const EdgeInsets.all(8.0), child: child),
      );
    }

    List<Widget> _getHomeAction(BuildContext context) {
      List<Widget> items = List<Widget>();
      items.add(_gestureDetector(child: Icon(Icons.search), onTap: () {}));
      return items;
    }

    return Scaffold(
      resizeToAvoidBottomInset: false, //Arruma o erro de overflow do teclado;
      appBar: AppBar(
        title: _logo,
        actions: _getHomeAction(context),
      ),
      body: SafeArea(
        child: content,
      ),
      bottomNavigationBar: homeBottomNavigationBar,
    );
  }
}
