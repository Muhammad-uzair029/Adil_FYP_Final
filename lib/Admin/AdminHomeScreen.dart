import 'dart:async';

import 'package:ecommerce_fyp/Admin/Model/UserListModel.dart';
import 'package:ecommerce_fyp/Admin/Model/feedback.dart';
import 'package:ecommerce_fyp/Authentication/UserTypeScreen.dart';
import 'package:ecommerce_fyp/Global.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Utils.dart';
import 'Model/HotelStaffListModel.dart';
import 'Model/feedback.dart';

class AdminHome extends StatefulWidget {
  @override
  _AdminHomeState createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  int bottomNavigationIndex = 0;
  String title = "Users";
  List<UserListModel> userListData = new List();
  List<HotelStaffListModel> HotelStaffListData = new List();
  List<Feedbacks> feedbacksListData = new List();
  final databaseRefFeedback =
      FirebaseDatabase.instance.reference().child("Feedback").child("Feedback");

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Timer(Duration(milliseconds: 300), () {
      getUserData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: Text(title),
        actions: [
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
          return Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: (bottomNavigationIndex == 0)
                  ? users(context)
                  : (bottomNavigationIndex == 1)
                      ? HotelStaffs(context)
                      : getFeedback(context));
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle_outlined),
              title: Text('Users'),
              backgroundColor: Colors.redAccent),
          BottomNavigationBarItem(
              icon: Icon(Icons.attribution_rounded),
              title: Text('HotelStaffs'),
              backgroundColor: Colors.redAccent),
          BottomNavigationBarItem(
              icon: Icon(Icons.feedback_outlined),
              title: Text('Feedbacks'),
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
                ? title = "User"
                : (bottomNavigationIndex == 1)
                    ? title = "HotelStaffs"
                    : title = "Feedback";

            if (index == 0) {
              userListData.clear();
              getUserData();
            } else if (index == 1) {
              HotelStaffListData.clear();
              getHotelStaffData();
            } else {
              getfeedbackData();
            }
          });
        },
      ),
    );
  }

  Widget getFeedback(BuildContext context) {
    return ListView.builder(
        // Let the ListView know how many items it needs to build.
        itemCount: feedbacksListData.length,
        // Provide a builder function. This is where the magic happens.
        // Convert each item into a widget based on the type of item it is.
        itemBuilder: (context, index) {
          return Container(
              child: Column(children: [
            Card(
                elevation: 7,
                child: ListTile(
                  title: Text(feedbacksListData[index].feedback),
                  subtitle: Text("From Anonymous"),
                )),
          ]));
        });
  }

  Widget users(BuildContext context) {
    return Container(
      child: userListData.length != 0
          ? ListView.builder(
              itemCount: userListData.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  height: 60.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(10.0, 10.0, 0.0, 0.0),
                            child: Text(
                              userListData[index].name,
                              style: TextStyle(
                                  color: Colors.redAccent, fontSize: 15.0),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(10.0, 5.0, 0.0, 0.0),
                            child: Text(
                              userListData[index].email,
                              style: TextStyle(
                                  color: Colors.black, fontSize: 15.0),
                            ),
                          ),
                        ],
                      ),
                      ButtonTheme(
                        minWidth: 50.0,
                        height: 30.0,
                        child: RaisedButton(
                          onPressed: () {
                            showModalBottomSheet(
                              isScrollControlled: true,
                              context: context,
                              builder: (context) => SingleChildScrollView(
                                child: Container(
                                  padding: EdgeInsets.only(
                                      bottom: MediaQuery.of(context)
                                          .viewInsets
                                          .bottom),
                                  child: Bottomsheet(userListData[index].email),
                                ),
                              ),
                            );
                            // setState(() {
                            //   if (userListData[index].getActive() == 0) {
                            //     setActive('user', index, 1);
                            //   } else {
                            //     setActive('user', index, 0);
                            //   }
                            // });
                          },
                          color: Colors.grey,
                          child: Text(
                            "Give \nCoupon",
                            style:
                                TextStyle(color: Colors.white, fontSize: 18.0),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                      ),
                      ButtonTheme(
                        minWidth: 50.0,
                        height: 30.0,
                        child: RaisedButton(
                          onPressed: () {
                            setState(() {
                              if (userListData[index].getActive() == 0) {
                                setActive('user', index, 1);
                              } else {
                                setActive('user', index, 0);
                              }
                            });
                          },
                          color: (userListData[index].getActive() == 0)
                              ? Colors.green
                              : Colors.red,
                          child: Text(
                            (userListData[index].getActive() == 0)
                                ? 'Activate'
                                : 'Deactivate',
                            style:
                                TextStyle(color: Colors.white, fontSize: 18.0),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              })
          : Center(child: Text('Data Not Found')),
    );
  }

  Widget HotelStaffs(BuildContext context) {
    return Container(
      child: HotelStaffListData.length != 0
          ? ListView.builder(
              itemCount: HotelStaffListData.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  height: 60.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(10.0, 10.0, 0.0, 0.0),
                            child: Text(
                              HotelStaffListData[index].name,
                              style: TextStyle(
                                  color: Colors.redAccent, fontSize: 15.0),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(10.0, 5.0, 0.0, 0.0),
                            child: Text(
                              HotelStaffListData[index].email,
                              style: TextStyle(
                                  color: Colors.black, fontSize: 15.0),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0.0, 0.0, 15.0, 0.0),
                        child: ButtonTheme(
                          minWidth: 150.0,
                          height: 30.0,
                          child: RaisedButton(
                            onPressed: () {
                              setState(() {
                                if (HotelStaffListData[index].getActive() ==
                                    0) {
                                  setActive('shopkeeper', index, 1);
                                } else {
                                  setActive('shopkeeper', index, 0);
                                }
                              });
                            },
                            color: (HotelStaffListData[index].getActive() == 0)
                                ? Colors.green
                                : Colors.red,
                            child: Text(
                              (HotelStaffListData[index].getActive() == 0)
                                  ? 'Activate'
                                  : 'Deactivate',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 18.0),
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
              })
          : Center(child: Text('Data Not Found')),
    );
  }

  void getUserData() async {
    Utils.loader(context);
    DatabaseReference databaseReference =
        FirebaseDatabase.instance.reference().child('user');
    await databaseReference.once().then((DataSnapshot snapshot) {
      Navigator.pop(context);

      if (snapshot != null) {
        Map<dynamic, dynamic> values = snapshot.value;
        values.forEach((key, values) {
          setState(() {
            userListData.add(new UserListModel(
                key,
                values['address'],
                values['phone'],
                values['name'],
                values['active'],
                values['email']));
          });
        });
      } else {}
    });
  }

  void getHotelStaffData() async {
    Utils.loader(context);
    DatabaseReference databaseReference =
        FirebaseDatabase.instance.reference().child('shopkeeper');
    await databaseReference.once().then((DataSnapshot snapshot) {
      Navigator.pop(context);

      if (snapshot != null) {
        Map<dynamic, dynamic> values = snapshot.value;
        values.forEach((key, values) {
          setState(() {
            HotelStaffListData.add(new HotelStaffListModel(
                key,
                values['address'],
                values['phone'],
                values['name'],
                values['active'],
                values['email']));
          });
        });
      } else {}
    });
  }

  void getfeedbackData() async {
    feedbacksListData.clear();
    Utils.loader(context);
    DatabaseReference databaseReference =
        FirebaseDatabase.instance.reference().child('Feedback');
    await databaseReference.once().then((DataSnapshot snapshot) {
      print('Feedback : ${snapshot.value}');
      Navigator.pop(context);

      if (snapshot != null) {
        Map<dynamic, dynamic> values = snapshot.value;
        values.forEach((key, values) {
          print("This is the key brother");
          setState(() {
            feedbacksListData.add(new Feedbacks(values['Feedback']));
          });
          print(feedbacksListData);
        });
      } else {}
    });
  }

  void setActive(String type, int position, int value) async {
    Utils.loader(context);
    DatabaseReference databaseReference = FirebaseDatabase.instance
        .reference()
        .child(type)
        .child((type == 'user')
            ? userListData[position].key
            : HotelStaffListData[position].key);
    await databaseReference.update({'active': value});

    setState(() {
      if (type == 'user') {
        if (userListData[position].getActive() == 0) {
          userListData[position].setActive(1);
        } else {
          userListData[position].setActive(0);
        }
        Navigator.pop(context);
      } else {
        if (HotelStaffListData[position].getActive() == 0) {
          HotelStaffListData[position].setActive(1);
        } else {
          HotelStaffListData[position].setActive(0);
        }
        setProductActive(HotelStaffListData[position].key, value);
      }
    });
  }

  void setProductActive(String id, int value) async {
    print(id);
    DatabaseReference databaseReference =
        FirebaseDatabase.instance.reference().child('products');
    await databaseReference.once().then((DataSnapshot snapshot) {
      Navigator.pop(context);

      if (snapshot != null) {
        Map<dynamic, dynamic> values = snapshot.value;
        values.forEach((key, values) async {
          if (id == values['user']) {
            DatabaseReference databaseReference = FirebaseDatabase.instance
                .reference()
                .child('products')
                .child(key);
            await databaseReference.update({'active': value});
          }
        });
      } else {}
    });
  }

  logoutUser() async {
    Utils.loader(context);
    await FirebaseAuth.instance.signOut();
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

class Bottomsheet extends StatelessWidget {
  String user;
  Bottomsheet(this.user);
  // final Function addTaskCallBack;
  // Bottomsheet(this.addTaskCallBack);
  final _firestore = FirebaseFirestore.instance;
  void assigningcoupon() async {
    _firestore.collection('usercoupon').doc(user).set({
      'user': user,
      'coupon': coupon,
    });
    _firestore.collection('usertoken').doc(user).get().then((value) {
      if (value.exists) {
        print(value['token']);
        Global.sendnotification(
          value['token'],
          "You Have Got New Coupon!",
          "You Have Got a New Coupon Token of " + coupon + " % OFF!",
          // 'post',
          // "1",
        );
      } else {
        print('Doesnot exists');
      }
    });
  }

  String coupon;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xff757575),
      child: Container(
        padding: EdgeInsets.all(50),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Add Coupon',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.yellow,
                fontSize: 30,
              ),
            ),
            Text(
              'Enter Coupon Percentage below',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.yellow,
                fontSize: 20,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints.tightFor(
                    width: 50,
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      counterText: "",
                    ),
                    maxLength: 2,
                    keyboardType: TextInputType.number,
                    cursorColor: Colors.yellow,
                    textAlign: TextAlign.center,
                    autofocus: true,
                    onChanged: (newvalue) {
                      coupon = newvalue;
                      //print(newtask);
                    },
                  ),
                ),
                Text('%'),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            RaisedButton(
              onPressed: () {
                assigningcoupon();
                //print(newtask);
                // Provider.of<TaskData>(context, listen: false).addtask(newtask);
                Navigator.pop(context);
              },
              color: Colors.yellow,
              //disabledColor: Colors.lightBlueAccent,
              child: Text(
                'Add Coupon',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
