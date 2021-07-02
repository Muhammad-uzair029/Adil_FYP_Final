import 'dart:async';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_fyp/Authentication/UserTypeScreen.dart';
import 'package:ecommerce_fyp/Global.dart';
import 'package:ecommerce_fyp/HotelStaff/Model/HotelStaffOrdersModel.dart';
import 'package:ecommerce_fyp/HotelStaff/Screens/OrderDetailScreen.dart';
import 'package:ecommerce_fyp/HotelStaff/Screens/ProductScreen.dart';
import 'package:ecommerce_fyp/Utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Model/HotelStaffProductsModel.dart';

class HotelStaffHome extends StatefulWidget {
  @override
  _HotelStaffHomeState createState() => _HotelStaffHomeState();
}

class _HotelStaffHomeState extends State<HotelStaffHome> {
  int bottomNavigationIndex = 0;
  String title = "Products";
  String status = "pending";
  List<HotelStaffProductsModel> dataProducts = new List();
  List<HotelStaffOrdersModel> dataOrders = new List();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final _firestore = FirebaseFirestore.instance;
  FlutterLocalNotificationsPlugin local = FlutterLocalNotificationsPlugin();
  int cataIndex = 0;
  String cataName = "Table";
  void settingtoken() async {
    _firestore
        .collection('usertoken')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .set({
      'user': FirebaseAuth.instance.currentUser.uid,
      'token': Global.fbtoken,
    });
  }

  @override
  void initState() {
    super.initState();
    _firebaseMessaging.getToken().then((String token) {
      print("gettingtoken");
      Global.fbtoken = token;
      settingtoken();
      // Timer(Duration(milliseconds: 300), () {
      getProducts("Table");
      // });/
    });
    var android = AndroidInitializationSettings('app_icon');
    var iossettings = IOSInitializationSettings();
    var initial = InitializationSettings(android, iossettings);
    local.initialize(initial);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        initialIndex: 0,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text(title),
            backgroundColor: Colors.redAccent,
            automaticallyImplyLeading: false,
            actions: [
              if (bottomNavigationIndex == 0)
                Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
                  child: IconButton(
                      icon: Icon(Icons.add_box_sharp),
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return Product();
                        })).then((value) => getProducts(cataName));
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
                  child: Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: SingleChildScrollView(
                          child: Column(children: [
                        (bottomNavigationIndex == 0)
                            ? Column(children: [
                                SizedBox(
                                  height: 100,
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
                        Container(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          child: (bottomNavigationIndex == 0)
                              ? shopkeeperProducts(context, cataName)
                              : shopkeeperOrders(context),
                        ),
                      ]))));
            },
          ),
          bottomNavigationBar: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                  icon: Icon(Icons.widgets_outlined),
                  title: Text('Products'),
                  backgroundColor: Colors.redAccent),
              BottomNavigationBarItem(
                  icon: Icon(Icons.shopping_cart_outlined),
                  title: Text('Orders'),
                  backgroundColor: Colors.redAccent),
            ],
            backgroundColor: Colors.redAccent,
            elevation: 5,
            currentIndex: bottomNavigationIndex,
            selectedItemColor: Colors.blue,
            iconSize: 40,
            onTap: (index) {
              setState(() {
                bottomNavigationIndex = index;
                (bottomNavigationIndex == 0)
                    ? title = "Products"
                    : title = "Orders";

                if (index == 0) {
                  getProducts(cataName);
                } else {
                  getOrders();
                }
              });
            },
          ),
        ));
  }

  Widget shopkeeperProducts(BuildContext context, String cata) {
    return Container(
      child: dataProducts.length != 0
          ? ListView.builder(
              physics: NeverScrollableScrollPhysics(),
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
                    style: TextStyle(fontSize: 15.0, color: Colors.redAccent),
                  ),
                  leading: CircleAvatar(
                    radius: 30.0,
                    backgroundImage: NetworkImage(dataProducts[index].image),
                    backgroundColor: Colors.transparent,
                  ),
                  trailing: IconButton(
                    icon: new Icon(Icons.delete_forever),
                    onPressed: () {
                      deleteProduct(index, cata);
                    },
                    iconSize: 30.0,
                    color: Colors.black,
                  ),
                );
              })
          : Center(child: Text('Data Not Found')),
    );
  }

  Widget shopkeeperOrders(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: dataOrders.length != 0
          ? ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              itemCount: dataOrders.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => OrderDetail(
                                  dataOrders[index].userName,
                                  dataOrders[index].userEmail,
                                  dataOrders[index].userPhone,
                                  dataOrders[index].userAddress,
                                  dataOrders[index].productName,
                                  dataOrders[index].productPrice,
                                )));
                  },
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                              child: Text(
                                dataOrders[index].userName,
                                style: TextStyle(
                                    fontSize: 18.0, color: Colors.black),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  10.0, 5.0, 0.0, 0.0),
                              child: Text(
                                dataOrders[index].userEmail,
                                style: TextStyle(
                                    fontSize: 12.0, color: Colors.black26),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              dataOrders[index].productName.toUpperCase(),
                              style: TextStyle(
                                  fontSize: 12.0, color: Colors.redAccent),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
                              child: Text(
                                'Rs. ' + dataOrders[index].productPrice,
                                style: TextStyle(
                                    fontSize: 12.0, color: Colors.black),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                        Visibility(
                          visible: dataOrders[index].shippingstatus == "0",
                          child: Padding(
                            padding:
                                const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                            child: new DropdownButton<String>(
                              value: (dataOrders[index].status == "Pending")
                                  ? status = "pending"
                                  : status = "completed",
                              items: <String>['pending', 'completed']
                                  .map((String value) {
                                return new DropdownMenuItem<String>(
                                  value: value,
                                  child: new Text(value,
                                      style: TextStyle(
                                          fontSize: 15.0,
                                          color: Colors.redAccent)),
                                );
                              }).toList(),
                              onChanged: (value) {
                                if (value == "Pending") {
                                  updateStatus(
                                      index,
                                      "Pending",
                                      dataOrders[index].userEmail,
                                      dataOrders[index].orderID);
                                } else {
                                  updateStatus(
                                      index,
                                      "Completed",
                                      dataOrders[index].userEmail,
                                      dataOrders[index].orderID);
                                }
                              },
                            ),
                          ),
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
                                  fontSize: 12.0, color: Colors.redAccent),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              })
          : Center(child: Text('Data Not Found')),
    );
  }

  updateStatus(
      int position, String value, String useremail, String orderid) async {
    Utils.loader(context);
    DatabaseReference databaseReference = FirebaseDatabase.instance
        .reference()
        .child('orders')
        .child(dataOrders[position].orderID);
    await databaseReference
        .update({'status': value, 'shippingstatus': 'Shipping'});
    _firestore.collection('usertoken').doc(useremail).get().then((value) {
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
                orderid +
                " has been Completed and Shipped",
            generaldetail);
        /*Global.sendnotification(
          value['token'],
          "Order Shipped!",
          "Your Order with Order No." +
              orderid +
              " has been Completed and Shipped",
        );*/
      } else {
        print('Doesnot exists');
      }
    });
    Navigator.pop(context);
    setState(() {
      dataOrders[position].setStatus(value);
      dataOrders[position].setshippingstatus("Shipping");
    });
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
            if (values['user'] == FirebaseAuth.instance.currentUser.uid)
              dataProducts.add(new HotelStaffProductsModel(
                  key,
                  values['image'],
                  values['name'],
                  values['price'],
                  values['description'],
                  values['user']));
          });
          print(values["name"]);
          print(values["price"]);
          print(values["description"]);
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
            if (values['ShopKeeper_id'] ==
                FirebaseAuth.instance.currentUser.uid)
              dataOrders.add(new HotelStaffOrdersModel(
                key,
                values['user_id'],
                values['user_name'],
                values['user_email'],
                values['user_phone'],
                values['user_address'],
                values['product_id'],
                values['product_name'],
                values['product_price'],
                values['ShopKeeper_id'],
                values['status'],
                values['shippingstatus'],
              ));
          });
        });
      } else {}
    });
  }

  deleteProduct(int position, String cata) async {
    Utils.loader(context);
    DatabaseReference databaseReference = FirebaseDatabase.instance
        .reference()
        .child('products')
        .child(cata)
        .child(dataProducts[position].id);
    await databaseReference.remove();
    Navigator.pop(context);
    setState(() {
      dataProducts.removeAt(position);
    });
  }

  logoutUser() async {
    Utils.loader(context);

    _firestore
        .collection('usertoken')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .delete()
        .then((value) async {
      await FirebaseAuth.instance.signOut();
    });
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
}

// class Category extends StatelessWidget {
//   final String image_location;
//   final String image_caption;

//   Category({this.image_location, this.image_caption});
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Container(
//         width: MediaQuery.of(context).size.width * 0.3,
//         child: ListTile(
//           title:  Container Image.asset(
//             image_location,
//             width: 200.0,
//             height: 140.0,
//           ),
//           subtitle: Container(
//             alignment: Alignment.topCenter,
//             child: Text(
//               image_caption,
//               style: new TextStyle(fontSize: 15.0, color: Colors.black),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
