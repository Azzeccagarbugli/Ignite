import 'package:flutter/material.dart';

class ButtonDeclineConfirm extends StatelessWidget {
  final String text;
  final Icon icon;
  final Function onPressed;
  final Color color;
  ButtonDeclineConfirm({
    @required this.text,
    @required this.icon,
    @required this.onPressed,
    @required this.color,
  });
  @override
  Widget build(BuildContext context) {
    return RaisedButton.icon(
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(
          Radius.circular(16.0),
        ),
      ),
      color: this.color,
      onPressed: this.onPressed,
      icon: this.icon,
      label: Text(
        this.text,
        style: TextStyle(
          color: Colors.white,
          fontFamily: 'Nunito',
        ),
      ),
    );
  }
}
