import 'package:ignite/models/userrole.dart';

class User {
  User.fireman(
      String id,
      String mail,
      String birthday,
      String name,
      String surname,
      String streetnumber,
      String cap,
      String departmentId,
      bool isFirstAccess,
      bool isGoogle,
      bool isFacebook) {
    this._id = id;
    this._mail = mail;
    this._role = UserRole.FIREMAN;
    this._isFirstAccess = isFirstAccess;
    this._birthday = birthday;
    this._name = name;
    this._surname = surname;
    this._streetNumber = streetnumber;
    this._cap = cap;
    this._departmentId = departmentId;
    this._isFacebook = isFacebook;
    this._isGoogle = isGoogle;
  }

  User.citizen(String id, String mail, bool isFirstAccess, bool isGoogle,
      bool isFacebook) {
    this._id = id;
    this._mail = mail;
    this._role = UserRole.CITIZEN;
    this._isFirstAccess = isFirstAccess;
    this._birthday = null;
    this._name = null;
    this._surname = null;
    this._streetNumber = null;
    this._cap = null;
    this._departmentId = null;
    this._isFacebook = isFacebook;
    this._isGoogle = isGoogle;
  }

  String _id;
  String _mail;
  UserRole _role;
  bool _isFirstAccess;
  String _birthday;
  String _name;
  String _surname;
  String _streetNumber;
  String _cap;
  String _departmentId;
  bool _isFacebook;
  bool _isGoogle;

  String getMail() {
    return _mail;
  }

  bool isFireman() {
    return _role == UserRole.FIREMAN;
  }

  bool isFacebook() {
    return _isFacebook;
  }

  bool isGoogle() {
    return _isGoogle;
  }

  bool isFirstAccess() {
    return _isFirstAccess;
  }

  void setFirstAccess(bool isFirstAccess) {
    this._isFirstAccess = isFirstAccess;
  }

  String getBirthday() {
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

  String getDepartmentId() {
    return _departmentId;
  }

  String getId() {
    return _id;
  }
}
