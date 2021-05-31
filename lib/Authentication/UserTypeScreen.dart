
import 'dart:async';

import 'package:ecommerce_fyp/Admin/AdminHomeScreen.dart';
import 'package:ecommerce_fyp/ShopKeeper/Screens/ShopKeeperHomeScreen.dart';
import 'package:ecommerce_fyp/User/UserHomeScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Utils.dart';
import 'LoginScreen.dart';


class UserType extends StatefulWidget {
  @override
  _UserTypeState createState() => _UserTypeState();
}

class _UserTypeState extends State<UserType> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(Duration(milliseconds: 300), () {
      checkSession();
    });
  }

  void checkSession() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String type = prefs.getString("type");
    String email = prefs.getString("email");
    String password = prefs.getString("password");

    print(type+" "+email+" "+password);
    if(type != null){
      login(type, email, password);
    }

  }

  void login(String type,String email,String password) async {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Builder(
        builder: (context){
          return Container(
            width: MediaQuery
                .of(context)
                .size
                .width,
            height: MediaQuery
                .of(context)
                .size
                .height,

            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/background.png"),
                fit: BoxFit.cover,
              ),
            ),

            child: Column(

              mainAxisAlignment: MainAxisAlignment.center,
              children: [


                SizedBox(
                  height: 100.0,
                  width: 100.0,
                  child: Image.asset("assets/logo.png"),
                ),


                Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
                  child: Text("E-COMMERCE",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15.0,
                    ),),
                ),

                Text("        FIREBASE",
                  style: TextStyle(
                      color: Colors.amber,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold
                  ),),


                Padding(
                  padding: const EdgeInsets.fromLTRB(40.0, 150.0, 40.0, 0.0),
                  child: SizedBox(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                    height: 45.0,
                    child: RaisedButton(

                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => Login("Admin")));
                      },

                      color: Colors.amber,

                      child: Text(
                        'Login as Admin',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.0
                        ),
                      ),

                      shape: RoundedRectangleBorder(

                        borderRadius: BorderRadius.circular(30.0),

                      ),
                    ),
                  ),
                ),



                Padding(
                  padding: const EdgeInsets.fromLTRB(40.0, 20.0, 40.0, 0.0),
                  child: SizedBox(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                    height: 45.0,
                    child: RaisedButton(

                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => Login("Shopkeeper")));
                      },

                      color: Colors.blue,

                      child: Text(
                        'Login as ShopKeeper',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.0
                        ),
                      ),

                      shape: RoundedRectangleBorder(

                        borderRadius: BorderRadius.circular(30.0),

                      ),
                    ),
                  ),
                ),



                Padding(
                  padding: const EdgeInsets.fromLTRB(40.0, 20.0, 40.0, 0.0),
                  child: SizedBox(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                    height: 45.0,
                    child: RaisedButton(

                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => Login("User")));
                      },

                      color: Colors.black,

                      child: Text(
                        'Login as User',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.0
                        ),
                      ),

                      shape: RoundedRectangleBorder(

                        borderRadius: BorderRadius.circular(30.0),

                      ),
                    ),
                  ),
                ),

              ],
            ),
          );
        },
      ),
    );
  }
}
