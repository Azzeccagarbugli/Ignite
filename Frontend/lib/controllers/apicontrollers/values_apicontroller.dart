import 'dart:convert';
import 'package:ignite/backendservices/backend_values_services.dart';
import '../values_controller.dart';

class ValuesApiController implements ValuesController {
  BackendValuesServices _services;

  ValuesApiController(String ip) {
    _services = new BackendValuesServices(ip);
  }

  @override
  Future<List<String>> getAttacks() async {
    String controllerJson = await _services.getAttacks();
    var parsedJson = json.decode(controllerJson);
    List<String> attacks = new List<String>();
    for (String val in parsedJson) {
      attacks.add(val);
    }
    return attacks;
  }

  @override
  Future<List<String>> getColors() async {
    String controllerJson = await _services.getColors();
    var parsedJson = json.decode(controllerJson);
    List<String> colors = new List<String>();
    for (String val in parsedJson) {
      colors.add(val);
    }
    return colors;
  }

  @override
  Future<List<String>> getOpenings() async {
    String controllerJson = await _services.getOpenings();
    var parsedJson = json.decode(controllerJson);
    List<String> openings = new List<String>();
    for (String val in parsedJson) {
      openings.add(val);
    }
    return openings;
  }

  @override
  Future<List<String>> getPressures() async {
    String controllerJson = await _services.getPressures();
    var parsedJson = json.decode(controllerJson);
    List<String> pressures = new List<String>();
    for (String val in parsedJson) {
      pressures.add(val);
    }
    return pressures;
  }

  @override
  Future<List<String>> getTypes() async {
    String controllerJson = await _services.getTypes();
    var parsedJson = json.decode(controllerJson);
    List<String> types = new List<String>();
    for (String val in parsedJson) {
      types.add(val);
    }
    return types;
  }

  @override
  Future<List<String>> getVehicles() async {
    String controllerJson = await _services.getVehicles();
    var parsedJson = json.decode(controllerJson);
    List<String> vehicles = new List<String>();
    for (String val in parsedJson) {
      vehicles.add(val);
    }
    return vehicles;
  }
}
