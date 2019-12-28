import 'package:flutter/material.dart';
import 'package:pk_skeleton/pk_skeleton.dart';
import 'package:theme_provider/theme_provider.dart';

class RequestLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Card(
          color: Colors.transparent,
          child: ThemeProvider.themeOf(context).id == "main"
              ? PKCardPageSkeleton(
                  totalLines: 2,
                )
              : PKDarkCardPageSkeleton(
                  totalLines: 2,
                ),
        ),
      ),
    );
  }
}
