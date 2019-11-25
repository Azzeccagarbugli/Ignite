import 'package:flutter/material.dart';
import 'package:ignite/models/app_state.dart';
import 'package:ignite/widgets/homepage_button.dart';
import 'package:provider/provider.dart';

class FiremanScreen extends StatefulWidget {
  @override
  _FiremanScreenState createState() => _FiremanScreenState();
}

class _FiremanScreenState extends State<FiremanScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Provider.of<AppState>(context).getUser().email),
        backgroundColor: Colors.red,
      ),
      body: Center(
        child: HomePageButton(
          heroTag: 'LOGOUT',
          icon: Icons.backspace,
          function: () {
            Provider.of<AppState>(context).logOut(context);
          },
        ),
      ),
    );
  }
}
