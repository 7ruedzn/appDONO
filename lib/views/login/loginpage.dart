import 'package:obaratao/animation/FadeAnimation.dart';
import 'package:flutter/material.dart';
import 'package:obaratao/models/user_model.dart';
import 'package:obaratao/screens/home_screen.dart';
import 'package:obaratao/utils/nav.dart';
import 'package:obaratao/widgets/cus_text_form_field.dart';
import 'package:scoped_model/scoped_model.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final _tUser = TextEditingController();

  final _tSenha = TextEditingController();

  final _focusSenha = FocusNode();

  bool _notSeePass = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
      ),
      body: ScopedModelDescendant<UserModel>(builder: (context, child, model) {
        return SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            FadeAnimation(
                                1,
                                Text(
                                  'Login',
                                  style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )),
                            SizedBox(
                              height: 20,
                            ),
                            FadeAnimation(
                                1.2,
                                Text(
                                  'Faça login em sua conta',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.grey[700],
                                  ),
                                )),
                            SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 40.0),
                          child: Column(
                            children: <Widget>[
                              FadeAnimation(
                                  1.4,
                                  CusTextFormField(
                                    labelText: "Email",
                                    hintText: "Ex: seuemail@exemplo.com",
                                    controller: _tUser,
                                    validator: _validateUser,
                                    keyboardType: TextInputType.emailAddress,
                                    textInputAction: TextInputAction.next,
                                    nextFocus: _focusSenha,
                                  )),
                              SizedBox(
                                height: 30,
                              ),
                              FadeAnimation(
                                  1.5,
                                  Column(children: [
                                    CusTextFormField(
                                      labelText: "Senha",
                                      controller: _tSenha,
                                      validator: _validateSenha,
                                      keyboardType:
                                          TextInputType.visiblePassword,
                                      obscureText: _notSeePass,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Align(
                                      child: IconButton(
                                        icon: Icon(_notSeePass
                                            ? Icons.remove_red_eye
                                            : Icons.visibility_off),
                                        onPressed: () {
                                          setState(() {
                                            _notSeePass = !_notSeePass;
                                          });
                                        },
                                      ),
                                    )
                                  ])),
                              SizedBox(
                                height: 30,
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 40),
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
                            child: FadeAnimation(
                                1.6,
                                MaterialButton(
                                  minWidth: double.infinity,
                                  height: 60.0,
                                  onPressed: () {
                                    _onClickLogin(model);
                                  },
                                  color: Colors.yellow,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: Text(
                                    'Login',
                                    style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                )),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {},
                          child:
                              FadeAnimation(1.7, Text('Esqueceu sua senha?')),
                        ),
                        FadeAnimation(
                            1.8,
                            Container(
                              height: MediaQuery.of(context).size.height / 2.5,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(
                                      'assets/images/initialpage.png'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Future<void> _onClickLogin(UserModel model) async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    model.signIn(
      email: _tUser.text,
      pass: _tSenha.text,
      onSucess: _onSucess,
      onFail: _onFail,
    );
  }

  String _validateUser(String text) {
    if (text.isEmpty) {
      return "Digite o login";
    }
    return null;
  }

  String _validateSenha(String text) {
    if (text.isEmpty) {
      return "Digite a senha";
    }
    if (text.length < 3) {
      return "A senha precisa ter pelo menos 3 números";
    }
    return null;
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onSucess() {
    push(context, HomeScreen(), replace: true);
  }

  void _onFail() {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text("Falha ao fazer login"),
      backgroundColor: Colors.redAccent,
      duration: Duration(seconds: 2),
    ));
  }
}
