import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:theme_provider/theme_provider.dart';

import '../models/department.dart';
import '../widgets/remove_glow.dart';
import '../widgets/request_map.dart';
import '../widgets/row_marker_details.dart';

class DepartmentScreen extends StatelessWidget {
  final Department department;
  final bool isHydrant = false;
  final Widget buttonBar;

  DepartmentScreen({
    @required this.department,
    @required this.buttonBar,
  });

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.light,
    ));
    return Scaffold(
      body: SlidingUpPanel(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(18.0),
          topRight: Radius.circular(18.0),
        ),
        parallaxEnabled: true,
        parallaxOffset: .5,
        color: ThemeProvider.themeOf(context).id == "main"
            ? Colors.white
            : Colors.black,
        maxHeight: MediaQuery.of(context).size.height / 1.7,
        panel: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Column(
              children: <Widget>[
                SizedBox(
                  height: 32.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: 30,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.all(
                          Radius.circular(12.0),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 16.0,
                ),
                Wrap(
                  children: <Widget>[
                    Center(
                      child: Text(
                        department.getStreet() + ", " + department.getNumber(),
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 24.0,
                          fontFamily: 'Nunito',
                          color: ThemeProvider.themeOf(context).id == "main"
                              ? Colors.grey[800]
                              : Colors.white,
                        ),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 16.0,
                ),
              ],
            ),
            SizedBox(
              height: 16.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                _button(department.getCity(), Icons.place, context),
                _button(department.getCap(), Icons.map, context),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12.0,
                ),
                child: ScrollConfiguration(
                  behavior: RemoveGlow(),
                  child: ListView(
                    shrinkWrap: true,
                    children: <Widget>[
                      RowMarkerDetails(
                        tag: "Telefono",
                        value: department.getPhoneNumber(),
                      ),
                      RowMarkerDetails(
                        tag: 'Email',
                        value: department.getMail(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 16.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ButtonBarTheme(
                  data: ButtonBarThemeData(
                    alignment: MainAxisAlignment.center,
                  ),
                  child: buttonBar,
                ),
              ],
            ),
          ],
        ),
        body: RequestMap(
          latitude: department.getLat(),
          longitude: department.getLong(),
          isHydrant: isHydrant,
        ),
      ),
    );
  }

  Widget _button(String label, IconData icon, BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(16.0),
          child: Icon(
            icon,
            color: ThemeProvider.themeOf(context).id == "main"
                ? Colors.red
                : Colors.white,
            size: 30,
          ),
          decoration: BoxDecoration(
            color: Colors.transparent,
            shape: BoxShape.circle,
            border: Border.all(
              color: ThemeProvider.themeOf(context).id == "main"
                  ? Colors.red
                  : Colors.white,
              width: 2,
            ),
          ),
        ),
        SizedBox(
          height: 12.0,
        ),
        Container(
          width: 72,
          child: Text(
            label,
            style: TextStyle(
              fontFamily: 'Nunito',
              color: ThemeProvider.themeOf(context).id == "main"
                  ? Colors.grey[800]
                  : Colors.white,
            ),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            softWrap: true,
          ),
        ),
      ],
    );
  }
}
