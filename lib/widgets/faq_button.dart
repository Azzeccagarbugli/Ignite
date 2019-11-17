import 'package:flutter/material.dart';
import 'package:ignite/views/faq.dart';

import 'fab_first_screen.dart';

class FaqButton extends StatelessWidget {
  const FaqButton({
    Key key,
    @required this.animation,
  }) : super(key: key);

  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: animation,
      child: Hero(
        tag: 'icon_faq',
        child: FabLoginScreen(
          alignment: Alignment.bottomLeft,
          icon: Icon(
            Icons.question_answer,
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
