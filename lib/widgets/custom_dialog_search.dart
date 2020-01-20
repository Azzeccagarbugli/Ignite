import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:theme_provider/theme_provider.dart';

import 'button_decline_approve.dart';

class CustomDialog extends StatefulWidget {
  CustomDialog(
      {@required this.searchFunction,
      @required this.attacksList,
      @required this.vehiclesList,
      @required this.openingsList});

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

  bool _attackSwitch = false;
  bool _vehicleSwitch = false;
  bool _openingSwitch = false;

  List<DropdownMenuItem<String>> _attacksListDropdown = [];
  List<DropdownMenuItem<String>> _vehiclesListDropdown = [];
  List<DropdownMenuItem<String>> _openingsListDropdown = [];

  bool notNull(Object o) => o != null;

  void setDropdownMenuItems() {
    for (String value in widget.attacksList) {
      _attacksListDropdown.add(DropdownMenuItem(
        value: value,
        child: Text(value),
      ));
    }
    for (String value in widget.vehiclesList) {
      _vehiclesListDropdown.add(DropdownMenuItem(
        value: value,
        child: Text(value),
      ));
    }
    for (String value in widget.openingsList) {
      _openingsListDropdown.add(DropdownMenuItem(
        value: value,
        child: Text(value),
      ));
    }
  }

  @override
  void initState() {
    super.initState();
    setDropdownMenuItems();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AlertDialog(
          backgroundColor: ThemeProvider.themeOf(context).data.backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(22.0),
            ),
          ),
          title: Padding(
            padding: const EdgeInsets.only(top: 36.0),
            child: Text(
              "Trova l'idrante più vicino",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
          ),
          content: Container(
            height: 360,
            width: 320,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    "Seleziona i valori da te desiderati per cercare l'idrante più vicino che rispecchi i seguenti canoni",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Row(
                  children: <Widget>[
                    Chip(
                      elevation: 4,
                      backgroundColor:
                          ThemeProvider.themeOf(context).id == "main"
                              ? Colors.red
                              : Colors.grey[700],
                      label: Text(
                        "Attacco",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Spacer(),
                    Switch(
                      value: _attackSwitch,
                      onChanged: (value) {
                        setState(() {
                          _attackSwitch = value;
                        });
                      },
                      activeColor: ThemeProvider.themeOf(context).id == "main"
                          ? Colors.red
                          : Colors.grey[700],
                    ),
                  ],
                ),
                _attackSwitch
                    ? Padding(
                        padding: EdgeInsets.fromLTRB(5, 15, 0, 15),
                        child: DropdownButton<String>(
                          hint: Text(
                            "Nessun attacco selezionato",
                            style: TextStyle(),
                          ),
                          value: _attackFilter,
                          isDense: true,
                          onChanged: (value) {
                            setState(() {
                              _attackFilter = value;
                            });
                          },
                          items: _attacksListDropdown,
                        ),
                      )
                    : null,
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: <Widget>[
                    Chip(
                      elevation: 4,
                      backgroundColor:
                          ThemeProvider.themeOf(context).id == "main"
                              ? Colors.red
                              : Colors.grey[700],
                      label: Text(
                        "Veicolo",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Spacer(),
                    Switch(
                      value: _vehicleSwitch,
                      onChanged: (value) {
                        setState(() {
                          _vehicleSwitch = value;
                        });
                      },
                      activeColor: ThemeProvider.themeOf(context).id == "main"
                          ? Colors.red
                          : Colors.grey[700],
                    ),
                  ],
                ),
                _vehicleSwitch
                    ? Padding(
                        padding: EdgeInsets.fromLTRB(5, 15, 0, 15),
                        child: DropdownButton<String>(
                          hint: Text(
                            "Nessun veicolo selezionato",
                            style: TextStyle(),
                          ),
                          value: _vehicleFilter,
                          isDense: true,
                          onChanged: (value) {
                            setState(() {
                              _vehicleFilter = value;
                            });
                          },
                          items: _vehiclesListDropdown,
                        ),
                      )
                    : null,
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: <Widget>[
                    Chip(
                      elevation: 4,
                      backgroundColor:
                          ThemeProvider.themeOf(context).id == "main"
                              ? Colors.red
                              : Colors.grey[700],
                      label: Text(
                        "Apertura",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Spacer(),
                    Switch(
                      value: _openingSwitch,
                      onChanged: (value) {
                        setState(() {
                          _openingSwitch = value;
                        });
                      },
                      activeColor: ThemeProvider.themeOf(context).id == "main"
                          ? Colors.red
                          : Colors.grey[700],
                    ),
                  ],
                ),
                _openingSwitch
                    ? Padding(
                        padding: EdgeInsets.fromLTRB(5, 15, 0, 15),
                        child: DropdownButton<String>(
                          hint: Text(
                            "Nessuna apertura selezionata",
                            style: TextStyle(),
                          ),
                          value: _openingFilter,
                          isDense: true,
                          onChanged: (value) {
                            setState(() {
                              _openingFilter = value;
                            });
                          },
                          items: _openingsListDropdown,
                        ),
                      )
                    : null,
              ].where(notNull).toList(),
            ),
          ),
          actions: <Widget>[
            ButtonBar(
              children: <Widget>[
                ButtonDeclineConfirm(
                  color: Colors.red,
                  icon: Icon(
                    Icons.cancel,
                    color: Colors.white,
                  ),
                  text: "Annulla",
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                ButtonDeclineConfirm(
                  color: Colors.green,
                  icon: Icon(
                    Icons.check_circle,
                    color: Colors.white,
                  ),
                  text: "Cerca",
                  onPressed: () {
                    Navigator.pop(context);
                    widget.searchFunction(
                      _attackFilter,
                      _vehicleFilter,
                      _openingFilter,
                    );
                  },
                ),
              ],
            ),
          ],
        ),
        Positioned(
          left: 16,
          right: 16,
          top: 30,
          child: CircleAvatar(
            backgroundColor: ThemeProvider.themeOf(context).id == "main"
                ? Colors.orange[200]
                : Colors.grey[300],
            radius: 46,
            child: FlareActor(
              "assets/general/find.flr",
              alignment: Alignment.center,
              fit: BoxFit.contain,
              animation: "Search location",
            ),
          ),
        ),
      ],
    );
  }
}
