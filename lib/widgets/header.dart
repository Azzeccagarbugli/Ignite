import 'dart:core';

import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  final String title;
  final String subtitle;
  final Icon icon;
  final String heroTag;

  Header({
    @required this.title,
    @required this.subtitle,
    this.icon,
    this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 16.0,
        right: 16.0,
        top: 40.0,
        bottom: 4.0,
      ),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Hero(
                tag: heroTag,
                child: icon,
              ),
              SizedBox(
                width: 12.0,
              ),
              Text(
                title,
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 52.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  subtitle,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
