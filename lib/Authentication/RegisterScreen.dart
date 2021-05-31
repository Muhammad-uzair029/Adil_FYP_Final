import 'package:ecommerce_fyp/Authentication/LoginScreen.dart';
import 'package:ecommerce_fyp/Utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {

  final String type;

  Register(this.type);

  @override
  _RegisterState createState() => _RegisterState(type);
}

class _RegisterState extends State<Register> {

  TextEditingController name = new TextEditingController();
  TextEditingController email = new TextEditingController();
  TextEditingController password = new TextEditingController();
  TextEditingController phone = new TextEditingController();
  TextEditingController address = new TextEditingController();
  String type;

  _RegisterState(this.type);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,



      body: Builder(
        builder: (context) {
          return Container(


            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/background.png"),
                fit: BoxFit.cover,
              ),
            ),

            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Container(
                margin: const EdgeInsets.fromLTRB(30, 50, 30, 30),
                height: MediaQuery.of(context).size.height,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[


                    Text(
                      'Register',
                      style: TextStyle(
                          fontSize: 25,
                          color: Colors.amber,
                          fontWeight: FontWeight.bold
                      ),
                    ),


                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[


                        SizedBox(height: 30.0,),

                        Text(
                          'Name',
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.black
                          ),
                        ),


                        SizedBox(
                          height: 10,
                        ),


                        TextField(

                          controller: name,

                          cursorColor: Colors.amber,

                          keyboardType: TextInputType.name,

                          decoration: new InputDecoration(

                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(40.0),
                                  borderSide: BorderSide(
                                      color: Color(0xf6f7fb)
                                  )
                              ),
                              contentPadding: const EdgeInsets.fromLTRB(
                                  25, 15, 25, 15),

                              isDense: true,

                              focusedBorder: OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(
                                    const Radius.circular(40.0),
                                  ),
                                  borderSide:
                                  BorderSide(color: Color(0xf6f7fb)
                                  )
                              ),


                              border: new OutlineInputBorder(
                                borderRadius: const BorderRadius.all(
                                  const Radius.circular(40.0),
                                ),
                              ),
                              filled: true,
                              fillColor: Colors.grey[200]
                          ),


                        ),

                        SizedBox(height: 25.0,),

                        Text(
                          'Email',
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.black
                          ),
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
                                  borderSide: BorderSide(
                                      color: Color(0xf6f7fb)
                                  )
                              ),
                              contentPadding: const EdgeInsets.fromLTRB(
                                  25, 15, 25, 15),

                              isDense: true,

                              focusedBorder: OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(
                                    const Radius.circular(40.0),
                                  ),
                                  borderSide:
                                  BorderSide(color: Color(0xf6f7fb)
                                  )
                              ),


                              border: new OutlineInputBorder(
                                borderRadius: const BorderRadius.all(
                                  const Radius.circular(40.0),
                                ),
                              ),
                              filled: true,
                              fillColor: Colors.grey[200]
                          ),


                        ),


                        SizedBox(
                          height: 25.0,
                        ),


                        Text(
                          'Password',
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.black
                          ),
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
                                  borderSide: BorderSide(
                                      color: Color(0xf6f7fb)
                                  )
                              ),
                              contentPadding: const EdgeInsets.fromLTRB(
                                  25, 15, 25, 15),

                              isDense: true,

                              focusedBorder: OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(
                                    const Radius.circular(40.0),
                                  ),
                                  borderSide:
                                  BorderSide(color: Color(0xf6f7fb)
                                  )
                              ),


                              border: new OutlineInputBorder(
                                borderRadius: const BorderRadius.all(
                                  const Radius.circular(40.0),
                                ),
                              ),
                              filled: true,

                              fillColor: Colors.grey[200]
                          ),


                        ),


                        SizedBox(
                          height: 25.0,
                        ),


                        Text(
                          'Phone',
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.black
                          ),
                        ),


                        SizedBox(
                          height: 10,
                        ),


                        TextField(

                          controller: phone,

                          cursorColor: Colors.amber,

                          keyboardType: TextInputType.number,

                          decoration: new InputDecoration(

                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(40.0),
                                  borderSide: BorderSide(
                                      color: Color(0xf6f7fb)
                                  )
                              ),
                              contentPadding: const EdgeInsets.fromLTRB(
                                  25, 15, 25, 15),

                              isDense: true,

                              focusedBorder: OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(
                                    const Radius.circular(40.0),
                                  ),
                                  borderSide:
                                  BorderSide(color: Color(0xf6f7fb)
                                  )
                              ),


                              border: new OutlineInputBorder(
                                borderRadius: const BorderRadius.all(
                                  const Radius.circular(40.0),
                                ),
                              ),
                              filled: true,

                              fillColor: Colors.grey[200]
                          ),


                        ),


                        SizedBox(
                          height: 25.0,
                        ),


                        Text(
                          'Address',
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.black
                          ),
                        ),


                        SizedBox(
                          height: 10,
                        ),


                        TextField(

                          controller: address,

                          cursorColor: Colors.amber,

                          keyboardType: TextInputType.streetAddress,

                          decoration: new InputDecoration(

                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(40.0),
                                  borderSide: BorderSide(
                                      color: Color(0xf6f7fb)
                                  )
                              ),
                              contentPadding: const EdgeInsets.fromLTRB(
                                  25, 15, 25, 15),

                              isDense: true,

                              focusedBorder: OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(
                                    const Radius.circular(40.0),
                                  ),
                                  borderSide:
                                  BorderSide(color: Color(0xf6f7fb)
                                  )
                              ),


                              border: new OutlineInputBorder(
                                borderRadius: const BorderRadius.all(
                                  const Radius.circular(40.0),
                                ),
                              ),
                              filled: true,

                              fillColor: Colors.grey[200]
                          ),


                        ),



                      ],
                    ),


                    SizedBox(
                      height: 30.0,
                    ),

                    Column(

                      children: <Widget>[

                        ButtonTheme(

                          minWidth: MediaQuery
                              .of(context)
                              .size
                              .width,
                          height: 45.0,

                          child: RaisedButton(

                            onPressed: () {
                               if (!validation(context))
                                return;

                              registerUser(context);



                            },

                            color: Colors.amber,

                            child: Text(
                              'Confirm',
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



                      ],

                    )


                  ],
                ),
              ),
            ),
          );
        },
      ),

    );
  }


  void registerUser(BuildContext context) async{
    Utils.loader(context);
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email.text.trim(), password: password.text.trim());

      DatabaseReference databaseReference = FirebaseDatabase.instance.reference().child(type.toLowerCase()).child(userCredential.user.uid);
      await databaseReference.set({
        'name':name.text.trim(),
        'email':email.text.trim(),
        'phone':phone.text.trim(),
        'address':address.text.trim(),
        'active': 1 ,
      });
      Navigator.pop(context);
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => Login(type)));

    }on FirebaseAuthException catch(e){
      Navigator.pop(context);
      print(e.code);
      if(e.code == 'email-already-in-use'){
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text(e.code),
        ));
      }
    }

  }


  bool validation(BuildContext context) {

    if (name.text
        .trim()
        .isEmpty) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text("Name is Required"),
      ));
      return false;
    }


    if (email.text
        .trim()
        .isEmpty) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text("Email is Required"),
      ));
      return false;
    }


    if(!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email.text.trim())){
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text("Email is not Valid"),
      ));
      return false;
    }

    if (password.text
        .trim()
        .isEmpty) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text("Password is Required"),
      ));
      return false;
    }


    if (password.text
        .trim()
        .length < 8) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text("Password must contain 8 characters"),
      ));
      return false;
    }


    if (phone.text
        .trim()
        .isEmpty) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text("Phone is Required"),
      ));
      return false;
    }


    if (address.text
        .trim()
        .isEmpty) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text("Address is Required"),
      ));
      return false;
    }


    return true;
  }

}
