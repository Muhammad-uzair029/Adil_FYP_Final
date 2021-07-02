import 'package:ecommerce_fyp/Authentication/LoginScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPassword extends StatelessWidget {
  static String id = 'forgot-password';
  TextEditingController _textEditingController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent,
      body: Form(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Email Your Email',
                style: TextStyle(fontSize: 30, color: Colors.white),
              ),
              TextFormField(
                controller: _textEditingController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Email',
                  icon: Icon(
                    Icons.mail,
                    color: Colors.white,
                  ),
                  errorStyle: TextStyle(color: Colors.white),
                  labelStyle: TextStyle(color: Colors.white),
                  hintStyle: TextStyle(color: Colors.white),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  errorBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
              ),
              SizedBox(height: 20),
              RaisedButton(
                child: Text('Send Email'),
                onPressed: () {
                  resetPassword(_textEditingController.text);
                  Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text("Check your Email Please"),
                  ));
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                child: Text('Sign In'),
                onPressed: () {},
              )
            ],
          ),
        ),
      ),
    );
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Future<void> resetPassword(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }
}
