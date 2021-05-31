import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Global {
  static String fbtoken;

  static void sendnotification(
      String token, String title, String body) async {
    print("sendingnotification");
    // Replace with server token from firebase console settings.
    final String serverToken =
        'AAAASEIUIO8:APA91bHoFE4n-HmIQ8XYVAzU1ADWuZ6y14Qw5FyrmUDpnBhh98y2bSAU_VqzLVI2cnmQoltSunlukBICxczOywaR3UP7dW5Fl_6qnVG5YXalGOP4De1p4K3uLOzBrY3CUKnpe95Hgcus';
    final FirebaseMessaging firebaseMessaging = FirebaseMessaging();

    await http.post(
      'https://fcm.googleapis.com/fcm/send',
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverToken',
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{'title': title, 'body': body},
          'priority': 'HIGH',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done',
            //'type': type,
            //'tid': tid
          },
          'to': token,
        },
      ),
    );
  }
}
