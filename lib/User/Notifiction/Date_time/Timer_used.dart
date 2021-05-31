import 'package:ecommerce_fyp/User/Notifiction/notificationPlugin.dart';
import 'package:date_format/date_format.dart';
import 'package:ecommerce_fyp/User/UserHomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Time_picker extends StatefulWidget {
  @override
  _Time_pickerState createState() => _Time_pickerState();
}

class _Time_pickerState extends State<Time_picker> {
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

  @override
  void initState() {
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
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: _width,
        height: _height,
        child: mainScheduler(),
      ),
    );
  }

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
                Navigator.pop(context);
                Navigator.pop(context);
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
