import 'package:flutter/material.dart';
import 'package:theme_provider/theme_provider.dart';

class SocialChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final Function function;
  final double width;
  final double opacity;

  SocialChip({
    @required this.label,
    @required this.icon,
    @required this.function,
    @required this.width,
    @required this.opacity,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(
        milliseconds: 700,
      ),
      curve: Curves.easeInOutCubic,
      width: width,
      child: ActionChip(
        onPressed: function,
        backgroundColor: Colors.white,
        elevation: 12,
        labelPadding: EdgeInsets.all(
          6.0,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            20.0,
          ),
        ),
        labelStyle: TextStyle(
          color: Colors.grey[600],
          fontFamily: 'Nunito',
        ),
        avatar: AnimatedOpacity(
          duration: Duration(
            milliseconds: 1900,
          ),
          opacity: opacity,
          child: Icon(
            icon,
            color: ThemeProvider.themeOf(context).data.primaryColor,
          ),
        ),
        label: AnimatedOpacity(
          duration: Duration(
            milliseconds: 1900,
          ),
          curve: Curves.easeInOutCubic,
          opacity: opacity,
          child: Text(
            label,
          ),
        ),
      ),
    );
  }
}
