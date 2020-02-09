import '../../dbcontrollers/firebasedbcontrollers/hydrants_firebasecontroller.dart';
import '../../factories/servicesfactories/firebaseservicesfactory.dart';
import '../../models/hydrant.dart';
import '../../models/request.dart';
import '../hydrants_services.dart';

class FirebaseHydrantsServices implements HydrantsServices {
  FirebaseHydrantsController _hydrantsController =
      new FirebaseHydrantsController();

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

  Future<Hydrant> addHydrant(Hydrant newHydrant) {
    return _hydrantsController.insert(newHydrant);
  }

  Future<bool> deleteHydrant(String id) {
    return _hydrantsController.delete(id);
  }

  Future<Hydrant> updateHydrant(Hydrant updatedHydrant) {
    return _hydrantsController.update(updatedHydrant);
  }
}
