class Values {
  String _name;
  List<String> _values;
  String _id;
  Values(String id, String name, List<String> values) {
    this._id = id;
    this._name = name;
    this._values = values;
  }

  String getId() {
    return _id;
  }

  String getName() {
    return _name;
  }

  List<String> getValues() {
    return _values;
  }
}
