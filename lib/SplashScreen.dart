import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';

import 'Authentication/UserTypeScreen.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Firebase.initializeApp();

    //////Setting Up Notifications
    ///
    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onResume: $message");
        final title = message['notification']['title'] ?? '';
        final body = message['notification']['body'] ?? '';
        //print(object))
        print(title + body);

        //////

        showOverlayNotification((context) {
          return SafeArea(
            child: GestureDetector(
              child: Card(
                color: Colors.white,
                child: Container(
                    width: MediaQuery.of(context).size.width / 1.3,
                    //height: 100,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            body,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.w500),
                          ),
                          // Text(
                          //   message['notification']['body'],
                          //   style: TextStyle(
                          //     color: Colors.white,
                          //   ),
                          //   maxLines: 3,
                          //   overflow: TextOverflow.ellipsis,
                          // ),
                        ],
                      ),
                    )),
              ),
            ),
          );
        }, duration: Duration(seconds: 3));

        //////
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onResume: $message");
        final title = message['notification']['title'] ?? '';
        final body = message['notification']['body'] ?? '';

        print(title + body);
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        final title = message['notification']['title'] ?? '';
        final body = message['notification']['body'] ?? '';

        print(title + body);
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => ChatlistScreen(),
        //   ),
        // );
        //_navigateToItemDetail(message);
      },
    );

    Timer(Duration(seconds: 3), () {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (BuildContext context) {
        return UserType();
      }));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
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
                child: Text(
                  "E-COMMERCE",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15.0,
                  ),
                ),
              ),
              Text(
                "        FIREBASE",
                style: TextStyle(
                    color: Colors.amber,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold),
              ),
            ],
          )),
    );
  }
}
