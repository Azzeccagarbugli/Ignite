import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ignite/models/hydrant.dart';
import 'package:ignite/models/request.dart';
import 'package:ignite/providers/auth_provider.dart';
import 'package:ignite/providers/db_provider.dart';
import 'package:ignite/widgets/loading_shimmer.dart';
import 'package:ignite/widgets/remove_glow.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class RequestForm extends StatefulWidget {
  Request oldRequest;
  Hydrant oldHydrant;
  double lat;
  double long;
  String _firstAttack;
  String _secondAttack;
  String _pressure;
  String _cap;
  String _city;
  String _color;
  DateTime _lastCheck;
  String _notes;
  String _opening;
  String _street;
  String _number;
  String _type;
  String _vehicle;
  bool _isFireman;
  bool isNewRequest;
  RequestForm({
    @required this.lat,
    @required this.long,
    @required this.isNewRequest,
    this.oldRequest,
    this.oldHydrant,
  });

  @override
  _RequestFormState createState() => _RequestFormState();
}

class _RequestFormState extends State<RequestForm> {
  Future<List<Placemark>> getFuturePlacemark() async {
    List<Placemark> list;
    try {
      list = await Geolocator().placemarkFromCoordinates(
        widget.lat,
        widget.long,
      );
    } catch (e) {
      list = null;
    }
    return list;
  }

  List<Widget> buildListTileList(List<Placemark> placemark) {
    List<Widget> tiles = new List<Widget>();
    tiles.addAll([
      buildListTile(
        'Latitudine',
        'Inserisci la latitudine',
        widget.lat.toString(),
        Icon(
          Icons.location_on,
          color: ThemeProvider.themeOf(context).id == "main"
              ? Colors.red[900]
              : Colors.white,
        ),
        (value) {
          if (value.isEmpty) {
            return 'Inserisci un valore';
          } else if (!((double.parse(value) > -90) &&
              (double.parse(value) < 90))) {
            return 'Inserisci una latitudine valida';
          } else
            return null;
        },
        (value) {
          setState(() {
            widget.lat = double.parse(value);
          });
        },
        TextInputType.numberWithOptions(),
      ),
      buildListTile(
        'Longitudine',
        'Inserisci la longitudine',
        widget.long.toString(),
        Icon(
          Icons.location_on,
          color: ThemeProvider.themeOf(context).id == "main"
              ? Colors.red[900]
              : Colors.white,
        ),
        (value) {
          if (value.isEmpty) {
            return 'Inserisci un valore';
          } else if (!((double.parse(value) > -180) &&
              (double.parse(value) < 180))) {
            return 'Inserisci una longitudine valida';
          } else
            return null;
        },
        (value) {
          setState(() {
            widget.long = double.parse(value);
          });
        },
        TextInputType.numberWithOptions(),
      ),
      buildListTile(
        'Città',
        'Inserisci la città',
        (widget.isNewRequest)
            ? ((placemark == null) ? "" : placemark[0].locality)
            : widget.oldHydrant.getCity(),
        Icon(
          Icons.location_city,
          color: ThemeProvider.themeOf(context).id == "main"
              ? Colors.red[900]
              : Colors.white,
        ),
        (value) {
          if (value.isEmpty) {
            return 'Inserisci un valore';
          } else
            return null;
        },
        (value) {
          setState(() {
            widget._city = value;
          });
        },
        TextInputType.text,
      ),
      buildListTile(
        'Via',
        'Inserisci la via',
        (widget.isNewRequest)
            ? ((placemark == null) ? "" : placemark[0].thoroughfare)
            : widget.oldHydrant.getStreet(),
        Icon(
          Icons.nature_people,
          color: ThemeProvider.themeOf(context).id == "main"
              ? Colors.red[900]
              : Colors.white,
        ),
        (value) {
          if (value.isEmpty) {
            return 'Inserisci un valore';
          } else
            return null;
        },
        (value) {
          setState(() {
            widget._street = value;
          });
        },
        TextInputType.text,
      ),
      buildListTile(
        'Numero civico',
        'Inserisci il numero civico',
        (widget.isNewRequest) ? "" : widget.oldHydrant.getNumber(),
        Icon(
          Icons.format_list_numbered,
          color: ThemeProvider.themeOf(context).id == "main"
              ? Colors.red[900]
              : Colors.white,
        ),
        (value) {
          if (value.isEmpty) {
            return 'Inserisci un valore';
          } else
            return null;
        },
        (value) {
          setState(() {
            widget._number = value;
          });
        },
        TextInputType.numberWithOptions(),
      ),
      buildListTile(
        'CAP',
        'Inserisci il CAP',
        (widget.isNewRequest)
            ? ((placemark == null) ? "" : placemark[0].postalCode)
            : widget.oldHydrant.getCap(),
        Icon(
          Icons.grain,
          color: ThemeProvider.themeOf(context).id == "main"
              ? Colors.red[900]
              : Colors.white,
        ),
        (value) {
          if (value.isEmpty) {
            return 'Inserisci un valore';
          } else
            return null;
        },
        (value) {
          setState(() {
            widget._cap = value;
          });
        },
        TextInputType.numberWithOptions(),
      ),
      buildListTile(
        'Note',
        'Inserisci le note',
        (widget.isNewRequest) ? "" : widget.oldHydrant.getNotes(),
        Icon(
          Icons.speaker_notes,
          color: ThemeProvider.themeOf(context).id == "main"
              ? Colors.red[900]
              : Colors.white,
        ),
        (value) {
          if (value.isEmpty) {
            return 'Inserisci un valore';
          } else
            return null;
        },
        (value) {
          setState(() {
            widget._notes = value;
          });
        },
        TextInputType.text,
      ),
      widget._isFireman
          ? SizedBox(
              height: 0,
              width: 0,
            )
          : SizedBox(
              height: 106,
            ),
    ]);
    if (widget._isFireman) {
      tiles.addAll([
        buildListTile(
          'Primo attacco',
          'Inserisci il primo attacco',
          "",
          Icon(
            Icons.looks_one,
            color: ThemeProvider.themeOf(context).id == "main"
                ? Colors.red[900]
                : Colors.white,
          ),
          (value) {
            if (value.isEmpty) {
              return 'Inserisci un valore';
            } else
              return null;
          },
          (value) {
            setState(() {
              widget._firstAttack = value;
            });
          },
          TextInputType.text,
        ),
        buildListTile(
          'Secondo attacco',
          'Inserisci il secondo attacco',
          "",
          Icon(
            Icons.looks_two,
            color: ThemeProvider.themeOf(context).id == "main"
                ? Colors.red[900]
                : Colors.white,
          ),
          (value) {
            if (value.isEmpty) {
              return 'Inserisci un valore';
            } else
              return null;
          },
          (value) {
            setState(() {
              widget._secondAttack = value;
            });
          },
          TextInputType.text,
        ),
        buildListTile(
          'Pressione',
          'Inserisci la pressione',
          "",
          Icon(
            Icons.layers,
            color: ThemeProvider.themeOf(context).id == "main"
                ? Colors.red[900]
                : Colors.white,
          ),
          (value) {
            if (value.isEmpty) {
              return 'Inserisci un valore';
            } else
              return null;
          },
          (value) {
            setState(() {
              widget._pressure = value;
            });
          },
          TextInputType.text,
        ),
        buildListTile(
          'Apertura',
          'Inserisci l\'apertura',
          "",
          Icon(
            Icons.open_in_browser,
            color: ThemeProvider.themeOf(context).id == "main"
                ? Colors.red[900]
                : Colors.white,
          ),
          (value) {
            if (value.isEmpty) {
              return 'Inserisci un valore';
            } else
              return null;
          },
          (value) {
            setState(() {
              widget._opening = value;
            });
          },
          TextInputType.text,
        ),
        buildListTile(
          'Tipo',
          'Inserisci il tipo',
          "",
          Icon(
            Icons.featured_play_list,
            color: ThemeProvider.themeOf(context).id == "main"
                ? Colors.red[900]
                : Colors.white,
          ),
          (value) {
            if (value.isEmpty) {
              return 'Inserisci un valore';
            } else
              return null;
          },
          (value) {
            setState(() {
              widget._type = value;
            });
          },
          TextInputType.text,
        ),
        buildListTile(
          'Colore',
          'Inserisci il colore',
          "",
          Icon(
            Icons.format_paint,
            color: ThemeProvider.themeOf(context).id == "main"
                ? Colors.red[900]
                : Colors.white,
          ),
          (value) {
            if (value.isEmpty) {
              return 'Inserisci un valore';
            } else
              return null;
          },
          (value) {
            setState(() {
              widget._color = value;
            });
          },
          TextInputType.text,
        ),
        buildListTile(
          'Veicolo',
          'Inserisci il veicolo',
          "",
          Icon(
            Icons.rv_hookup,
            color: ThemeProvider.themeOf(context).id == "main"
                ? Colors.red[900]
                : Colors.white,
          ),
          (value) {
            if (value.isEmpty) {
              return 'Inserisci un valore';
            } else
              return null;
          },
          (value) {
            setState(() {
              widget._vehicle = value;
            });
          },
          TextInputType.text,
        ),
        ListTile(
          title: Align(
            alignment: Alignment.centerLeft,
            child: Chip(
              backgroundColor: Colors.white,
              elevation: 12,
              shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.only(
                  topRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              label: Text(
                'Ultimo controllo',
                style: TextStyle(
                  fontFamily: 'Nunito',
                ),
              ),
            ),
          ),
          subtitle: Theme(
            data: ThemeData(
              buttonTheme: ThemeProvider.themeOf(context).data.buttonTheme,
              accentColor: ThemeProvider.themeOf(context).data.accentColor,
              primaryColor: ThemeProvider.themeOf(context).data.primaryColor,
              fontFamily: 'Nunito',
            ),
            child: Material(
              elevation: 12,
              borderRadius: BorderRadius.circular(8.0),
              child: DateTimeField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: ThemeProvider.themeOf(context).id == "main"
                      ? Colors.white
                      : Colors.grey[850],
                  contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                  prefixIcon: Icon(
                    Icons.calendar_today,
                    color: ThemeProvider.themeOf(context).id == "main"
                        ? Colors.red[900]
                        : Colors.white,
                  ),
                  counterStyle: TextStyle(
                    color: ThemeProvider.themeOf(context).id == "main"
                        ? Colors.grey
                        : Colors.white,
                    fontFamily: 'Nunito',
                  ),
                  hintText: 'Inserisci data ultimo controllo',
                  hintStyle: TextStyle(
                    color: ThemeProvider.themeOf(context).id == "main"
                        ? Colors.grey
                        : Colors.white,
                    fontFamily: 'Nunito',
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      style: BorderStyle.none,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      style: BorderStyle.solid,
                      color: Colors.redAccent,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                format: DateFormat("dd-MM-yyyy"),
                onShowPicker: (context, value) {
                  return showDatePicker(
                    context: context,
                    firstDate: DateTime(2000),
                    initialDate: value ?? DateTime.now(),
                    lastDate: DateTime.now(),
                    locale: Locale('it'),
                  );
                },
                validator: (value) {
                  if (value == null) {
                    return 'Inserisci un valore';
                  } else
                    return null;
                },
                onSaved: (value) {
                  setState(() {
                    widget._lastCheck = value;
                  });
                },
              ),
            ),
          ),
        ),
        SizedBox(
          height: 106,
        ),
      ]);
    }
    return tiles;
  }

  ListTile buildListTile(
    String label,
    String hintText,
    String initValue,
    Icon icon,
    Function validator,
    Function onSaved,
    TextInputType textInputType,
  ) {
    return ListTile(
      title: Align(
        alignment: Alignment.centerLeft,
        child: Chip(
          backgroundColor: Colors.white,
          elevation: 12,
          shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.only(
              topRight: Radius.circular(20),
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          label: Text(
            label,
            style: TextStyle(
              fontFamily: 'Nunito',
            ),
          ),
        ),
      ),
      subtitle: Material(
        borderRadius: BorderRadius.circular(8.0),
        elevation: 12,
        child: TextFormField(
          textAlignVertical: TextAlignVertical.center,
          style: TextStyle(
            fontFamily: 'Nunito',
            color: ThemeProvider.themeOf(context).id == "main"
                ? Colors.grey
                : Colors.white,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: ThemeProvider.themeOf(context).id == "main"
                ? Colors.white
                : Colors.grey[850],
            contentPadding: EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 15,
            ),
            prefixIcon: icon,
            counterStyle: TextStyle(
              color: ThemeProvider.themeOf(context).id == "main"
                  ? Colors.grey
                  : Colors.white,
              fontFamily: 'Nunito',
            ),
            hintText: hintText,
            hintStyle: TextStyle(
              color: ThemeProvider.themeOf(context).id == "main"
                  ? Colors.grey
                  : Colors.white,
              fontFamily: 'Nunito',
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                style: BorderStyle.none,
              ),
              borderRadius: BorderRadius.circular(8.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                style: BorderStyle.solid,
                color: Colors.redAccent,
              ),
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          keyboardType: textInputType,
          initialValue: initValue,
          validator: validator,
          onSaved: onSaved,
        ),
      ),
    );
  }

  final _key = GlobalKey<FormState>();
  static TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: FutureBuilder<List<Placemark>>(
        future: getFuturePlacemark(),
        builder: (context, placemark) {
          switch (placemark.connectionState) {
            case ConnectionState.none:
              return new RequestLoading();
            case ConnectionState.active:
            case ConnectionState.waiting:
              return new RequestLoading();
            case ConnectionState.done:
              if (placemark.hasError) return new RequestLoading();
              return FutureBuilder<FirebaseUser>(
                  future: Provider.of<AuthProvider>(context).getUser(),
                  builder: (context, user) {
                    switch (placemark.connectionState) {
                      case ConnectionState.none:
                        return new RequestLoading();
                      case ConnectionState.active:
                      case ConnectionState.waiting:
                        return new RequestLoading();
                      case ConnectionState.done:
                        if (placemark.hasError) return new RequestLoading();
                        return FutureBuilder<bool>(
                          future: Provider.of<DbProvider>(context)
                              .isCurrentUserFireman(user.data),
                          builder: (context, result) {
                            widget._isFireman = result.data;
                            switch (result.connectionState) {
                              case ConnectionState.none:
                                return new RequestLoading();
                              case ConnectionState.active:
                              case ConnectionState.waiting:
                                return new RequestLoading();
                              case ConnectionState.done:
                                if (result.hasError)
                                  return new RequestLoading();
                                return Form(
                                  key: _key,
                                  child: ScrollConfiguration(
                                    behavior: RemoveGlow(),
                                    child: SingleChildScrollView(
                                      child: Column(
                                        children: this
                                            .buildListTileList(placemark.data),
                                      ),
                                    ),
                                  ),
                                );
                            }
                          },
                        );
                    }
                  });
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.done,
        ),
        backgroundColor: Colors.orangeAccent,
        onPressed: () {
          if (_key.currentState.validate()) {
            _key.currentState.save();
            Hydrant newHydrant = widget._isFireman
                ? Hydrant.fromFireman(
                    widget._firstAttack,
                    widget._secondAttack,
                    widget._pressure,
                    widget._cap,
                    widget._city,
                    widget.lat,
                    widget.long,
                    widget._color,
                    widget._lastCheck,
                    widget._notes,
                    widget._opening,
                    widget._street,
                    widget._number,
                    widget._type,
                    widget._vehicle,
                  )
                : Hydrant.fromCitizen(
                    widget._cap,
                    widget._city,
                    widget.lat,
                    widget.long,
                    widget._notes,
                    widget._street,
                    widget._number,
                  );
            Provider.of<AuthProvider>(context).getUser().then((user) {
              if (widget.isNewRequest) {
                Provider.of<DbProvider>(context).addRequest(
                  newHydrant,
                  widget._isFireman,
                  user,
                );
              } else {
                newHydrant.setDBReference(widget.oldHydrant.getDBReference());
                Provider.of<DbProvider>(context)
                    .approveRequest(newHydrant, widget.oldRequest, user);
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              }
            });
            Flushbar(
              flushbarStyle: FlushbarStyle.GROUNDED,
              flushbarPosition: FlushbarPosition.TOP,
              title: "Idrante registrato",
              shouldIconPulse: true,
              message: (widget._isFireman)
                  ? "L'idrante è stato aggiunto con successo alla mappa!"
                  : "La segnalazione dell'idrante è stata effettuata con successo!",
              icon: Icon(
                Icons.check_circle,
                size: 28.0,
                color: Colors.greenAccent,
              ),
              duration: Duration(
                seconds: 4,
              ),
            )..show(context);
            setState(() {});
          } else {
            Flushbar(
              flushbarStyle: FlushbarStyle.GROUNDED,
              flushbarPosition: FlushbarPosition.TOP,
              title: "Compila tutti i campi!",
              shouldIconPulse: true,
              message:
                  "Si prega di compilare tutti i campi affinchè la registazione di un nuovo idrante abbia esito positivo",
              icon: Icon(
                Icons.warning,
                size: 28.0,
                color: Colors.redAccent,
              ),
              duration: Duration(
                seconds: 4,
              ),
            )..show(context);
          }
        },
      ),
    );
  }
}
