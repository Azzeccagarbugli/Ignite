class Department {
  Department(String ref, String cap, String city, double lat, double long,
      String mail, String phonenumber, String street, String number) {
    this._reference = ref;
    this._cap = cap;
    this._city = city;
    this._lat = lat;
    this._long = long;
    this._mail = mail;
    this._phoneNumber = phonenumber;
    this._street = street;
    this._number = number;
  }
  String _reference;
  String _cap;
  String _city;
  double _lat;
  double _long;
  String _mail;
  String _phoneNumber;
  String _street;
  String _number;

  String getCap() {
    return _cap;
  }

  String getCity() {
    return _city;
  }

  double getLat() {
    return _lat;
  }

  double getLong() {
    return _long;
  }

  String getMail() {
    return _mail;
  }

  String getPhoneNumber() {
    return _phoneNumber;
  }

  String getStreet() {
    return _street;
  }

  String getNumber() {
    return _number;
  }

  String getDBReference() {
    return _reference;
  }
}
