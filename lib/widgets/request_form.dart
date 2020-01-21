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
import 'package:ignite/widgets/request_form_dropdownlisttile.dart';
import 'package:ignite/widgets/request_form_textlisttile.dart';
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
  bool isNewRequest;
  List<String> _attackValues;
  List<String> _colorValues;
  List<String> _typeValues;
  List<String> _vehicleValues;

  List<String> _openingValues;

  List<String> _pressureValues;
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
  List<Placemark> _placeMarks;
  bool _isFireman;
  FirebaseUser _user;

  Future<List<Placemark>> getFuturePlacemark() async {
    try {
      _placeMarks = await Geolocator().placemarkFromCoordinates(
        widget.lat,
        widget.long,
      );
    } catch (e) {
      _placeMarks = null;
    }
  }

  Future getIsFireman() async {
    _isFireman =
        await Provider.of<DbProvider>(context).isCurrentUserFireman(_user);
  }

  Future getUser() async {
    _user = await Provider.of<AuthProvider>(context).getUser();
  }

  Future initFuture() async {
    await Future.wait([
      this.getFuturePlacemark(),
      this.getUser(),
      this.buildValues(),
    ]);
    await Future.wait([
      this.getIsFireman(),
    ]);
  }

  Future<void> buildValues() async {
    widget._attackValues = await Provider.of<DbProvider>(context).getAttacks();
    widget._colorValues = await Provider.of<DbProvider>(context).getColors();
    widget._typeValues = await Provider.of<DbProvider>(context).getTypes();
    widget._vehicleValues =
        await Provider.of<DbProvider>(context).getVehicles();
    widget._openingValues =
        await Provider.of<DbProvider>(context).getOpenings();
    widget._pressureValues =
        await Provider.of<DbProvider>(context).getPressures();
  }

  List<Widget> buildListTileList(List<Placemark> placemark) {
    List<Widget> tiles = new List<Widget>();
    tiles.addAll([
      RequestFormTextListTile(
        label: 'Latitudine',
        hintText: 'Inserisci la latitudine',
        initValue: widget.lat == null ? "" : widget.lat.toString(),
        icon: Icon(
          Icons.location_on,
          color: ThemeProvider.themeOf(context).id == "main"
              ? Colors.red[900]
              : Colors.white,
        ),
        validator: (value) {
          if (value.isEmpty) {
            return 'Inserisci un valore';
          } else if (!((double.parse(value) > -90) &&
              (double.parse(value) < 90))) {
            return 'Inserisci una latitudine valida';
          } else
            return null;
        },
        onSaved: (value) {
          setState(() {
            widget.lat = double.parse(value);
          });
        },
        textInputType: TextInputType.numberWithOptions(),
      ),
      RequestFormTextListTile(
        label: 'Longitudine',
        hintText: 'Inserisci la longitudine',
        initValue: widget.long == null ? "" : widget.long.toString(),
        icon: Icon(
          Icons.location_on,
          color: ThemeProvider.themeOf(context).id == "main"
              ? Colors.red[900]
              : Colors.white,
        ),
        validator: (value) {
          if (value.isEmpty) {
            return 'Inserisci un valore';
          } else if (!((double.parse(value) > -180) &&
              (double.parse(value) < 180))) {
            return 'Inserisci una longitudine valida';
          } else
            return null;
        },
        onSaved: (value) {
          setState(() {
            widget.long = double.parse(value);
          });
        },
        textInputType: TextInputType.numberWithOptions(),
      ),
      RequestFormTextListTile(
        label: 'Città',
        hintText: 'Inserisci la città',
        initValue: (widget.isNewRequest)
            ? ((placemark == null) ? "" : placemark[0].locality)
            : widget.oldHydrant.getCity(),
        icon: Icon(
          Icons.location_city,
          color: ThemeProvider.themeOf(context).id == "main"
              ? Colors.red[900]
              : Colors.white,
        ),
        validator: (value) {
          if (value.isEmpty) {
            return 'Inserisci un valore';
          } else
            return null;
        },
        onSaved: (value) {
          setState(() {
            widget._city = value;
          });
        },
        textInputType: TextInputType.text,
      ),
      RequestFormTextListTile(
        label: 'Via',
        hintText: 'Inserisci la via',
        initValue: (widget.isNewRequest)
            ? ((placemark == null) ? "" : placemark[0].thoroughfare)
            : widget.oldHydrant.getStreet(),
        icon: Icon(
          Icons.nature_people,
          color: ThemeProvider.themeOf(context).id == "main"
              ? Colors.red[900]
              : Colors.white,
        ),
        validator: (value) {
          if (value.isEmpty) {
            return 'Inserisci un valore';
          } else
            return null;
        },
        onSaved: (value) {
          setState(() {
            widget._street = value;
          });
        },
        textInputType: TextInputType.text,
      ),
      RequestFormTextListTile(
        label: 'Numero civico',
        hintText: 'Inserisci il numero civico',
        initValue: (widget.isNewRequest) ? "" : widget.oldHydrant.getNumber(),
        icon: Icon(
          Icons.format_list_numbered,
          color: ThemeProvider.themeOf(context).id == "main"
              ? Colors.red[900]
              : Colors.white,
        ),
        validator: (value) {
          if (value.isEmpty) {
            return 'Inserisci un valore';
          } else
            return null;
        },
        onSaved: (value) {
          setState(() {
            widget._number = value;
          });
        },
        textInputType: TextInputType.numberWithOptions(),
      ),
      RequestFormTextListTile(
        label: 'CAP',
        hintText: 'Inserisci il CAP',
        initValue: (widget.isNewRequest)
            ? ((placemark == null) ? "" : placemark[0].postalCode)
            : widget.oldHydrant.getCap(),
        icon: Icon(
          Icons.grain,
          color: ThemeProvider.themeOf(context).id == "main"
              ? Colors.red[900]
              : Colors.white,
        ),
        validator: (value) {
          if (value.isEmpty) {
            return 'Inserisci un valore';
          } else
            return null;
        },
        onSaved: (value) {
          setState(() {
            widget._cap = value;
          });
        },
        textInputType: TextInputType.numberWithOptions(),
      ),
      RequestFormTextListTile(
        label: 'Note',
        hintText: 'Inserisci le note',
        initValue: (widget.isNewRequest) ? "" : widget.oldHydrant.getNotes(),
        icon: Icon(
          Icons.speaker_notes,
          color: ThemeProvider.themeOf(context).id == "main"
              ? Colors.red[900]
              : Colors.white,
        ),
        validator: (value) {
          if (value.isEmpty) {
            return 'Inserisci un valore';
          } else
            return null;
        },
        onSaved: (value) {
          setState(() {
            widget._notes = value;
          });
        },
        textInputType: TextInputType.text,
      ),
      _isFireman
          ? SizedBox(
              height: 0,
              width: 0,
            )
          : SizedBox(
              height: 106,
            ),
    ]);
    if (_isFireman) {
      tiles.addAll([
        RequestFormDropDownListTile(
          hintText: "Seleziona il primo attacco",
          label: "Primo Attacco",
          values: widget._attackValues,
          icon: Icon(
            Icons.looks_one,
            color: ThemeProvider.themeOf(context).id == "main"
                ? Colors.red[900]
                : Colors.white,
          ),
          onChangedFunction: (value) {
            widget._firstAttack = value;
          },
        ),
        RequestFormDropDownListTile(
          hintText: "Seleziona il secondo attacco",
          label: "Secondo Attacco",
          values: widget._attackValues,
          icon: Icon(
            Icons.looks_two,
            color: ThemeProvider.themeOf(context).id == "main"
                ? Colors.red[900]
                : Colors.white,
          ),
          onChangedFunction: (value) {
            widget._secondAttack = value;
          },
        ),
        RequestFormDropDownListTile(
          hintText: "Seleziona la pressione",
          label: "Pressione",
          values: widget._pressureValues,
          icon: Icon(
            Icons.layers,
            color: ThemeProvider.themeOf(context).id == "main"
                ? Colors.red[900]
                : Colors.white,
          ),
          onChangedFunction: (value) {
            widget._pressure = value;
          },
        ),
        RequestFormDropDownListTile(
          hintText: "Seleziona l'apertura",
          label: "Apertura",
          values: widget._openingValues,
          icon: Icon(
            Icons.open_in_browser,
            color: ThemeProvider.themeOf(context).id == "main"
                ? Colors.red[900]
                : Colors.white,
          ),
          onChangedFunction: (value) {
            widget._opening = value;
          },
        ),
        RequestFormDropDownListTile(
          hintText: "Seleziona il tipo",
          label: "Tipo",
          values: widget._typeValues,
          icon: Icon(
            Icons.featured_play_list,
            color: ThemeProvider.themeOf(context).id == "main"
                ? Colors.red[900]
                : Colors.white,
          ),
          onChangedFunction: (value) {
            widget._type = value;
          },
        ),
        RequestFormDropDownListTile(
          hintText: "Seleziona il colore",
          label: "Colore",
          values: widget._colorValues,
          icon: Icon(
            Icons.format_paint,
            color: ThemeProvider.themeOf(context).id == "main"
                ? Colors.red[900]
                : Colors.white,
          ),
          onChangedFunction: (value) {
            widget._color = value;
          },
        ),
        RequestFormDropDownListTile(
          hintText: "Seleziona il veicolo",
          label: "Veicolo",
          values: widget._vehicleValues,
          icon: Icon(
            Icons.rv_hookup,
            color: ThemeProvider.themeOf(context).id == "main"
                ? Colors.red[900]
                : Colors.white,
          ),
          onChangedFunction: (value) {
            widget._vehicle = value;
          },
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
          height: 75,
        ),
      ]);
    }
    return tiles;
  }

  final _key = GlobalKey<FormState>();
  static TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: FutureBuilder(
        future: this.initFuture(),
        builder: (context, result) {
          switch (result.connectionState) {
            case ConnectionState.none:
              return new LoadingShimmer();
            case ConnectionState.active:
            case ConnectionState.waiting:
              return new LoadingShimmer();
            case ConnectionState.done:
              return Form(
                key: _key,
                child: ScrollConfiguration(
                  behavior: RemoveGlow(),
                  child: SingleChildScrollView(
                    child: Column(
                      children: this.buildListTileList(_placeMarks),
                    ),
                  ),
                ),
              );
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
            Hydrant newHydrant = _isFireman
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
                  _isFireman,
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
              message: (_isFireman)
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
