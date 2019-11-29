import 'package:cloud_firestore/cloud_firestore.dart';

class Department {
  Department(String ref, String cap, String city, GeoPoint geopoint,
      String mail, String phonenumber, String streetnumber) {
    this._reference = ref;
    this._cap = cap;
    this._city = city;
    this._geopoint = geopoint;
    this._mail = mail;
    this._phoneNumber = phonenumber;
    this._streetNumber = streetnumber;
  }
  String _reference;
  String _cap;
  String _city;
  GeoPoint _geopoint;
  String _mail;
  String _phoneNumber;
  String _streetNumber;

  String getCap() {
    return _cap;
  }

  String getCity() {
    return _city;
  }

  GeoPoint getGeoPoint() {
    return _geopoint;
  }

  String getMail() {
    return _mail;
  }

  String getPhoneNumber() {
    return _phoneNumber;
  }

  String getStreetNumber() {
    return _streetNumber;
  }

  String getDBReference() {
    return _reference;
  }
}
