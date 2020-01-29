import 'package:ignite/services/values_services.dart';

class BackendValuesServices implements ValuesServices {
  String _ip;
  BackendValuesServices(String ip) {
    this._ip = ip;
  }
  @override
  Future<List<String>> getAttacks() {
    // TODO: implement getAttacks
    throw UnimplementedError();
  }

  @override
  Future<List<String>> getColors() {
    // TODO: implement getColors
    throw UnimplementedError();
  }

  @override
  Future<List<String>> getOpenings() {
    // TODO: implement getOpenings
    throw UnimplementedError();
  }

  @override
  Future<List<String>> getPressures() {
    // TODO: implement getPressures
    throw UnimplementedError();
  }

  @override
  Future<List<String>> getTypes() {
    // TODO: implement getTypes
    throw UnimplementedError();
  }

  @override
  Future<List<String>> getVehicles() {
    // TODO: implement getVehicles
    throw UnimplementedError();
  }
}
