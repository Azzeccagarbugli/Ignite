class Department {
  Department(String ref, String cap, String city, double lat, double long,
      String mail, String phonenumber, String streetnumber) {
    this._reference = ref;
    this._cap = cap;
    this._city = city;
    this._lat = lat;
    this._long = long;
    this._mail = mail;
    this._phoneNumber = phonenumber;
    this._streetNumber = streetnumber;
  }
  String _reference;
  String _cap;
  String _city;
  double _lat;
  double _long;
  String _mail;
  String _phoneNumber;
  String _streetNumber;

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

  String getStreetNumber() {
    return _streetNumber;
  }

  String getDBReference() {
    return _reference;
  }
}
