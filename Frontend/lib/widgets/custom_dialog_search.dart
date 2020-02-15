import 'package:flutter/material.dart';
import 'package:ignite/widgets/painter.dart';
import 'package:ignite/widgets/remove_glow.dart';
import 'package:theme_provider/theme_provider.dart';

import 'button_decline_approve.dart';
import 'listtile_builder_info.dart';

class CustomDialog extends StatefulWidget {
  CustomDialog({
    @required this.searchFunction,
    @required this.attacksList,
    @required this.vehiclesList,
    @required this.openingsList,
  });

  final Function searchFunction;
  final List<String> attacksList;
  final List<String> vehiclesList;
  final List<String> openingsList;

  @override
  _CustomDialogState createState() => _CustomDialogState();
}

class _CustomDialogState extends State<CustomDialog> {
  String _attackFilter;
  String _vehicleFilter;
  String _openingFilter;

  Set<String> _attacksList = new Set<String>();
  Set<String> _vehiclesList = new Set<String>();
  Set<String> _openingsList = new Set<String>();

  bool notNull(Object o) => o != null;

  void setDropdownMenuItems() {
    for (String value in widget.attacksList) {
      _attacksList.add(value);
    }
    for (String value in widget.vehiclesList) {
      _vehiclesList.add(value);
    }
    for (String value in widget.openingsList) {
      _openingsList.add(value);
    }
  }

  @override
  void initState() {
    super.initState();
    setDropdownMenuItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeProvider.themeOf(context).id == "main"
          ? Colors.white.withOpacity(0.85)
          : Colors.black.withOpacity(0.5),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              height: MediaQuery.of(context).size.height / 4.0,
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                  bottomLeft: Radius.zero,
                  bottomRight: Radius.zero,
                ),
                color: Colors.white,
              ),
              child: ClipPath(
                clipper: ShapeBorderClipper(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      topRight: Radius.circular(20.0),
                      bottomLeft: Radius.zero,
                      bottomRight: Radius.zero,
                    ),
                  ),
                ),
                child: CustomPaint(
                  painter: Painter(
                    first: ThemeProvider.themeOf(context).id == "main"
                        ? Colors.red[300]
                        : Colors.grey[850],
                    second: ThemeProvider.themeOf(context).id == "main"
                        ? Colors.red[400]
                        : Colors.grey[800],
                    background: ThemeProvider.themeOf(context).id == "main"
                        ? Colors.white
                        : Colors.grey[700],
                  ),
                  child: Column(
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20.0),
                            topRight: Radius.circular(20.0),
                            bottomLeft: Radius.circular(20.0),
                            bottomRight: Radius.circular(20.0),
                          ),
                          color: ThemeProvider.themeOf(context).id == "main"
                              ? Colors.red
                              : Colors.grey[900],
                        ),
                        child: ListTile(
                          contentPadding: EdgeInsets.all(14),
                          title: Text(
                            "Trova l'idrante più vicino",
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          trailing: Hero(
                            tag: 'NEARESTHYDRANTFILTERED',
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              child: Icon(
                                Icons.filter_list,
                                color:
                                    ThemeProvider.themeOf(context).id == "main"
                                        ? Colors.red
                                        : Colors.black,
                              ),
                            ),
                          ),
                          subtitle: Text(
                            "Seleziona i valori da te desiderati per cercare l'idrante più vicino che rispecchi i seguenti canoni",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: ScrollConfiguration(
                          behavior: RemoveGlow(),
                          child: ListView(
                            children: <Widget>[
                              BuildSectionFilter(
                                descValue:
                                    "Valore indicativo per la misura di attacco",
                                listValue: this._attacksList,
                                nameSection: "Attacco",
                                value: (i) {
                                  this._attackFilter = i;
                                },
                                icon: Icon(
                                  Icons.scatter_plot,
                                  color: Colors.white,
                                ),
                              ),
                              BuildSectionFilter(
                                descValue: "Mezzo per l'attacco all'idrante",
                                listValue: this._vehiclesList,
                                nameSection: "Veicolo",
                                value: (i) {
                                  this._vehicleFilter = i;
                                },
                                icon: Icon(
                                  Icons.directions_car,
                                  color: Colors.white,
                                ),
                              ),
                              BuildSectionFilter(
                                descValue: "Chiave dell'idrante",
                                listValue: this._openingsList,
                                nameSection: "Apertura",
                                value: (i) {
                                  this._openingFilter = i;
                                },
                                icon: Icon(
                                  Icons.vpn_key,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(
                                height: 12,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Container(
                            color: ThemeProvider.themeOf(context).id == "main"
                                ? Colors.red[600]
                                : Colors.black,
                            width: MediaQuery.of(context).size.width,
                            child: FlatButton.icon(
                              onPressed: () {
                                Navigator.pop(context);
                                widget.searchFunction(
                                  _attackFilter,
                                  _vehicleFilter,
                                  _openingFilter,
                                );
                              },
                              icon: Icon(
                                Icons.search,
                                color: Colors.white,
                              ),
                              label: Text(
                                "Cerca l'idrante",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
