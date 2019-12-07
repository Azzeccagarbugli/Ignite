import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ignite/models/hydrant.dart';
import 'package:ignite/widgets/rounded_button_options.dart';
import 'package:place_picker/place_picker.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:ignite/models/app_state.dart';
import 'package:provider/provider.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';

const apiKey = "AIzaSyDXxmocq4KQWmghOamTeNod-ccg5U1w5M4";

class NewRequestScreen extends StatefulWidget {
  LatLng position;
  NewRequestScreen({
    @required this.position,
  });
  @override
  _NewRequestScreenState createState() => _NewRequestScreenState();
}

class _NewRequestScreenState extends State<NewRequestScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void showPlacePicker() async {
    LocationResult result = await Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => PlacePicker(apiKey)));
    setState(() {
      widget.position = result.latLng;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeProvider.themeOf(context).data.accentColor,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            RoundedButtonOptions(
                context: context,
                text: "Utilizza la posizione corrente",
                function: () async {
                  Position position = await Geolocator().getCurrentPosition(
                      desiredAccuracy: LocationAccuracy.high);
                  setState(() {
                    widget.position =
                        LatLng(position.latitude, position.longitude);
                  });
                }),
            /* RoundedButtonOptions(
                context: context,
                text: "Definisci le coordinate",
                function: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return CustomLatLngFormDialog(
                          updatePosition: (lat, lng) {
                            setState(() {
                              widget.position = LatLng(lat, lng);
                            });
                          },
                        );
                      });
                }),*/
            Flexible(
              child: RequestForm(
                lat: widget.position.latitude,
                long: widget.position.longitude,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RequestCircularLoading extends StatelessWidget {
  const RequestCircularLoading({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: CircularProgressIndicator(
      valueColor: new AlwaysStoppedAnimation<Color>(
          ThemeProvider.themeOf(context).data.primaryColor),
    ));
  }
}

class RequestForm extends StatefulWidget {
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
  String _place;
  String _street;
  String _number;
  String _type;
  String _vehicle;
  bool _isFireman;
  RequestForm({@required this.lat, @required this.long});

  @override
  _RequestFormState createState() => _RequestFormState();
}

class _RequestFormState extends State<RequestForm> {
  Future<List<Placemark>> getFuturePlacemark() async {
    List<Placemark> list;
    try {
      list =
          await Geolocator().placemarkFromCoordinates(widget.lat, widget.long);
    } catch (e) {
      list = null;
    }
    return list;
  }

  List<Widget> buildListTileList(List<Placemark> placemark) {
    List<Widget> tiles = new List<Widget>();
    tiles.addAll([
      ListTile(
        title: Text("Latitudine"),
        subtitle: TextFormField(
          keyboardType: TextInputType.numberWithOptions(),
          initialValue: widget.lat.toString(),
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
        ),
      ),
      ListTile(
        title: Text("Longitudine"),
        subtitle: TextFormField(
          keyboardType: TextInputType.numberWithOptions(),
          initialValue: widget.long.toString(),
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
        ),
      ),
      ListTile(
        title: Text("Città"),
        subtitle: TextFormField(
          initialValue: (placemark == null) ? "" : placemark[0].locality,
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
        ),
      ),
      ListTile(
        title: Text("Via"),
        subtitle: TextFormField(
          initialValue: (placemark == null) ? "" : placemark[0].thoroughfare,
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
        ),
      ),
      ListTile(
        title: Text("Numero civico"),
        subtitle: TextFormField(
          initialValue: (placemark == null) ? "" : placemark[0].name,
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
        ),
      ),
      ListTile(
        title: Text("CAP"),
        subtitle: TextFormField(
          keyboardType: TextInputType.numberWithOptions(),
          initialValue: (placemark == null) ? "" : placemark[0].postalCode,
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
        ),
      ),
      ListTile(
        title: Text("Indicazioni spaziali"),
        subtitle: TextFormField(
          validator: (value) {
            if (value.isEmpty) {
              return 'Inserisci un valore';
            } else
              return null;
          },
          onSaved: (value) {
            setState(() {
              widget._place = value;
            });
          },
        ),
      ),
      ListTile(
        title: Text("Note"),
        subtitle: TextFormField(
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
        ),
      ),
    ]);
    if (widget._isFireman) {
      tiles.addAll([
        ListTile(
          title: Text("Primo attacco"),
          subtitle: TextFormField(
            validator: (value) {
              if (value.isEmpty) {
                return 'Inserisci un valore';
              } else
                return null;
            },
            onSaved: (value) {
              setState(() {
                widget._firstAttack = value;
              });
            },
          ),
        ),
        ListTile(
          title: Text("Secondo attacco"),
          subtitle: TextFormField(
            validator: (value) {
              if (value.isEmpty) {
                return 'Inserisci un valore';
              } else
                return null;
            },
            onSaved: (value) {
              setState(() {
                widget._secondAttack = value;
              });
            },
          ),
        ),
        ListTile(
          title: Text("Pressione"),
          subtitle: TextFormField(
            validator: (value) {
              if (value.isEmpty) {
                return 'Inserisci un valore';
              } else
                return null;
            },
            onSaved: (value) {
              setState(() {
                widget._pressure = value;
              });
            },
          ),
        ),
        ListTile(
          title: Text("Apertura"),
          subtitle: TextFormField(
            validator: (value) {
              if (value.isEmpty) {
                return 'Inserisci un valore';
              } else
                return null;
            },
            onSaved: (value) {
              setState(() {
                widget._opening = value;
              });
            },
          ),
        ),
        ListTile(
          title: Text("Tipo"),
          subtitle: TextFormField(
            validator: (value) {
              if (value.isEmpty) {
                return 'Inserisci un valore';
              } else
                return null;
            },
            onSaved: (value) {
              setState(() {
                widget._type = value;
              });
            },
          ),
        ),
        ListTile(
          title: Text("Colore"),
          subtitle: TextFormField(
            validator: (value) {
              if (value.isEmpty) {
                return 'Inserisci un valore';
              } else
                return null;
            },
            onSaved: (value) {
              setState(() {
                widget._color = value;
              });
            },
          ),
        ),
        ListTile(
          title: Text("Veicolo"),
          subtitle: TextFormField(
            validator: (value) {
              if (value.isEmpty) {
                return 'Inserisci un valore';
              } else
                return null;
            },
            onSaved: (value) {
              setState(() {
                widget._vehicle = value;
              });
            },
          ),
        ),
        ListTile(
          title: Text("Ultimo controllo"),
          subtitle: DateTimeField(
            keyboardType: TextInputType.numberWithOptions(),
            format: DateFormat("dd-MM-yyyy"),
            onShowPicker: (context, value) {
              return showDatePicker(
                context: context,
                firstDate: DateTime(2000),
                initialDate: value ?? DateTime.now(),
                lastDate: DateTime.now(),
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
      ]);
    }
    return tiles;
  }

  final _key = GlobalKey<FormState>();
  final TextEditingController textController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: FutureBuilder<List<Placemark>>(
        future: getFuturePlacemark(),
        builder: (context, placemark) {
          switch (placemark.connectionState) {
            case ConnectionState.none:
              return new RequestCircularLoading();
            case ConnectionState.active:
            case ConnectionState.waiting:
              return new RequestCircularLoading();
            case ConnectionState.done:
              if (placemark.hasError) return new RequestCircularLoading();
              return FutureBuilder<bool>(
                future: Provider.of<AppState>(context).isCurrentUserFireman(),
                builder: (context, result) {
                  widget._isFireman = result.data;

                  switch (result.connectionState) {
                    case ConnectionState.none:
                      return new RequestCircularLoading();
                    case ConnectionState.active:
                    case ConnectionState.waiting:
                      return new RequestCircularLoading();
                    case ConnectionState.done:
                      if (result.hasError) return new RequestCircularLoading();

                      return Form(
                        key: _key,
                        child: GlowingOverscrollIndicator(
                          color:
                              ThemeProvider.themeOf(context).data.primaryColor,
                          axisDirection: AxisDirection.down,
                          child: SingleChildScrollView(
                            child: Column(
                              children: this.buildListTileList(placemark.data),
                            ),
                          ),
                        ),
                      );
                  }
                },
              );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.done),
        backgroundColor: ThemeProvider.themeOf(context).data.primaryColor,
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
                    widget._place,
                    "${widget._street}, ${widget._number}",
                    widget._type,
                    widget._vehicle)
                : Hydrant.fromCitizen(
                    widget._cap,
                    widget._city,
                    widget.lat,
                    widget.long,
                    widget._notes,
                    widget._place,
                    "${widget._street}, ${widget._number}");
            Provider.of<AppState>(context)
                .addRequest(newHydrant, widget._isFireman);
            setState(() {});
          }
        },
      ),
    );
  }
}

/*class CustomLatLngFormDialog extends StatefulWidget {
  Function updatePosition;
  CustomLatLngFormDialog({@required this.updatePosition});

  @override
  _CustomLatLngFormDialogState createState() => _CustomLatLngFormDialogState();
}

class _CustomLatLngFormDialogState extends State<CustomLatLngFormDialog> {
  final _key = GlobalKey<FormState>();
  double _lat;
  double _long;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Definisci le coordinate"),
      content: Form(
        key: _key,
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text("Latitudine"),
              subtitle: TextFormField(
                keyboardType: TextInputType.numberWithOptions(),
                initialValue: '00.000000',
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
                    _lat = double.parse(value);
                  });
                },
              ),
            ),
            ListTile(
              title: Text("Longitudine"),
              subtitle: TextFormField(
                keyboardType: TextInputType.numberWithOptions(),
                initialValue: '000.000000',
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
                    _long = double.parse(value);
                  });
                },
              ),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text('Annulla'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        FlatButton(
          child: Text('Conferma'),
          onPressed: () {
            if (_key.currentState.validate()) {
              _key.currentState.save();
              widget.updatePosition(_lat, _long);
              Navigator.pop(context);
            }
          },
        ),
      ],
    );
  }
}*/
