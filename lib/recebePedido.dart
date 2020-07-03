import 'package:flutter/material.dart';

Widget recebePedido({String nome}){
  return Center(
    child: Column(
      children: <Widget>[
        Container(
          width: 150,
          color: Colors.blue,
          child: Text(
            nome,
            style: TextStyle(
              fontSize: 20,
              color: Colors.black,
            ),
          ),
        ),
      ],
    ),
  );
}