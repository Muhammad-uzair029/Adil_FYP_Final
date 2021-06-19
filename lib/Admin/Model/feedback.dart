import 'package:flutter/material.dart';

class Feedbacks {
  String _feedback;

  Feedbacks(this._feedback);

  String get feedback => _feedback;
  set feedback(String val) {
    _feedback = val;
  }
}
