class User {
  User(
      String ref,
      String mail,
      String birthday,
      String name,
      String surname,
      String streetnumber,
      String cap,
      String department,
      bool isFirstAccess,
      bool isGoogle,
      bool isFacebook,
      bool isFireman) {
    this._reference = ref;
    this._mail = mail;
    this._isFireman = isFireman;
    this._isFirstAccess = isFirstAccess;
    this._birthday = birthday;
    this._name = name;
    this._surname = surname;
    this._streetNumber = streetnumber;
    this._cap = cap;
    this._department = department;
    this._isFacebook = isFacebook;
    this._isGoogle = isGoogle;
  }
  String _reference;
  String _mail;
  bool _isFireman;
  bool _isFirstAccess;
  String _birthday;
  String _name;
  String _surname;
  String _streetNumber;
  String _cap;
  String _department;
  bool _isFacebook;
  bool _isGoogle;
  String getMail() {
    return _mail;
  }

  bool isFireman() {
    return _isFireman;
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

  String getDepartmentReference() {
    return _department;
  }

  String getDBReference() {
    return _reference;
  }
}
