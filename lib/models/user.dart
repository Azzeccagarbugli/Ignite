import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  User.onlyMail(String mail) {
    this._mail = mail;
    this._isFireman = false;
  }
  User(String ref, String mail, DateTime birthday, String name, String surname,
      String streetnumber, String cap, String department) {
    this._reference = ref;
    this._mail = mail;
    this._isFireman = true;
    this._birthday = birthday;
    this._name = name;
    this._surname = surname;
    this._streetNumber = streetnumber;
    this._cap = cap;
    this._department = department;
  }
  String _reference;
  String _mail;
  bool _isFireman;
  DateTime _birthday;
  String _name;
  String _surname;
  String _streetNumber;
  String _cap;
  String _department;

  String getMail() {
    return _mail;
  }

  bool isFireman() {
    return _isFireman;
  }

  DateTime getBirthday() {
    return _birthday;
  }

  String getName() {
    return _name;
  }

  String getSurname() {
    return _surname;
  }

  String getStreetNumber() {
    return _streetNumber;
  }

  String getCap() {
    return _cap;
  }

  String getDepartmentReference() {
    return _department;
  }

  String getDBReference() {
    return _reference;
  }
}
