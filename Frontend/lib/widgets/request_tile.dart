import 'package:flutter/material.dart';

class RequestTile extends StatelessWidget {
  final String attack1;
  final String attack2;
  final String cap;
  final String city;
  final String color;
  final double geoPointLat;
  final double geoPointLong;
  final DateTime lastChecked;
  final String notes;
  final String opening;
  final String place;
  final String pressure;
  final String streetAndNumber;
  final String type;
  final String vehicle;
  RequestTile(
      {this.attack1,
      this.attack2,
      this.cap,
      this.city,
      this.color,
      this.geoPointLat,
      this.geoPointLong,
      this.lastChecked,
      this.notes,
      this.opening,
      this.place,
      this.pressure,
      this.streetAndNumber,
      this.type,
      this.vehicle});
  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      isThreeLine: true,
      title: Text(type),
      subtitle:
          Text("$city, $streetAndNumber, $cap, $geoPointLat, $geoPointLong"),
      onTap: () {},
    );
  }
}
