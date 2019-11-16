import 'package:flutter/material.dart';

class FabLoginScreen extends StatelessWidget {
  final Icon icon;
  final String heroTag;
  final Alignment alignment;
  final Function onPressed;

  FabLoginScreen({this.icon, this.heroTag, this.alignment, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Align(
        alignment: alignment,
        child: FloatingActionButton(
          heroTag: heroTag,
          onPressed: onPressed,
          child: icon,
          elevation: 3.0,
          backgroundColor: Colors.white,
          foregroundColor: Theme.of(context).primaryColor,
        ),
      ),
    );
  }
}
