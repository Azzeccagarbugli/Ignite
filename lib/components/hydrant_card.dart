import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class HydrantCard extends StatefulWidget {
  @override
  _HydrantCardState createState() => _HydrantCardState();
}

class _HydrantCardState extends State<HydrantCard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Hello world!'),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.transparent,
        index: 1,
        animationDuration: Duration(milliseconds: 500),
        buttonBackgroundColor: Colors.white,
        items: <Icon>[
          Icon(
            Icons.terrain,
            size: 35,
            color: Colors.red[800],
          ),
          Icon(
            Icons.add,
            size: 35,
            color: Colors.red[800],
          ),
          Icon(
            Icons.supervisor_account,
            size: 35,
            color: Colors.red[800],
          ),
        ],
        onTap: (index) {
          print(index);
          if (index == 1) {
            Navigator.pop(context);
          }
        },
      ),
    );
  }
}
