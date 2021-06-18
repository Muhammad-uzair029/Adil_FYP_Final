import 'dart:async';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_fyp/Authentication/UserTypeScreen.dart';
import 'package:ecommerce_fyp/Global.dart';
import 'package:ecommerce_fyp/ShopKeeper/Model/ShopKeeperOrdersModel.dart';
import 'package:ecommerce_fyp/ShopKeeper/Model/ShopKeeperProductsModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_range_slider/flutter_range_slider.dart' as frs;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import '../Utils.dart';
import 'OrderScreen.dart';
import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_fyp/Authentication/UserTypeScreen.dart';
import 'package:ecommerce_fyp/Global.dart';
import 'package:ecommerce_fyp/ShopKeeper/Model/ShopKeeperOrdersModel.dart';
import 'package:ecommerce_fyp/ShopKeeper/Model/ShopKeeperProductsModel.dart';
import 'package:ecommerce_fyp/User/Notifiction/Date_time/Timer_used.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_range_slider/flutter_range_slider.dart' as frs;
import 'package:ecommerce_fyp/Add_fvrt/fvrt_list.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:page_transition/page_transition.dart';
import '../Utils.dart';
import 'package:ecommerce_fyp/User/Notifiction/notificationPlugin.dart';
import 'package:date_format/date_format.dart';

import 'package:intl/intl.dart';

class UserHome extends StatefulWidget {
  final String _name, _email, _mobile, _address;

  UserHome(this._name, this._email, this._mobile, this._address);

  @override
  _UserHomeState createState() =>
      _UserHomeState(_name, _email, _mobile, _address);
}

class _UserHomeState extends State<UserHome> {
// Notification Code variables placed Belowww
  double _height;
  double _width;

  String _setTime, _setDate;

  String _hour, _minute, _time;

  String dateTime;

  DateTime selectedDate = DateTime.now();

  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);

  TextEditingController _dateController = TextEditingController();
  TextEditingController _timeController = TextEditingController();
  String pick;

// Notification Code Closed

  String _name, _email, _mobile, _address;
  double _lowerValue = 0.0;
  double _upperValue = 100000.0;
  int bottomNavigationIndex = 0;
  String title = "Products";
  String search = "";
  List<ShopKeeperProductsModel> dataProducts = new List();
  List<ShopKeeperProductsModel> newDataProducts = new List();
  List<ShopKeeperOrdersModel> dataOrders = new List();

  _UserHomeState(this._name, this._email, this._mobile, this._address);
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final _firestore = FirebaseFirestore.instance;
  TextEditingController feedbackController = new TextEditingController();

  int cataIndex = 0;
  String cataName = "";

  FlutterLocalNotificationsPlugin local = FlutterLocalNotificationsPlugin();

  void settingtoken() async {
    _firestore
        .collection('usertoken')
        .doc(FirebaseAuth.instance.currentUser.email)
        .set({
      'user': FirebaseAuth.instance.currentUser.email,
      'token': Global.fbtoken,
    });
  }

  final databaseRef =
      FirebaseDatabase.instance.reference(); //database reference object

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _firebaseMessaging.getToken().then((String token) {
      print("gettingtoken");
      Global.fbtoken = token;
      settingtoken();
      var android = AndroidInitializationSettings('app_icon');
      var iossettings = IOSInitializationSettings();
      var initial = InitializationSettings(android, iossettings);
      local.initialize(initial);
      // Timer(Duration(milliseconds: 300), () {
      getProducts("Table");
      // });
    });
    _timeController.text = formatDate(
        DateTime(2019, 08, 1, DateTime.now().hour, DateTime.now().minute),
        [hh, ':', nn, " ", am]).toString();
    super.initState();
    notificationPlugin
        .setListenerForLowerVersions(onNotificationInLowerVersions);
    notificationPlugin.setOnNotificationClick(onNotificationClick);
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    dateTime = DateFormat.yMd().format(DateTime.now());
    return DefaultTabController(
        length: 2,
        initialIndex: 0,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.amber,
            title: Text(title),
            actions: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
                child: IconButton(
                    icon: Icon(Icons.shopping_cart_outlined),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => heart()));
                    }),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
                child: IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: () {
                      saveSession();
                      logoutUser();
                    }),
              ),
            ],
          ),
          body: Builder(
            builder: (context) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: (bottomNavigationIndex == 0)
                          ? TextField(
                              cursorColor: Colors.amber,
                              keyboardType: TextInputType.emailAddress,
                              decoration: new InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(40.0),
                                      borderSide:
                                          BorderSide(color: Color(0xf6f7fb))),
                                  contentPadding:
                                      const EdgeInsets.fromLTRB(25, 15, 25, 15),
                                  isDense: true,
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: const BorderRadius.all(
                                        const Radius.circular(40.0),
                                      ),
                                      borderSide:
                                          BorderSide(color: Color(0xf6f7fb))),
                                  border: new OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(
                                      const Radius.circular(40.0),
                                    ),
                                  ),
                                  filled: true,
                                  fillColor: Colors.grey[200],
                                  hintText: 'Search'),
                              onChanged: (text) {
                                setState(() {
                                  search = text;

                                  if (search.length != 0) {
                                    newDataProducts = dataProducts
                                        .where((element) =>
                                            element.name.toLowerCase().contains(
                                                search.toLowerCase()) &&
                                            double.parse(element.price) >=
                                                _lowerValue &&
                                            double.parse(element.price) <=
                                                _upperValue)
                                        .toList();
                                  } else {
                                    newDataProducts = dataProducts
                                        .where((element) =>
                                            double.parse(element.price) >=
                                                _lowerValue &&
                                            double.parse(element.price) <=
                                                _upperValue)
                                        .toList();
                                  }
                                });
                              },
                            )
                          : null,
                    ),
                    (bottomNavigationIndex == 0) ? Text('PRICE') : Container(),
                    (bottomNavigationIndex == 0)
                        ? Padding(
                            padding:
                                const EdgeInsets.only(left: 10.0, right: 10.0),
                            child: frs.RangeSlider(
                              min: 0.0,
                              max: 100000.0,
                              lowerValue: _lowerValue,
                              upperValue: _upperValue,
                              divisions: 1000,
                              showValueIndicator: true,
                              valueIndicatorMaxDecimals: 1,
                              onChanged:
                                  (double newLowerValue, double newUpperValue) {
                                setState(() {
                                  _lowerValue = newLowerValue;
                                  _upperValue = newUpperValue;

                                  if (search.length != 0) {
                                    newDataProducts = dataProducts
                                        .where((element) =>
                                            element.name.toLowerCase().contains(
                                                search.toLowerCase()) &&
                                            double.parse(element.price) >=
                                                _lowerValue &&
                                            double.parse(element.price) <=
                                                _upperValue)
                                        .toList();
                                  } else {
                                    newDataProducts = dataProducts
                                        .where((element) =>
                                            double.parse(element.price) >=
                                                _lowerValue &&
                                            double.parse(element.price) <=
                                                _upperValue)
                                        .toList();
                                  }
                                });
                              },
                            ),
                          )
                        : Container(),
                    (bottomNavigationIndex == 0)
                        ? Padding(
                            padding:
                                const EdgeInsets.only(left: 15.0, right: 15.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(_lowerValue.toString()),
                                Text(_upperValue.toString())
                              ],
                            ),
                          )
                        : Container(),
                    (bottomNavigationIndex == 0)
                        ? Column(children: [
                            SizedBox(
                              height: 75,
                              child: AppBar(
                                backgroundColor: Colors.white,
                                bottom: TabBar(
                                  unselectedLabelColor: Colors.black,
                                  labelColor: Colors.red,
                                  onTap: (index) {
                                    setState(() {
                                      if (index == 0) {
                                        setState(() {
                                          cataName = "Table";
                                        });

                                        print(cataIndex);
                                        print(cataName);
                                        getProducts(cataName);
                                      } else {
                                        setState(() {
                                          cataName = "Food";
                                        });
                                        print(cataIndex);
                                        print(cataName);
                                        getProducts(cataName);
                                      }
                                    });
                                  },
                                  tabs: [
                                    Tab(
                                        icon: Icon(Icons.table_chart),
                                        text: "Table"),
                                    Tab(
                                        icon: Icon(Icons.food_bank),
                                        text: "Food")
                                  ],
                                ),
                              ),
                            ),
                          ])
                        : Container(),
                    SingleChildScrollView(
                        child: Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: (bottomNavigationIndex == 0)
                          ? gridProducts(context)
                          : (bottomNavigationIndex == 1)
                              ? orders(context)
                              : mainScheduler(),
                    )),
                  ],
                ),
              );
            },
          ),
          bottomNavigationBar: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                  icon: Icon(Icons.widgets_outlined),
                  title: Text('Products'),
                  backgroundColor: Colors.amberAccent),
              BottomNavigationBarItem(
                  icon: Icon(Icons.shopping_cart_outlined),
                  title: Text('Orders'),
                  backgroundColor: Colors.amberAccent),
              BottomNavigationBarItem(
                  icon: Icon(Icons.schedule),
                  title: Text('Schedule'),
                  backgroundColor: Colors.amberAccent),
            ],
            backgroundColor: Colors.amberAccent,
            elevation: 5,
            currentIndex: bottomNavigationIndex,
            selectedItemColor: Colors.blue,
            iconSize: 40,
            onTap: (index) {
              setState(() {
                bottomNavigationIndex = index;
                (bottomNavigationIndex == 0)
                    ? title = "Products"
                    : (bottomNavigationIndex == 1)
                        ? title = "Orders"
                        : title = "Schedule";

                if (index == 0) {
                  getProducts("Table");
                }
                if (index == 1) {
                  getOrders();
                }
              });
            },
          ),
        ));
  }

  Widget products(BuildContext context) {
    return Container(
      child: dataProducts.length != 0
          ? ListView.builder(
              itemCount: dataProducts.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  onTap: () {
                    /*Navigator.push(context, MaterialPageRoute(builder: (context){
                  return Product();
                }));*/
                  },
                  title: Text(
                    dataProducts[index].name,
                    style: TextStyle(fontSize: 20.0),
                  ),
                  subtitle: Text(
                    "Rs. " + dataProducts[index].price,
                    style: TextStyle(fontSize: 15.0, color: Colors.amber),
                  ),
                  leading: CircleAvatar(
                    radius: 30.0,
                    backgroundImage: NetworkImage(dataProducts[index].image),
                    backgroundColor: Colors.transparent,
                  ),
                  trailing: IconButton(
                    icon: new Icon(Icons.add_shopping_cart),
                    onPressed: () {
                      print(_email);
                      print(dataProducts[index].image);
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return Order(
                            _name,
                            dataProducts[index].description,
                            _email,
                            _mobile,
                            _address,
                            dataProducts[index].name,
                            dataProducts[index].price,
                            dataProducts[index].id,
                            dataProducts[index].user,
                            dataProducts[index].image);
                      }));
                    },
                    iconSize: 30.0,
                    color: Colors.black,
                  ),
                );
              })
          : Center(child: Text('Data Not Found')),
    );
  }

  String imagevar;
  Widget gridProducts(BuildContext context) {
    return GridView.builder(
        physics: NeverScrollableScrollPhysics(),
        itemCount: newDataProducts.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, crossAxisSpacing: 2.0, mainAxisSpacing: 2.0),
        itemBuilder: (context, index) {
          return InkResponse(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return Order(
                    _name,
                    dataProducts[index].description,
                    _email,
                    _mobile,
                    _address,
                    newDataProducts[index].name,
                    newDataProducts[index].price,
                    newDataProducts[index].id,
                    newDataProducts[index].user,
                    newDataProducts[index].image);
              }));
            },
            child: Card(
              semanticContainer: true,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              elevation: 3.0,
              child: new Column(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.23,
                    width: MediaQuery.of(context).size.width,
                    child: Image.network(
                      newDataProducts[index].image,
                      fit: BoxFit.fill,
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    // height: 40,
                    color: Colors.grey,
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          newDataProducts[index].name,
                          style: TextStyle(
                              color: Colors.amber,
                              fontSize: 22.0,
                              fontWeight: FontWeight.bold),
                        ),
                        Text("Rs. " + newDataProducts[index].price,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  updateStatus(int position) async {
    Utils.loader(context);
    DatabaseReference databaseReference = FirebaseDatabase.instance
        .reference()
        .child('orders')
        .child(dataOrders[position].orderID);
    await databaseReference.update({'shippingstatus': 'Received'});
    _firestore
        .collection('usertoken')
        .doc(dataOrders[position].shopkeeperID)
        .get()
        .then((value) {
      if (value.exists) {
        print(value['token']);
        var androiddetail = AndroidNotificationDetails('title', 'name', 'body',
            importance: Importance.High, priority: Priority.Max);
        var iosdetail = IOSNotificationDetails();
        var generaldetail = NotificationDetails(androiddetail, iosdetail);
        local.show(
            value['tokken'],
            'order shipped',
            "Your Order with Order No." +
                dataOrders[position].orderID +
                " has been Completed and Shipped",
            generaldetail);
        /*Global.sendnotification(
          value['token'],
          "Order Delivered!",
          "Order with Order No." +
              dataOrders[position].orderID +
              " has been Received by Customer",
        );*/
      } else {
        print('Doesnot exists');
      }
    });
    Navigator.pop(context);
    setState(() {
      dataOrders[position].setshippingstatus('Received');
    });
  }

  Widget orders(BuildContext context) {
    return Column(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
              child: Text(
                dataOrders.isEmpty ? "" : dataOrders[0].userName,
                style: TextStyle(fontSize: 18.0, color: Colors.black),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10.0, 5.0, 0.0, 0.0),
              child: Text(
                dataOrders.isEmpty ? "" : dataOrders[0].userEmail,
                style: TextStyle(fontSize: 12.0, color: Colors.black26),
              ),
            ),
          ],
        ),
        Expanded(
          child: Container(
            child: dataOrders.length != 0
                ? ListView.builder(
                    itemCount: dataOrders.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding:
                            const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  dataOrders[index].productName.toUpperCase(),
                                  style: TextStyle(
                                      fontSize: 12.0, color: Colors.amber),
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      0.0, 5.0, 0.0, 0.0),
                                  child: Text(
                                    'Rs. ' + dataOrders[index].productPrice,
                                    style: TextStyle(
                                        fontSize: 12.0, color: Colors.black),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Order Status",
                                  style: TextStyle(
                                      fontSize: 12.0, color: Colors.black),
                                ),
                                Text(
                                  (dataOrders[index].status == "Pending")
                                      ? "Pending"
                                      : "Completed",
                                  style: TextStyle(
                                      fontSize: 12.0, color: Colors.amber),
                                ),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Shipping Status",
                                  style: TextStyle(
                                      fontSize: 12.0, color: Colors.black),
                                ),
                                Text(
                                  (dataOrders[index].shippingstatus == "0")
                                      ? "----"
                                      : dataOrders[index].shippingstatus,
                                  style: TextStyle(
                                      fontSize: 12.0, color: Colors.amber),
                                ),
                              ],
                            ),
                            Visibility(
                              visible: dataOrders[index].status != "Pending" &&
                                  dataOrders[index].shippingstatus !=
                                      "Received",
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    10.0, 10.0, 10.0, 0.0),
                                child: ButtonTheme(
                                  minWidth: 50,
                                  height: 45.0,
                                  child: RaisedButton(
                                    onPressed: () {
                                      Dialog(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(40)),
                                          elevation: 18,
                                          child: Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.4,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.35,
                                            child: Column(
                                              children: [
                                                Center(
                                                    child: Text(
                                                  "Give feedback to us please\n  for further batterment",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )),
                                                Divider(
                                                    color: Colors.yellow,
                                                    thickness: 5),
                                                TextField(
                                                    controller:
                                                        feedbackController,
                                                    cursorColor: Colors.yellow,
                                                    decoration: new InputDecoration(
                                                        hintText:
                                                            "Place your feedback")),
                                                SizedBox(height: 30.0),
                                                Center(
                                                    child: RaisedButton(
                                                        color:
                                                            Colors.pinkAccent,
                                                        child: Text("Submit"),
                                                        onPressed: () {
                                                          databaseRef
                                                              .push()
                                                              .set({
                                                            'Feedback':
                                                                feedbackController
                                                                    .text
                                                          });
                                                        })),
                                              ],
                                            ),
                                          ));
                                      updateStatus(index);
                                    },
                                    color: Colors.amber,
                                    child: Text(
                                      'Delivered?',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 18.0),
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    })
                : Center(child: Text('Data Not Found')),
          ),
        ),
      ],
    );
  }

  Widget sheduleTime(BuildContext context) {
    return Container(
        child: Column(
      children: [
        Container(
          margin: EdgeInsets.only(top: 20),
          child: OutlineButton(
              borderSide: BorderSide(color: Colors.white),
              child: Text('Send SMS Later',
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.yellow,
                      fontWeight: FontWeight.bold)),
              onPressed: () {
                Navigator.push(
                    context,
                    PageTransition(
                      child: Time_picker(),
                      type: PageTransitionType.rightToLeft,
                    ));
              }),
        )
      ],
    ));
  }

  getProducts(String cata) async {
    Utils.loader(context);
    DatabaseReference databaseReference =
        FirebaseDatabase.instance.reference().child('products').child(cata);
    await databaseReference.once().then((DataSnapshot snapshot) {
      Navigator.pop(context);
      dataProducts.clear();
      if (snapshot != null) {
        Map<dynamic, dynamic> values = snapshot.value;
        values.forEach((key, values) {
          setState(() {
            dataProducts.add(new ShopKeeperProductsModel(
                key,
                values['image'],
                values['name'],
                values['price'],
                values['description'],
                values['user']));
            newDataProducts = dataProducts;
          });
        });
      } else {}
    });
  }

  getOrders() async {
    Utils.loader(context);
    DatabaseReference databaseReference =
        FirebaseDatabase.instance.reference().child('orders');
    await databaseReference.once().then((DataSnapshot snapshot) {
      Navigator.pop(context);
      dataOrders.clear();
      if (snapshot != null) {
        Map<dynamic, dynamic> values = snapshot.value;
        values.forEach((key, values) {
          setState(() {
            if (values['user_id'] == FirebaseAuth.instance.currentUser.uid)
              dataOrders.add(new ShopKeeperOrdersModel(
                  key,
                  values['user_id'],
                  values['user_name'],
                  values['user_email'],
                  values['user_phone'],
                  values['user_address'],
                  values['product_id'],
                  values['product_name'],
                  values['product_price'],
                  values['shopkeeper_id'],
                  values['status'],
                  values['shippingstatus']));
          });
        });
      } else {}
    });
  }

  logoutUser() async {
    Utils.loader(context);
    _firestore
        .collection('usertoken')
        .doc(FirebaseAuth.instance.currentUser.email)
        .delete()
        .then((value) async {
      await FirebaseAuth.instance.signOut();
    });
    //await FirebaseAuth.instance.signOut();
    Navigator.pop(context);
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => UserType()));
  }

  void saveSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('type', "");
    await prefs.setString('email', "");
    await prefs.setString('password', "");
  }

// Schedulerr Widgetteee and Functionss Start From here
  Widget mainScheduler() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Container(
            height: MediaQuery.of(context).size.height * 0.1,
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
            child: Center(
                child: Text(
              'Schedule Message',
              style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: 28),
            ))),
        Container(
            height: MediaQuery.of(context).size.height * 0.8,
            child: Column(
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.only(right: 150, bottom: 30),
                    child: Text(
                      'Current Time',
                      style: TextStyle(
                          fontSize: 25,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                          color: Colors.green),
                    )),
                Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    height: MediaQuery.of(context).size.height * 0.1,
                    margin: const EdgeInsets.only(left: 10),
                    child: Center(
                        child: Text(
                      _timeController.text.substring(0, 2) +
                          ':' +
                          _timeController.text.substring(3, 5) +
                          ':' +
                          _timeController.text.substring(6, 8),
                      style: TextStyle(fontSize: 30),
                    )),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color:
                            Colors.grey, //                   <--- border color
                      ),
                    )),
                Padding(
                    padding: EdgeInsets.only(right: 80, top: 50),
                    child: Text(
                      'Tap to Choose Time',
                      style: TextStyle(
                          fontSize: 25,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                          color: Colors.green),
                    )),
                InkWell(
                  onTap: () {
                    _selectTime(context);
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 30, right: 10),
                    width: _width / 1.5,
                    height: _height / 7,
                    alignment: Alignment.center,
                    // decoration: BoxDecoration(color: Colors.grey[200]),
                    child: TextFormField(
                      style: TextStyle(fontSize: 30),
                      textAlign: TextAlign.center,
                      onSaved: (String val) {
                        _setTime = val;
                      },
                      enabled: false,
                      keyboardType: TextInputType.text,
                      controller: _timeController,
                      decoration: InputDecoration(
                        icon: Icon(
                          Icons.schedule,
                          color: Colors.green,
                        ),
                        helperText: 'Tap to schedule',
                        border: const OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.green, width: 5.0)),
                      ),
                    ),
                  ),
                ),

                // outline button for procedd and notification setters
                Padding(
                    padding: EdgeInsets.only(top: 50),
                    child: OutlineButton(
                        child: Text(
                          'Schedule Message',
                          style: TextStyle(
                              color: Colors.green,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                        onPressed: () async {
                          final currentHour = DateTime.now().hour;
                          final currentMinutes = DateTime.now().minute;

                          int intValue =
                              int.parse(pick.replaceAll(RegExp('[^0-9]'), ''));
                          String valuee = intValue.toString();
                          List<String> splittedvalue = valuee.split('');
                          String pickhours, pickminutes;

                          print(splittedvalue);
                          print('Splitted values::::');
                          if (splittedvalue.length == 4) {
                            pickhours = splittedvalue.elementAt(0) +
                                splittedvalue.elementAt(1);

                            pickminutes = splittedvalue.elementAt(2) +
                                splittedvalue.elementAt(3);
                          } else {
                            pickhours = splittedvalue[0];
                            pickminutes = splittedvalue[1] + splittedvalue[2];
                          }
                          // calculate the difference;;;
                          int hourDiff = int.parse(pickhours) - currentHour;
                          int minutesDiff =
                              int.parse(pickminutes) - (currentMinutes);

                          // hourDiff.isNegative
                          //     ? hourDiff = hourDiff + 12
                          //     : hourDiff;

                          minutesDiff.isNegative
                              ? minutesDiff = minutesDiff + 60
                              : minutesDiff;
                          print('this is a difference');

                          print(hourDiff);
                          print(minutesDiff);
                          print('Calculated Seconds');
                          int calculatedDiff =
                              ((hourDiff * 60 * 60) + (minutesDiff * 60));
                          print(calculatedDiff);
                          await notificationPlugin
                              .scheduleNotification(calculatedDiff);
                          _showinstrutionDialog();
                        }))
              ],
            )),
      ],
    );
  }

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    final dateTime = DateTime.now();

    if (picked != null)
      setState(() {
        selectedTime = picked;
        pick = picked.toString();
        _hour = selectedTime.hour.toString();
        _minute = selectedTime.minute.toString();
        _time = _hour + ' : ' + _minute;
        _timeController.text = _time;
        _timeController.text = formatDate(
            DateTime(int.parse(dateTime.toString()), selectedTime.hour,
                selectedTime.minute),
            [hh, ':', nn, " ", am]).toString();
      });
  }

  Future<void> _showinstrutionDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Make Sure'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                    'Please do not remove an app\nfrom recent apps till reminder pop up.'),
                // Text('Would you like to approve of this message?'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            UserHome(_name, _email, _mobile, _address)));
              },
            ),
          ],
        );
      },
    );
  }

  onNotificationInLowerVersions(ReceivedNotification receivedNotification) {
    print('Notification Received ${receivedNotification.id}');
  }

  onNotificationClick(String payload) {
    print('Payload $payload');
    // Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //       builder: (context) => whatsApp_Messagner(),
    //     ));
  }
}
