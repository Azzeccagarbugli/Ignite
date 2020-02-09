import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';

class TopFlushbar {
  String _title;
  String _message;
  bool _isGood;
  Flushbar _source;
  TopFlushbar(String title, String message, bool isGood) {
    this._title = title;
    this._message = message;
    this._isGood = isGood;
    _source = new Flushbar(
      flushbarStyle: FlushbarStyle.GROUNDED,
      flushbarPosition: FlushbarPosition.TOP,
      title: _title,
      shouldIconPulse: true,
      message: _message,
      icon: _isGood
          ? Icon(
              Icons.check_circle,
              size: 28.0,
              color: Colors.greenAccent,
            )
          : Icon(
              Icons.warning,
              size: 28.0,
              color: Colors.redAccent,
            ),
      duration: Duration(
        seconds: 4,
      ),
    );
  }

  Future<Object> show(BuildContext context) {
    return _source.show(context);
  }
}
