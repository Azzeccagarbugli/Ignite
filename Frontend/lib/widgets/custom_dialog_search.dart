import 'package:flutter/material.dart';

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
        Card(
          child: Container(
            color: Colors.amber,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 2,
            child: Text("data"),
          ),
        ),
        Card(
          child: Container(
            color: Colors.red,
            height: MediaQuery.of(context).size.height / 4,
            child: Text("data1"),
          ),
        ),
      ],
    );
    // return Stack(
    //   children: <Widget>[
    //     AlertDialog(
    //       backgroundColor: ThemeProvider.themeOf(context).data.backgroundColor,
    //       shape: RoundedRectangleBorder(
    //         borderRadius: BorderRadius.all(
    //           Radius.circular(22.0),
    //         ),
    //       ),
    //       title: Text(
    //         "Trova l'idrante più vicino",
    //         textAlign: TextAlign.center,
    //         style: TextStyle(
    //           fontWeight: FontWeight.bold,
    //           fontSize: 22,
    //         ),
    //       ),
    //       content: Container(
    //         height: 360,
    //         width: 320,
    //         child: ScrollConfiguration(
    //           behavior: RemoveGlow(),
    //           child: SingleChildScrollView(
    //             child: Column(
    //                 crossAxisAlignment: CrossAxisAlignment.center,
    //                 children: <Widget>[
    //                   Text(
    //                     "Seleziona i valori da te desiderati per cercare l'idrante più vicino che rispecchi i seguenti canoni",
    //                     textAlign: TextAlign.center,
    //                     style: TextStyle(
    //                       fontSize: 16,
    //                     ),
    //                   ),
    //                   SizedBox(
    //                     height: 16,
    //                   ),
    //                   Row(
    //                     children: <Widget>[
    //                       Chip(
    //                         elevation: 4,
    //                         backgroundColor:
    //                             ThemeProvider.themeOf(context).id == "main"
    //                                 ? Colors.red
    //                                 : Colors.grey[700],
    //                         label: Text(
    //                           "Attacco",
    //                           style: TextStyle(
    //                             color: Colors.white,
    //                             fontSize: 16,
    //                           ),
    //                         ),
    //                       ),
    //                       Spacer(),
    //                     ],
    //                   ),
    //                   Padding(
    //                     padding: EdgeInsets.fromLTRB(5, 15, 0, 15),
    //                     child: DropdownButton<String>(
    //                       hint: Text(
    //                         "Nessun attacco scelto",
    //                         style: TextStyle(),
    //                       ),
    //                       value: _attackFilter,
    //                       isDense: true,
    //                       onChanged: (value) {
    //                         setState(() {
    //                           _attackFilter = value;
    //                         });
    //                       },
    //                       items: _attacksListDropdown,
    //                     ),
    //                   ),
    //                   SizedBox(
    //                     height: 5,
    //                   ),
    //                   Row(
    //                     children: <Widget>[
    //                       Chip(
    //                         elevation: 4,
    //                         backgroundColor:
    //                             ThemeProvider.themeOf(context).id == "main"
    //                                 ? Colors.red
    //                                 : Colors.grey[700],
    //                         label: Text(
    //                           "Veicolo",
    //                           style: TextStyle(
    //                             color: Colors.white,
    //                             fontSize: 16,
    //                           ),
    //                         ),
    //                       ),
    //                       Spacer(),
    //                     ],
    //                   ),
    //                   Padding(
    //                     padding: EdgeInsets.fromLTRB(5, 15, 0, 15),
    //                     child: DropdownButton<String>(
    //                       hint: Text(
    //                         "Nessun veicolo scelto",
    //                         style: TextStyle(),
    //                       ),
    //                       value: _vehicleFilter,
    //                       isDense: true,
    //                       onChanged: (value) {
    //                         setState(() {
    //                           _vehicleFilter = value;
    //                         });
    //                       },
    //                       items: _vehiclesListDropdown,
    //                     ),
    //                   ),
    //                   SizedBox(
    //                     height: 5,
    //                   ),
    //                   Row(
    //                     children: <Widget>[
    //                       Chip(
    //                         elevation: 4,
    //                         backgroundColor:
    //                             ThemeProvider.themeOf(context).id == "main"
    //                                 ? Colors.red
    //                                 : Colors.grey[700],
    //                         label: Text(
    //                           "Apertura",
    //                           style: TextStyle(
    //                             color: Colors.white,
    //                             fontSize: 16,
    //                           ),
    //                         ),
    //                       ),
    //                       Spacer(),
    //                     ],
    //                   ),
    //                   Padding(
    //                     padding: EdgeInsets.fromLTRB(5, 15, 0, 15),
    //                     child: DropdownButton<String>(
    //                       hint: Text(
    //                         "Nessuna apertura scelta",
    //                         style: TextStyle(),
    //                       ),
    //                       value: _openingFilter,
    //                       isDense: true,
    //                       onChanged: (value) {
    //                         setState(() {
    //                           _openingFilter = value;
    //                         });
    //                       },
    //                       items: _openingsListDropdown,
    //                     ),
    //                   )
    //                 ]),
    //           ),
    //         ),
    //       ),
    //       actions: <Widget>[
    //         ButtonBar(
    //           children: <Widget>[
    //             ButtonDeclineConfirm(
    //               color: Colors.red,
    //               icon: Icon(
    //                 Icons.cancel,
    //                 color: Colors.white,
    //               ),
    //               text: "Annulla",
    //               onPressed: () {
    //                 Navigator.pop(context);
    //               },
    //             ),
    //             ButtonDeclineConfirm(
    //               color: Colors.green,
    //               icon: Icon(
    //                 Icons.check_circle,
    //                 color: Colors.white,
    //               ),
    //               text: "Cerca",
    //               onPressed: () {
    //                 Navigator.pop(context);
    //                 widget.searchFunction(
    //                   _attackFilter,
    //                   _vehicleFilter,
    //                   _openingFilter,
    //                 );
    //               },
    //             ),
    //           ],
    //         ),
    //       ],
    //     ),
    //   ],
    // );
  }
}
