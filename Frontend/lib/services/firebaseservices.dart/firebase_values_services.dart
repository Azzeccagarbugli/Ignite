import 'package:ignite/dbcontrollers/firebasedbcontrollers/values_firebasecontroller.dart';
import 'package:ignite/factories/controllerfactories/firebasecontrollerfactory.dart';
import 'package:ignite/models/values.dart';
import 'package:ignite/services/values_services.dart';

class FirebaseValuesServices implements ValuesServices {
  FirebaseValuesController _valuesController =
      FirebaseControllerFactory().getValuesController();

  Future<List<String>> _getEnumByName(String name) async {
    List<Values> valueList = await _valuesController.getAll();
    for (Values value in valueList) {
      if (value.getName() == name) return value.getValues();
    }
    return List<String>();
  }

  @override
  Future<List<String>> getColors() async {
    return _getEnumByName('color');
  }

  @override
  Future<List<String>> getAttacks() async {
    return _getEnumByName('attack');
  }

  @override
  Future<List<String>> getOpenings() async {
    return _getEnumByName('opening');
  }

  @override
  Future<List<String>> getVehicles() async {
    return _getEnumByName('vehicle');
  }

  @override
  Future<List<String>> getTypes() async {
    return _getEnumByName('type');
  }

  @override
  Future<List<String>> getPressures() async {
    return _getEnumByName('pressure');
  }
}
