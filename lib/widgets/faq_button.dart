import 'package:flutter/material.dart';
import 'package:ignite/views/faq.dart';
import 'package:theme_provider/theme_provider.dart';

import 'fab_first_screen.dart';

class FaqButton extends StatelessWidget {
  FaqButton({@required this.animation, @required this.align});

  final Animation<double> animation;
  final Alignment align;

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: animation,
      child: Hero(
        tag: 'icon_faq',
        child: FabLoginScreen(
          alignment: align,
          icon: Icon(
            Icons.question_answer,
            color: ThemeProvider.themeOf(context).data.primaryColor,
          ),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return FaqScreen();
            }));
          },
        ),
      ),
    );
  }
}
