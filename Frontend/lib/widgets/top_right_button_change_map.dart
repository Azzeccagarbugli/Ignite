import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:theme_provider/theme_provider.dart';

import 'homepage_button.dart';

class TopButtonRightMapChangeView extends StatefulWidget {
  final Function changeMapFunction;
  TopButtonRightMapChangeView({
    @required this.changeMapFunction,
  });
  @override
  _TopButtonRightMapChangeViewState createState() =>
      _TopButtonRightMapChangeViewState();
}

class _TopButtonRightMapChangeViewState
    extends State<TopButtonRightMapChangeView>
    with SingleTickerProviderStateMixin {
  bool isVisible = false;
  AnimationController _controller;
  Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _offsetAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(-2.5, 0.0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticIn,
    ));
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        HomePageButton(
          function: () {
            setState(() {
              isVisible = !isVisible;
              if (isVisible) {
                this._controller.reverse();
              } else {
                this._controller.forward();
              }
              this._controller.addStatusListener((status) {
                if (status == AnimationStatus.completed) {
                  this._controller.reset();
                }
              });
            });
          },
          icon: Icons.layers,
          heroTag: 'SATELLITE',
        ),
        SizedBox(
          height: 12,
        ),
        if (this.isVisible) buildContainer(),
      ],
    );
  }

  Widget buildContainer() {
    return SlideTransition(
      position: _offsetAnimation,
      child: Center(
        child: Card(
          elevation: 12,
          shape: RoundedRectangleBorder(
            borderRadius: const BorderRadius.all(
              Radius.circular(52.0),
            ),
          ),
          color: ThemeProvider.themeOf(context).id == "main"
              ? Colors.white
              : Colors.grey[850],
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    widget.changeMapFunction(MapType.normal);
                    setState(() {
                      this._controller.reverse();
                      this.isVisible = false;
                    });
                  },
                  child: Icon(
                    Icons.map,
                    color: ThemeProvider.themeOf(context).id == "main"
                        ? Colors.red[600]
                        : Colors.white,
                    size: 28,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: GestureDetector(
                    onTap: () {
                      widget.changeMapFunction(MapType.satellite);
                      setState(() {
                        this._controller.reverse();
                        this.isVisible = false;
                      });
                    },
                    child: Icon(
                      Icons.satellite,
                      color: ThemeProvider.themeOf(context).id == "main"
                          ? Colors.red[600]
                          : Colors.white,
                      size: 28,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      widget.changeMapFunction(MapType.hybrid);

                      this._controller.reverse();
                      this.isVisible = false;
                    });
                  },
                  child: Icon(
                    Icons.tonality,
                    color: ThemeProvider.themeOf(context).id == "main"
                        ? Colors.red[600]
                        : Colors.white,
                    size: 28,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
