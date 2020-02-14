import 'package:flutter/material.dart';
import 'package:ignite/widgets/remove_glow.dart';
import 'package:theme_provider/theme_provider.dart';

import 'button_decline_approve.dart';

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
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
        backgroundColor: ThemeProvider.themeOf(context).id == "main"
            ? Colors.red
            : Colors.black,
        onPressed: () {},
      ),
      backgroundColor: Colors.white.withOpacity(0.85),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: MediaQuery.of(context).size.height / 4.0,
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
                      color: Colors.red,
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
                            color: ThemeProvider.themeOf(context).id == "main"
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
                            icon: Icon(
                              Icons.scatter_plot,
                              color: ThemeProvider.themeOf(context).id == "main"
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                          BuildSectionFilter(
                            descValue: "Mezzo per l'attacco all'idrante",
                            listValue: this._vehiclesList,
                            nameSection: "Veicolo",
                            icon: Icon(
                              Icons.directions_car,
                              color: ThemeProvider.themeOf(context).id == "main"
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                          BuildSectionFilter(
                            descValue: "Chiave dell'idrante",
                            listValue: this._openingsList,
                            nameSection: "Apertura",
                            icon: Icon(
                              Icons.vpn_key,
                              color: ThemeProvider.themeOf(context).id == "main"
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                          SizedBox(
                            height: 12,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
    // return AlertDialog(
    //   backgroundColor: ThemeProvider.themeOf(context).data.backgroundColor,
    //   shape: RoundedRectangleBorder(
    //     borderRadius: BorderRadius.all(
    //       Radius.circular(22.0),
    //     ),
    //   ),
    // title: Text(
    //   "Trova l'idrante più vicino",
    //   textAlign: TextAlign.center,
    //   style: TextStyle(
    //     fontWeight: FontWeight.bold,
    //     fontSize: 22,
    //   ),
    // ),
    //   content: Container(
    //     child: ScrollConfiguration(
    //       behavior: RemoveGlow(),
    //       child: SingleChildScrollView(
    //         child: Column(
    //             crossAxisAlignment: CrossAxisAlignment.center,
    //             children: <Widget>[
    //               Text(
    //                 "Seleziona i valori da te desiderati per cercare l'idrante più vicino che rispecchi i seguenti canoni",
    //                 textAlign: TextAlign.center,
    //                 style: TextStyle(
    //                   fontSize: 16,
    //                 ),
    //               ),
    //               SizedBox(
    //                 height: 16,
    //               ),
    //               Row(
    //                 children: <Widget>[
    //                   Chip(
    //                     elevation: 4,
    //                     backgroundColor:
    //                         ThemeProvider.themeOf(context).id == "main"
    //                             ? Colors.red
    //                             : Colors.grey[700],
    //                     label: Text(
    //                       "Attacco",
    //                       style: TextStyle(
    //                         color: Colors.white,
    //                         fontSize: 16,
    //                       ),
    //                     ),
    //                   ),
    //                   Spacer(),
    //                 ],
    //               ),
    //               Padding(
    //                 padding: EdgeInsets.fromLTRB(5, 15, 0, 15),
    //                 child: DropdownButton<String>(
    //                   hint: Text(
    //                     "Nessun attacco scelto",
    //                     style: TextStyle(),
    //                   ),
    //                   value: _attackFilter,
    //                   isDense: true,
    //                   onChanged: (value) {
    //                     setState(() {
    //                       _attackFilter = value;
    //                     });
    //                   },
    //                   items: _attacksListDropdown,
    //                 ),
    //               ),
    //               SizedBox(
    //                 height: 5,
    //               ),
    //               Row(
    //                 children: <Widget>[
    //                   Chip(
    //                     elevation: 4,
    //                     backgroundColor:
    //                         ThemeProvider.themeOf(context).id == "main"
    //                             ? Colors.red
    //                             : Colors.grey[700],
    //                     label: Text(
    //                       "Veicolo",
    //                       style: TextStyle(
    //                         color: Colors.white,
    //                         fontSize: 16,
    //                       ),
    //                     ),
    //                   ),
    //                   Spacer(),
    //                 ],
    //               ),
    //               Padding(
    //                 padding: EdgeInsets.fromLTRB(5, 15, 0, 15),
    //                 child: DropdownButton<String>(
    //                   hint: Text(
    //                     "Nessun veicolo scelto",
    //                     style: TextStyle(),
    //                   ),
    //                   value: _vehicleFilter,
    //                   isDense: true,
    //                   onChanged: (value) {
    //                     setState(() {
    //                       _vehicleFilter = value;
    //                     });
    //                   },
    //                   items: _vehiclesListDropdown,
    //                 ),
    //               ),
    //               SizedBox(
    //                 height: 5,
    //               ),
    //               Row(
    //                 children: <Widget>[
    //                   Chip(
    //                     elevation: 4,
    //                     backgroundColor:
    //                         ThemeProvider.themeOf(context).id == "main"
    //                             ? Colors.red
    //                             : Colors.grey[700],
    //                     label: Text(
    //                       "Apertura",
    //                       style: TextStyle(
    //                         color: Colors.white,
    //                         fontSize: 16,
    //                       ),
    //                     ),
    //                   ),
    //                   Spacer(),
    //                 ],
    //               ),
    //               Padding(
    //                 padding: EdgeInsets.fromLTRB(5, 15, 0, 15),
    //                 child: DropdownButton<String>(
    //                   hint: Text(
    //                     "Nessuna apertura scelta",
    //                     style: TextStyle(),
    //                   ),
    //                   value: _openingFilter,
    //                   isDense: true,
    //                   onChanged: (value) {
    //                     setState(() {
    //                       _openingFilter = value;
    //                     });
    //                   },
    //                   items: _openingsListDropdown,
    //                 ),
    //               )
    //             ]),
    //       ),
    //     ),
    //   ),
    //   actions: <Widget>[
    //     ButtonBar(
    //       children: <Widget>[
    //         ButtonDeclineConfirm(
    //           color: Colors.red,
    //           icon: Icon(
    //             Icons.cancel,
    //             color: Colors.white,
    //           ),
    //           text: "Annulla",
    //           onPressed: () {
    //             Navigator.pop(context);
    //           },
    //         ),
    //         ButtonDeclineConfirm(
    //           color: Colors.green,
    //           icon: Icon(
    //             Icons.check_circle,
    //             color: Colors.white,
    //           ),
    //           text: "Cerca",
    //           onPressed: () {
    //             Navigator.pop(context);
    //             widget.searchFunction(
    //               _attackFilter,
    //               _vehicleFilter,
    //               _openingFilter,
    //             );
    //           },
    //         ),
    //       ],
    //     ),
    //   ],
    // );
  }
}

class BuildSectionFilter extends StatefulWidget {
  final Set<String> listValue;
  final String nameSection;
  final String descValue;
  final Icon icon;
  BuildSectionFilter({
    @required this.listValue,
    @required this.nameSection,
    @required this.descValue,
    @required this.icon,
  });

  @override
  _BuildSectionFilterState createState() => _BuildSectionFilterState();
}

class _BuildSectionFilterState extends State<BuildSectionFilter> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 2,
            ),
            child: Row(
              children: <Widget>[
                Chip(
                  backgroundColor: Colors.white,
                  elevation: 6,
                  label: Text(
                    this.widget.nameSection,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 100.0,
            child: ScrollConfiguration(
              behavior: RemoveGlow(),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: widget.listValue.length,
                itemBuilder: (context, i) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: Container(
                      width: 200,
                      child: Card(
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          // side: BorderSide(color: Colors.red, width: 2),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(12.0),
                          ),
                        ),
                        child: ListTile(
                          title: Text(
                            widget.listValue.elementAt(i),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            this.widget.descValue,
                          ),
                          onTap: () {
                            setState(() {
                              print(widget.listValue.elementAt(i));
                            });
                          },
                          leading: CircleAvatar(
                            backgroundColor:
                                ThemeProvider.themeOf(context).id == "main"
                                    ? Colors.red
                                    : Colors.white,
                            child: this.widget.icon,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
