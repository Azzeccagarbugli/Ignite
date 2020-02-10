import 'package:ignite/dbrepositories/dbrepository.dart';
import 'package:ignite/dbrepositories/firebasedbcontrollers/firebasedb_values_repository.dart';
import 'package:ignite/factories/repositoriesfactories/firebaserepositoriesfactory.dart';

import '../../models/values.dart';
import '../values_services.dart';

class FirebaseValuesServices implements ValuesServices {
  DbRepository<Values> _valuesController =
      FirebaseRepositoriesFactory().getValuesRepository();

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
