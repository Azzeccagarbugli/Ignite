import 'dart:convert';
import '../../apicontrollers/hydrants_apicontroller.dart';
import '../../models/hydrant.dart';
import '../hydrants_services.dart';

class BackendHydrantsServices implements HydrantsServices {
  HydrantsApiController _controller;

  BackendHydrantsServices(String ip) {
    _controller = new HydrantsApiController(ip);
  }

  @override
  Future<List<Hydrant>> getApprovedHydrants() async {
    String controllerJson = await _controller.getApprovedHydrants();
    var parsedJson = json.decode(controllerJson);
    List<Hydrant> hydrants = new List<Hydrant>();
    for (var hydrant in parsedJson) {
      hydrant.add(new Hydrant(
          hydrant["id"],
          hydrant["firstAttack"],
          hydrant["secondAttack"],
          hydrant["pressure"],
          hydrant["cap"],
          hydrant["city"],
          hydrant["geopoint"]["latitude"],
          hydrant["geopoint"]["longitude"],
          hydrant["color"],
          hydrant["lastCheck"],
          hydrant["notes"],
          hydrant["opening"],
          hydrant["streetName"],
          hydrant["streetNumber"],
          hydrant["type"],
          hydrant["vehicle"]));
    }
    return hydrants;
  }

  @override
  Future<Hydrant> getHydrantById(String id) async {
    String controllerJson = await _controller.getHydrantById(id);
    var hydrant = json.decode(controllerJson);
    return new Hydrant(
        hydrant["id"],
        hydrant["firstAttack"],
        hydrant["secondAttack"],
        hydrant["pressure"],
        hydrant["cap"],
        hydrant["city"],
        hydrant["geopoint"]["latitude"],
        hydrant["geopoint"]["longitude"],
        hydrant["color"],
        hydrant["lastCheck"],
        hydrant["notes"],
        hydrant["opening"],
        hydrant["streetName"],
        hydrant["streetNumber"],
        hydrant["type"],
        hydrant["vehicle"]);
  }

  @override
  Future<Hydrant> addHydrant(Hydrant newHydrant) async {
    String controllerJson = await _controller.addHydrant(newHydrant);
    var hydrant = json.decode(controllerJson);
    return new Hydrant(
        hydrant["id"],
        hydrant["firstAttack"],
        hydrant["secondAttack"],
        hydrant["pressure"],
        hydrant["cap"],
        hydrant["city"],
        hydrant["geopoint"]["latitude"],
        hydrant["geopoint"]["longitude"],
        hydrant["color"],
        hydrant["lastCheck"],
        hydrant["notes"],
        hydrant["opening"],
        hydrant["streetName"],
        hydrant["streetNumber"],
        hydrant["type"],
        hydrant["vehicle"]);
  }

  @override
  Future<void> deleteHydrant(String id) async {
    await _controller.deleteHydrant(id);
  }

  @override
  Future<Hydrant> updateHydrant(Hydrant updatedHydrant) async {
    String controllerJson = await _controller.updateHydrant(updatedHydrant);
    var hydrant = json.decode(controllerJson);
    return new Hydrant(
        hydrant["id"],
        hydrant["firstAttack"],
        hydrant["secondAttack"],
        hydrant["pressure"],
        hydrant["cap"],
        hydrant["city"],
        hydrant["geopoint"]["latitude"],
        hydrant["geopoint"]["longitude"],
        hydrant["color"],
        hydrant["lastCheck"],
        hydrant["notes"],
        hydrant["opening"],
        hydrant["streetName"],
        hydrant["streetNumber"],
        hydrant["type"],
        hydrant["vehicle"]);
  }
}
