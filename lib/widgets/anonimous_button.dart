import 'package:flutter/material.dart';
import 'package:ignite/views/introduction_tutorial.dart';

import 'fab_first_screen.dart';

class AnonimousButton extends StatelessWidget {
  AnonimousButton({this.animation, this.anonimousFunction});

  final Animation<double> animation;
  final Future<void> anonimousFunction;
  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: animation,
      child: FabLoginScreen(
        alignment: Alignment.bottomRight,
        heroTag: 'incognito_btn',
        icon: Icon(
          Icons.visibility_off,
        ),
        onPressed: () {
          anonimousFunction;
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) {
            return IntroductionTutorial();
          }));
        },
      ),
    );
  }
}
