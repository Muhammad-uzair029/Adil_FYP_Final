import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_fyp/Add_fvrt/Database.dart';
import 'package:ecommerce_fyp/Global.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../Utils.dart';
import 'package:toast/toast.dart';
import 'package:ecommerce_fyp/Add_fvrt/fvrt_list.dart';

class Order extends StatefulWidget {
  String _name,
      _description,
      _email,
      _mobile,
      _address,
      _productName,
      _productPrice,
      _productID,
      _shopkeeperID;

  var _image;

  Order(
      this._name,
      this._description,
      this._email,
      this._mobile,
      this._address,
      this._productName,
      this._productPrice,
      this._productID,
      this._shopkeeperID,
      this._image);

  @override
  _OrderState createState() => _OrderState(_name, _description, _email, _mobile,
      _address, _productName, _productPrice, _productID, _shopkeeperID, _image);
}

class _OrderState extends State<Order> {
  String coupon = "0";
  bool showcoupon = false;
  String _name,
      _description,
      _email,
      _mobile,
      _address,
      _productName,
      _productPrice,
      _productID,
      _shopkeeperID;
  var _image;

  TextEditingController _etName;
  TextEditingController _etEmail;
  TextEditingController _etPhone;
  TextEditingController _etAddress;
  final FirebaseFirestore _message = FirebaseFirestore.instance;

  _OrderState(
      this._name,
      this._description,
      this._email,
      this._mobile,
      this._address,
      this._productName,
      this._productPrice,
      this._productID,
      this._shopkeeperID,
      this._image);

  availdiscount() {
    _message
        .collection('usercoupon')
        .doc(FirebaseAuth.instance.currentUser.email)
        .delete()
        .then((value) async {
      setState(() {
        showcoupon = false;
        widget._productPrice = (int.parse(widget._productPrice) -
                (int.parse(widget._productPrice) * (int.parse(coupon) / 100)))
            .toString();
      });
    });
  }

  getcoupon() {
    print(FirebaseAuth.instance.currentUser.email);
    _message
        .collection('usercoupon')
        .doc(FirebaseAuth.instance.currentUser.email)
        .get()
        .then((value) {
      if (value.exists) {
        print(value['coupon']);
        setState(() {
          coupon = value['coupon'];
          showcoupon = true;
        });
        // Global.sendnotification(
        //   value['token'],
        //   "New Order!",
        //   "You have a New Order from " + _etName.text.trim(),
        //   'post',
        //   "1",
        // );
      } else {
        print('Doesnot exists');
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    getcoupon();
    super.initState();
    _etName = new TextEditingController(text: _name);
    _etEmail = new TextEditingController(text: _email);
    _etPhone = new TextEditingController(text: _mobile);
    _etAddress = new TextEditingController(text: _address);
  }

  final DBStudentManager dbStudentManager = new DBStudentManager();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Order Now" + _productName.toUpperCase()),
        backgroundColor: Colors.amber,
      ),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 20.0,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 0.0),
                child: TextField(
                  controller: _etName,
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
                      hintText: 'User Name',
                      fillColor: Colors.grey[200]),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 0.0),
                child: TextField(
                  controller: _etEmail,
                  cursorColor: Colors.amber,
                  keyboardType: TextInputType.emailAddress,
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
                      hintText: 'User Email',
                      fillColor: Colors.grey[200]),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 0.0),
                child: TextField(
                  controller: _etPhone,
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
                      hintText: 'User Mobile',
                      fillColor: Colors.grey[200]),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 0.0),
                child: TextField(
                  controller: _etAddress,
                  cursorColor: Colors.amber,
                  keyboardType: TextInputType.streetAddress,
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
                      hintText: 'User Address',
                      fillColor: Colors.grey[200]),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  "Total Price:" + widget._productPrice,
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
              Visibility(
                visible: showcoupon,
                child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text('You have a Discount coupon of ' +
                            coupon +
                            "% OFF!"),
                        ButtonTheme(
                          minWidth: 50,
                          height: 45.0,
                          child: RaisedButton(
                            onPressed: () {
                              availdiscount();
                              //orderProduct();
                            },
                            color: Colors.amber,
                            child: Text(
                              'Avail',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 18.0),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                          ),
                        ),
                      ],
                    )),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 0.0),
                child: ButtonTheme(
                  minWidth: MediaQuery.of(context).size.width,
                  height: 45.0,
                  child: RaisedButton(
                    onPressed: () {
                      orderProduct();
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
              Padding(
                padding: const EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 0.0),
                child: ButtonTheme(
                  minWidth: MediaQuery.of(context).size.width,
                  height: 45.0,
                  child: RaisedButton(
                    onPressed: () {
                      addToCart(
                          widget._name,
                          widget._description,
                          widget._email,
                          widget._mobile,
                          widget._address,
                          widget._productName,
                          widget._productPrice,
                          widget._productID,
                          widget._image,
                          widget._shopkeeperID);
                      Toast.show("Product Added into Cart", context,
                          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                      print("add to cart Image Shownn");
                      print(_image);
                      print(_email);
                      Navigator.pop(context);
                    },
                    color: Colors.amber,
                    child: Text(
                      'Add to Cart',
                      style: TextStyle(color: Colors.white, fontSize: 18.0),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  QuerySnapshot snapshot;
  addToCart(String name, description, email, mobile, address, productName,
      productPrice, productID, image, shopkeeperID) async {
    Student st;

    var now = DateTime.now();

    st = new Student(
        name: name,
        productdescription: description,
        email: email,
        mobile: mobile,
        productName: productName,
        productPrice: productPrice,
        productID: productID,
        address: address,
        image: image,
        shopkeeperID: shopkeeperID,
        time: now.toLocal().toString());
    dbStudentManager.insertStudent(st).then((value) => {
          name,
          email,
          mobile,
          address,
          productName,
          productPrice,
          productID,
          image,
          shopkeeperID,
          now,
          print("Student Data Add to database $value"),
          // print(imageurl),
          print(name),
          print(email),
          print(address),
          print(now),
        });
  }

  orderProduct() async {
    print(_productPrice);
    Utils.loader(context);
    DatabaseReference databaseReference =
        FirebaseDatabase.instance.reference().child('orders').push();
    await databaseReference.set({
      'user_id': FirebaseAuth.instance.currentUser.uid,
      'user_name': _etName.text.trim(),
      'user_email': _etEmail.text.trim(),
      'user_phone': _etPhone.text.trim(),
      'user_address': _etAddress.text.trim(),
      'product_id': _productID,
      'product_name': _productName,
      'product_price': widget._productPrice,
      'shopkeeper_id': _shopkeeperID,
      'status': "Pending",
      'shippingstatus': "0"
    });
    _message.collection('usertoken').doc(_shopkeeperID).get().then((value) {
      if (value.exists) {
        print(value['token']);
        Global.sendnotification(
          value['token'],
          "New Order!",
          "You have a New Order from " + _etName.text.trim(),
        );
      } else {
        print('Doesnot exists');
      }
    });
    Navigator.pop(context);
    Navigator.pop(context);
  }
}
