import 'package:flutter/material.dart';


class Utils{

  static void loader(BuildContext context){
    showDialog(context: context,
      barrierDismissible: false,
      builder: (BuildContext context){
      return Dialog(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: new Row(
            children: [
              new CircularProgressIndicator(
                valueColor: new AlwaysStoppedAnimation<Color>(Color(0xffD02B31))
              ),

              SizedBox(width: 20.0,),

              new Text('Loading...')

            ],
          ),
        ),
      );
      }
    );
  }

}