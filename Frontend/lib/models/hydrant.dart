class Hydrant {
  Hydrant(
      String id,
      String firstAttack,
      String secondAttack,
      String pressure,
      String cap,
      String city,
      double lat,
      double long,
      String color,
      String lastCheck,
      String notes,
      String opening,
      String street,
      String number,
      String type,
      String vehicle) {
    this._id = id;
    this._firstAttack = firstAttack;
    this._secondAttack = secondAttack;
    this._pressure = pressure;
    this._cap = cap;
    this._city = city;
    this._lat = lat;
    this._long = long;
    this._lastCheck = lastCheck;
    this._notes = notes;
    this._opening = opening;
    this._street = street;
    this._number = number;
    this._type = type;
    this._vehicle = vehicle;
    this._color = color;
  }

  Hydrant.fromCitizen(
    String cap,
    String city,
    double lat,
    double long,
    String notes,
    String street,
    String number,
  ) {
    this._id = "";
    this._firstAttack = "";
    this._secondAttack = "";
    this._pressure = "";
    this._cap = cap;
    this._city = city;
    this._lat = lat;
    this._long = long;
    this._lastCheck = DateTime.now().toString();
    this._notes = notes;
    this._opening = "";
    this._street = street;
    this._number = number;
    this._type = "";
    this._vehicle = "";
    this._color = "";
  }

  Hydrant.fromFireman(
      String firstAttack,
      String secondAttack,
      String pressure,
      String cap,
      String city,
      double lat,
      double long,
      String color,
      String lastCheck,
      String notes,
      String opening,
      String street,
      String number,
      String type,
      String vehicle) {
    this._id = "";
    this._firstAttack = firstAttack;
    this._secondAttack = secondAttack;
    this._pressure = pressure;
    this._cap = cap;
    this._city = city;
    this._lat = lat;
    this._long = long;
    this._lastCheck = lastCheck;
    this._notes = notes;
    this._opening = opening;
    this._street = street;
    this._number = number;
    this._type = type;
    this._vehicle = vehicle;
    this._color = color;
  }

  String _id;
  String _firstAttack;
  String _secondAttack;
  String _pressure;
  String _cap;
  String _city;
  double _lat;
  double _long;
  String _color;
  String _lastCheck;
  String _notes;
  String _opening;
  String _street;
  String _number;
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

  double getLat() {
    return _lat;
  }

  double getLong() {
    return _long;
  }

  String getLastCheck() {
    return _lastCheck;
  }

  String getNotes() {
    return _notes;
  }

  String getOpening() {
    return _opening;
  }

  String getStreet() {
    return _street;
  }

  String getNumber() {
    return _number;
  }

  String getType() {
    return _type;
  }

  String getVehicle() {
    return _vehicle;
  }

  String getId() {
    return _id;
  }

  void setId(String id) {
    this._id = id;
  }
}
