import 'package:ecommerce_fyp/Admin/AdminHomeScreen.dart';
import 'package:ecommerce_fyp/Authentication/RegisterScreen.dart';
import 'package:ecommerce_fyp/User/UserHomeScreen.dart';
import 'package:ecommerce_fyp/Utils.dart';
import 'package:firebase_auth/firebase_auth.dart'
    show FirebaseAuth, FirebaseAuthException, UserCredential;
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../ShopKeeper/Screens/ShopKeeperHomeScreen.dart';

class Login extends StatefulWidget {
  final String type;

  Login(this.type);

  @override
  _LoginState createState() => _LoginState(type);
}

class _LoginState extends State<Login> {
  String type;
  TextEditingController code = new TextEditingController();
  TextEditingController email = new TextEditingController();
  TextEditingController password = new TextEditingController();


  _LoginState(this.type);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Builder(
        builder: (context) {
          return Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/background.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              margin: const EdgeInsets.fromLTRB(30, 50, 30, 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Login As $type',
                    style: TextStyle(
                        fontSize: 25,
                        color: Colors.amber,
                        fontWeight: FontWeight.bold),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Email',
                        style: TextStyle(fontSize: 15, color: Colors.black),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextField(
                        controller: email,
                        cursorColor: Colors.amber,
                        keyboardType: TextInputType.emailAddress,
                        decoration: new InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(40.0),
                                borderSide: BorderSide(color: Color(0xf6f7fb))),
                            contentPadding:
                                const EdgeInsets.fromLTRB(25, 15, 25, 15),
                            isDense: true,
                            focusedBorder: OutlineInputBorder(
                                borderRadius: const BorderRadius.all(
                                  const Radius.circular(40.0),
                                ),
                                borderSide: BorderSide(color: Color(0xf6f7fb))),
                            border: new OutlineInputBorder(
                              borderRadius: const BorderRadius.all(
                                const Radius.circular(40.0),
                              ),
                            ),
                            filled: true,
                            fillColor: Colors.grey[200]),
                      ),
                      SizedBox(
                        height: 25.0,
                      ),
                      Text(
                        'Password',
                        style: TextStyle(fontSize: 15, color: Colors.black),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextField(
                        controller: password,
                        cursorColor: Colors.amber,
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: true,
                        decoration: new InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(40.0),
                                borderSide: BorderSide(color: Color(0xf6f7fb))),
                            contentPadding:
                                const EdgeInsets.fromLTRB(25, 15, 25, 15),
                            isDense: true,
                            focusedBorder: OutlineInputBorder(
                                borderRadius: const BorderRadius.all(
                                  const Radius.circular(40.0),
                                ),
                                borderSide: BorderSide(color: Color(0xf6f7fb))),
                            border: new OutlineInputBorder(
                              borderRadius: const BorderRadius.all(
                                const Radius.circular(40.0),
                              ),
                            ),
                            filled: true,
                            fillColor: Colors.grey[200]),
                      ),

                      /*         SizedBox(
                        height: 25.0,
                      ),


                      Align(
                        alignment: Alignment.topRight,
                        child: GestureDetector(
                            onTap: () {
*/ /*
                              Navigator.pushReplacement(context,
                                  MaterialPageRoute(builder: (context) => Forget()));
*/ /*
                            },
                            child: Text(
                              "Forget Password?",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.amber,
                              ),
                            )
                        ),
                      ),*/
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      ButtonTheme(
                        minWidth: MediaQuery.of(context).size.width,
                        height: 45.0,
                        child: RaisedButton(
                          onPressed: () {
                            if (!validation(context)) return;
                            login(context,type,email.text.toString(),password.text.toString());
                          },
                          color: Colors.amber,
                          child: Text(
                            'Confirm',
                            style:
                                TextStyle(color: Colors.white, fontSize: 18.0),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      (type == "Admin")
                          ? Container()
                          : Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    'Don\'t have an account?  ',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  GestureDetector(
                                      onTap: () {
                                        if (type == 'User') {
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      Register('User')));
                                        } else if (type == 'Shopkeeper') {
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      Register('Shopkeeper')));
                                        }
                                      },
                                      child: Text(
                                        "SignUp",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.amber,
                                        ),
                                      )),
                                ],
                              ),
                            ),
                    ],
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  bool validation(BuildContext context) {
    if (email.text.trim().isEmpty) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text("Email is Required"),
      ));
      return false;
    }

    if (!RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email.text.trim())) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text("Email is not Valid"),
      ));
      return false;
    }

    if (password.text.trim().isEmpty) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text("Password is Required"),
      ));
      return false;
    }

    return true;
  }

  void login(BuildContext context,String type,String email,String password) async {
    Utils.loader(context);
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: email, password: password);

      DatabaseReference databaseReference = FirebaseDatabase.instance
          .reference()
          .child(type.toLowerCase())
          .child(userCredential.user.uid);
      await databaseReference.once().then((DataSnapshot snapshot) {
        Navigator.pop(context);

        if(snapshot.value != null){
          saveSession(type.toLowerCase(),email, password);

          if (type.toLowerCase() == 'admin') {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => AdminHome()),
                ModalRoute.withName("/Admin"));
          } else if (type.toLowerCase() == 'shopkeeper') {
            if (snapshot.value['active'] == 1) {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => ShopKeeperHome()),
                  ModalRoute.withName("/Shopkeeper"));
            } else {
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text('Shopkeeper is not active'),
              ));
            }
          } else if (type.toLowerCase() == 'user') {
            if (snapshot.value['active'] == 1) {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => UserHome(
                          snapshot.value['name'],
                          snapshot.value['email'],
                          snapshot.value['phone'],
                          snapshot.value['address'])),
                  ModalRoute.withName("/User"));
            } else {
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text('User is not active'),
              ));
            }
          }
        }else{
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text('user-not-found'),
          ));
        }


      });
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      if (e.code == 'wrong-password') {
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text(e.code),
        ));
      } else if (e.code == 'user-not-found') {
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text(e.code),
        ));
      }
    }
  }


  void saveSession(String type,String email,String password)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('type', type);
    await prefs.setString('email', email);
    await prefs.setString('password', password);
  }
}
