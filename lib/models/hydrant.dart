import 'package:cloud_firestore/cloud_firestore.dart';

class Hydrant {
  Hydrant(
      String ref,
      String firstAttack,
      String secondAttack,
      String pressure,
      String cap,
      String city,
      GeoPoint geoPoint,
      String color,
      Timestamp lastCheck,
      String notes,
      String opening,
      String place,
      String streetNumber,
      String type,
      String vehicle) {
    this._reference = ref;
    this._firstAttack = firstAttack;
    this._secondAttack = secondAttack;
    this._pressure = pressure;
    this._cap = cap;
    this._city = city;
    this._geoPoint = geoPoint;
    this._lastCheck = lastCheck;
    this._notes = notes;
    this._opening = opening;
    this._place = place;
    this._streetNumber = streetNumber;
    this._type = type;
    this._vehicle = vehicle;
    this._color = color;
  }
  String _reference;

  String _firstAttack;
  String _secondAttack;
  String _pressure;
  String _cap;
  String _city;
  GeoPoint _geoPoint;
  String _color;
  Timestamp _lastCheck;
  String _notes;
  String _opening;
  String _place;
  String _streetNumber;
  String _type;
  String _vehicle;

  String getColor() {
    return _color;
  }

  String getFirstAttack() {
    return _firstAttack;
  }

  String getSecondAttack() {
    return _secondAttack;
  }

  String getPressure() {
    return _pressure;
  }

  String getCap() {
    return _cap;
  }

  String getCity() {
    return _city;
  }

  GeoPoint getGeoPoint() {
    return _geoPoint;
  }

  Timestamp getLastCheck() {
    return _lastCheck;
  }

  String getNotes() {
    return _notes;
  }

  String getOpening() {
    return _opening;
  }

  String getPlace() {
    return _place;
  }

  String getStreetNumber() {
    return _streetNumber;
  }

  String getType() {
    return _type;
  }

  String getVehicle() {
    return _vehicle;
  }

  String getDBReference() {
    return _reference;
  }
}
