import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class LoginWidget extends StatelessWidget {
  LoginWidget(this.emailController, this.passwordController, this.submit);
  final TextEditingController emailController;
  final TextEditingController passwordController;

  final Function() submit;

  final String assetName = 'assets/uwhvz-logo.svg';
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Padding(
            padding: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 50.0),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Visibility(
                    visible: MediaQuery.of(context).orientation == Orientation.portrait,
                    child: Expanded(
                      flex: 3,
                      child: Hero(
                        tag: "logo",
                        child: SvgPicture.asset(
                          assetName,
                          semanticsLabel: 'HvZ Logo',
                        )
                      )
                    )
                  ),
                  Expanded(
                    flex: 5,
                    child: Container(
                        margin: EdgeInsets.only(top: 20.0),
                        child: Column (
                            children: <Widget>[
                              TextField(
                                  controller: emailController,
                                  decoration: InputDecoration(
                                      fillColor: Color.fromRGBO(0, 0, 0, 0),
                                      labelText: 'Email'
                                  )
                              ),
                              TextField(
                                controller: passwordController,
                                obscureText: true,
                                decoration: InputDecoration(
                                    labelText: 'Password'
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 20.0),
                                child: RaisedButton(
                                  onPressed: () => submit(),
                                  child: Text('Login'),
                                ),
                              )
                            ]
                        )
                    ),
                  )
                ]
            )
        )
    );
  }
}