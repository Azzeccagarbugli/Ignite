import 'package:flutter/material.dart';
import 'package:theme_provider/theme_provider.dart';

class RequestFormTextListTile extends StatefulWidget {
  String label;
  String hintText;
  String initValue;
  Icon icon;
  Function validator;
  Function onSaved;
  TextInputType textInputType;

  RequestFormTextListTile(
      {@required this.label,
      @required this.hintText,
      @required this.initValue,
      @required this.icon,
      @required this.validator,
      @required this.onSaved,
      @required this.textInputType});
  @override
  _RequestFormTextListTileState createState() =>
      _RequestFormTextListTileState();
}

class _RequestFormTextListTileState extends State<RequestFormTextListTile> {
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
            prefixIcon: widget.icon,
            counterStyle: TextStyle(
              color: ThemeProvider.themeOf(context).id == "main"
                  ? Colors.grey
                  : Colors.white,
              fontFamily: 'Nunito',
            ),
            hintText: widget.hintText,
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
          keyboardType: widget.textInputType,
          initialValue: widget.initValue,
          validator: widget.validator,
          onSaved: widget.onSaved,
        ),
      ),
    );
  }
}
