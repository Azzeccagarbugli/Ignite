import 'package:flutter/material.dart';
import 'package:ignite/views/introduction_tutorial.dart';
import 'package:theme_provider/theme_provider.dart';

import 'fab_first_screen.dart';

class AnonimousButton extends StatelessWidget {
  final Animation<double> animation;
  final Future<void> anonimousFunction;
  final Alignment align;
  AnonimousButton(
      {@required this.animation,
      @required this.anonimousFunction,
      @required this.align});

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: animation,
      child: FabLoginScreen(
        alignment: align,
        heroTag: 'incognito_btn',
        icon: Icon(
          Icons.visibility_off,
          color: ThemeProvider.themeOf(context).data.primaryColor,
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
