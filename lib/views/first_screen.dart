import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';

class FirstScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Icon(
                Icons.casino,
                size: 150.0,
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                children: <Widget>[
                  LoginTextField(
                    label: 'Username',
                  ),
                  LoginTextField(
                    label: 'Password',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LoginTextField extends StatelessWidget {
  final label;
  LoginTextField({this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 50.0, right: 50.0, bottom: 10.0),
      child: TextField(
        obscureText: true,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          labelStyle: TextStyle(
            color: Colors.red,
          ),
          fillColor: Colors.red,
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.red,
            ),
            borderRadius: BorderRadius.circular(10.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.red,
            ),
            borderRadius: BorderRadius.circular(10.0),
          ),
          labelText: label,
        ),
      ),
    );
  }
}
