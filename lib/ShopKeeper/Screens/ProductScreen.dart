import 'dart:io';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_fyp/Utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Product extends StatefulWidget {
  @override
  _ProductState createState() => _ProductState();
}

class _ProductState extends State<Product> {
  File _image;

  TextEditingController name = new TextEditingController();
  TextEditingController price = new TextEditingController();
  TextEditingController description = new TextEditingController();
  String catagoryValue = "Table";
  // var _catagories = ['Daal', 'Daal2', 'Daaa3', 'Daal3', 'Daal4'];
  // String dropdownValue = 'Grocery & Staples';

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        initialIndex: 0,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Product'),
            backgroundColor: Colors.amber,
            bottom: TabBar(
              onTap: (index) {
                setState(() {
                  name.clear();
                  description.clear();
                  price.clear();

                  print(_image);
                  if (index == 0) {
                    setState(() {
                      catagoryValue = "Table";
                      _image = null;
                    });

                    print(catagoryValue);
                  } else {
                    setState(() {
                      catagoryValue = "Food";
                      _image = null;
                    });
                    print(catagoryValue);
                  }
                });
              },
              tabs: [
                Tab(icon: Icon(Icons.contacts), text: "Table"),
                Tab(icon: Icon(Icons.camera_alt), text: "Food")
              ],
            ),
          ),
          body: TabBarView(
            children: [
              SingleChildScrollView(child: CommonPotion()),
              SingleChildScrollView(child: CommonPotion()),
            ],
          ),

// added by me
        ));
  }

  Widget CommonPotion() {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 20.0,
            ),
            Container(
              width: 100.0,
              height: 100.0,
              child: Stack(
                children: [
                  Card(
                    elevation: 5,
                    color: Colors.amber,
                    shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.white70, width: 1),
                        borderRadius: BorderRadius.circular(20.0)),
                    child: Container(
                      child: (_image == null)
                          ? GestureDetector(
                              onTap: () {
                                _imgFromGallery();
                              },
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.add,
                                      size: 50.0,
                                      color: Colors.white,
                                    ),
                                    Text(
                                      'Add Product\nImage',
                                      style: TextStyle(
                                          fontSize: 12.0, color: Colors.white),
                                      textAlign: TextAlign.center,
                                    )
                                  ],
                                ),
                              ),
                            )
                          : SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height,
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20.0),
                                  child: Image.file(
                                    _image,
                                    fit: BoxFit.fill,
                                  )),
                            ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 0.0),
              child: TextField(
                controller: name,
                cursorColor: Colors.amber,
                keyboardType: TextInputType.name,
                decoration: new InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(40.0),
                        borderSide: BorderSide(color: Color(0xf6f7fb))),
                    contentPadding: const EdgeInsets.fromLTRB(25, 15, 25, 15),
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
                    hintText: 'Product Name',
                    fillColor: Colors.grey[200]),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 0.0),
              child: TextField(
                controller: price,
                cursorColor: Colors.amber,
                keyboardType: TextInputType.number,
                decoration: new InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(40.0),
                        borderSide: BorderSide(color: Color(0xf6f7fb))),
                    contentPadding: const EdgeInsets.fromLTRB(25, 15, 25, 15),
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
                    hintText: 'Product Price',
                    fillColor: Colors.grey[200]),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 0.0),
              child: TextField(
                controller: description,
                cursorColor: Colors.amber,
                keyboardType: TextInputType.text,
                decoration: new InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(40.0),
                        borderSide: BorderSide(color: Color(0xf6f7fb))),
                    contentPadding: const EdgeInsets.fromLTRB(25, 15, 25, 15),
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
                    hintText: 'Product Description',
                    fillColor: Colors.grey[200]),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 0.0),
              child: ButtonTheme(
                minWidth: MediaQuery.of(context).size.width,
                height: 45.0,
                child: RaisedButton(
                  onPressed: () {
                    if (!validation(context)) return;
                    print(uploadPic(catagoryValue));
                  },
                  color: Colors.amber,
                  child: Text(
                    'Confirm',
                    style: TextStyle(color: Colors.white, fontSize: 18.0),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
              ),
            ),
          ],
        ));
  }

  _imgFromGallery() async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50);

    setState(() {
      _image = image;
    });
  }

  bool validation(BuildContext context) {
    if (_image == null) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text("Image is Required"),
      ));
      return false;
    }

    if (name.text.trim().isEmpty) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text("Name is Required"),
      ));
      return false;
    }

    if (price.text.trim().isEmpty) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text("Price is Required"),
      ));
      return false;
    }

    if (description.text.trim().isEmpty) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text("Description is Required"),
      ));
      return false;
    }

    return true;
  }

  uploadPic(String catagory) async {
    Utils.loader(context);
    int timestamp = DateTime.now().millisecondsSinceEpoch;

    String fileName = 'product$timestamp.jpg';

    FirebaseStorage _storage = FirebaseStorage.instance;
    //Create a reference to the location you want to upload to in firebase
    Reference _reference =
        _storage.ref().child("products").child(catagory).child(fileName);

    //Upload the file to firebase
    UploadTask uploadTask = _reference.putFile(_image);

    await uploadTask.whenComplete(() async {
      String fileName = await _reference.getDownloadURL();

      DatabaseReference databaseReference = FirebaseDatabase.instance
          .reference()
          .child('products')
          .child(catagory)
          .push();
      DatabaseReference databaseReference2 =
          FirebaseDatabase.instance.reference().child('products').push();

      final firestoreInstance = FirebaseFirestore.instance;
      firestoreInstance.collection(FirebaseAuth.instance.currentUser.uid).add({
        "image": fileName.toString(),
      }).then((value) => print("Added into Firestore"));
      await databaseReference.set({
        'user': FirebaseAuth.instance.currentUser.uid,
        'image': fileName.toString(),
        'name': name.text.trim(),
        'price': price.text.trim(),
        'description': description.text.trim(),
      });
      // await databaseReference2.set({
      //   'user': FirebaseAuth.instance.currentUser.uid,
      //   'image': fileName.toString(),
      //   'name': name.text.trim(),
      //   'price': price.text.trim(),
      //   'description': description.text.trim(),
      // });
      Navigator.pop(context);
      Navigator.pop(context);
    });
  }
}
