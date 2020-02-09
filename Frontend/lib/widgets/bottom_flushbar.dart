import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:theme_provider/theme_provider.dart';

class BottomFlushbar {
  String _title;
  String _message;
  Icon _icon;
  BuildContext _context;
  Flushbar _source;
  BottomFlushbar(
      String title, String message, Icon icon, BuildContext context) {
    this._context = context;
    this._icon = icon;
    this._title = title;
    this._message = message;
    _source = new Flushbar(
      flushbarStyle: FlushbarStyle.GROUNDED,
      flushbarPosition: FlushbarPosition.BOTTOM,
      backgroundColor: ThemeProvider.themeOf(_context).data.bottomAppBarColor,
      icon: _icon,
      title: _title,
      message: _message,
      duration: Duration(
        seconds: 2,
      ),
    );
  }

  Future<Object> show() {
    return _source.show(_context);
  }
}
