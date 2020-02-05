import 'package:ignite/dbcontrollers/firebasedbcontrollers/hydrants_firebasecontroller.dart';
import 'package:ignite/factories/controllerfactories/firebasecontrollerfactory.dart';
import 'package:ignite/factories/servicesfactories/firebaseservicesfactory.dart';
import 'package:ignite/models/hydrant.dart';
import 'package:ignite/models/request.dart';
import 'package:ignite/services/hydrants_services.dart';

class FirebaseHydrantsServices implements HydrantsServices {
  FirebaseHydrantsController _hydrantsController =
      FirebaseControllerFactory().getHydrantsController();

  @override
  Future<List<Hydrant>> getApprovedHydrants() async {
    List<Hydrant> approvedHydrants = new List<Hydrant>();
    List<Request> approvedRequests = await FirebaseServicesFactory()
        .getRequestsServices()
        .getApprovedRequests();
    for (Request request in approvedRequests) {
      Hydrant hydrant = await getHydrantById(request.getHydrantId());
      approvedHydrants.add(hydrant);
    }
    return approvedHydrants;
  }

  @override
  Future<Hydrant> getHydrantById(String id) async {
    return await _hydrantsController.get(id);
  }

  @override
  Future<Hydrant> addHydrant(Hydrant newHydrant) {
    return _hydrantsController.insert(newHydrant);
  }

  @override
  Future<bool> deleteHydrant(String id) {
    return _hydrantsController.delete(id);
  }

  @override
  Future<Hydrant> updateHydrant(Hydrant updatedHydrant) {
    return _hydrantsController.update(updatedHydrant);
  }
}
