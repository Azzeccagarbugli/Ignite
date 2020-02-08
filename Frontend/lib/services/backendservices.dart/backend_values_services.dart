import 'dart:convert';
import '../../apicontrollers/values_controller.dart';
import '../values_services.dart';

class BackendValuesServices implements ValuesServices {
  ValuesApiController _controller;

  BackendValuesServices(String ip) {
    _controller = new ValuesApiController(ip);
  }

  @override
  Future<List<String>> getAttacks() async {
    String controllerJson = await _controller.getAttacks();
    var parsedJson = json.decode(controllerJson);
    List<String> attacks = new List<String>();
    for (String val in parsedJson["values"]) {
      attacks.add(val);
    }
    return attacks;
  }

  @override
  Future<List<String>> getColors() async {
    String controllerJson = await _controller.getColors();
    var parsedJson = json.decode(controllerJson);
    List<String> colors = new List<String>();
    for (String val in parsedJson["values"]) {
      colors.add(val);
    }
    return colors;
  }

  @override
  Future<List<String>> getOpenings() async {
    String controllerJson = await _controller.getOpenings();
    var parsedJson = json.decode(controllerJson);
    List<String> openings = new List<String>();
    for (String val in parsedJson["values"]) {
      openings.add(val);
    }
    return openings;
  }

  @override
  Future<List<String>> getPressures() async {
    String controllerJson = await _controller.getPressures();
    var parsedJson = json.decode(controllerJson);
    List<String> pressures = new List<String>();
    for (String val in parsedJson["values"]) {
      pressures.add(val);
    }
    return pressures;
  }

  @override
  Future<List<String>> getTypes() async {
    String controllerJson = await _controller.getTypes();
    var parsedJson = json.decode(controllerJson);
    List<String> types = new List<String>();
    for (String val in parsedJson["values"]) {
      types.add(val);
    }
    return types;
  }

  @override
  Future<List<String>> getVehicles() async {
    String controllerJson = await _controller.getVehicles();
    var parsedJson = json.decode(controllerJson);
    List<String> vehicles = new List<String>();
    for (String val in parsedJson["values"]) {
      vehicles.add(val);
    }
    return vehicles;
  }
}
