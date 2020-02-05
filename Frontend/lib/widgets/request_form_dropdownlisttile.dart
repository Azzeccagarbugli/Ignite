import 'package:flutter/material.dart';
import 'package:theme_provider/theme_provider.dart';

class RequestFormDropDownListTile extends StatefulWidget {
  String label;
  String hintText;
  List<String> values;
  Function onChangedFunction;
  Icon icon;
  String _value;
  RequestFormDropDownListTile({
    @required this.label,
    @required this.values,
    @required this.onChangedFunction,
    @required this.icon,
    @required this.hintText,
  });
  @override
  _RequestFormDropDownListTileState createState() =>
      _RequestFormDropDownListTileState();
}

class _RequestFormDropDownListTileState
    extends State<RequestFormDropDownListTile> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget._value = widget.values[0];
    widget.onChangedFunction(widget.values[0]);
  }

  @override
  Widget build(BuildContext context) {
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
            widget.label,
            style: TextStyle(
              fontFamily: 'Nunito',
            ),
          ),
        ),
      ),
      subtitle: Material(
        borderRadius: BorderRadius.circular(8.0),
        elevation: 12,
        child: Theme(
          data: Theme.of(context).copyWith(
            canvasColor: ThemeProvider.themeOf(context).id == "main"
                ? Colors.white
                : Colors.grey[900],
          ),
          child: DropdownButtonFormField(
            value: widget._value,
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
              prefixIcon: widget.icon,
              counterStyle: TextStyle(
                color: ThemeProvider.themeOf(context).id == "main"
                    ? Colors.grey
                    : Colors.white,
                fontFamily: 'Nunito',
              ),
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
            onChanged: (value) {
              setState(() {
                widget._value = value;
                widget.onChangedFunction(value);
              });
            },
            items: widget.values.map((String value) {
              return new DropdownMenuItem<String>(
                value: value,
                child: new Text(
                  value,
                  style: TextStyle(
                    color: ThemeProvider.themeOf(context).id == "main"
                        ? Colors.grey
                        : Colors.white,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class RequestFormDropDownButton extends StatefulWidget {
  List<String> values;
  String _value;
  Function onChangedFunction;
  Icon icon;
  RequestFormDropDownButton(
      {@required this.values,
      @required this.onChangedFunction,
      @required this.icon});
  @override
  _RequestFormDropDownButtonState createState() =>
      _RequestFormDropDownButtonState();
}

class _RequestFormDropDownButtonState extends State<RequestFormDropDownButton> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget._value = widget.values[0];
    widget.onChangedFunction(widget.values[0]);
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      isExpanded: true,
      value: widget._value,
      onChanged: (value) {
        setState(() {
          widget._value = value;
          widget.onChangedFunction(value);
        });
      },
      items: widget.values.map((String value) {
        return new DropdownMenuItem<String>(
          value: value,
          child: new Text(
            value,
            style: TextStyle(
              color: ThemeProvider.themeOf(context).id == "main"
                  ? Colors.grey
                  : Colors.white,
            ),
          ),
        );
      }).toList(),
    );
  }
}
