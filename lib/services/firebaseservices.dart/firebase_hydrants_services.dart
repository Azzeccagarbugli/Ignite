import 'package:ignite/dbcontrollers/firebasedbcontrollers/hydrants_firebasecontroller.dart';
import 'package:ignite/factories/controllerfactories/firebasecontrollerfactory.dart';
import 'package:ignite/factories/servicesfactories/firebaseservicesfactory.dart';
import 'package:ignite/models/hydrant.dart';
import 'package:ignite/models/request.dart';
import 'package:ignite/services/firebaseservices.dart/firebase_requests_services.dart';
import 'package:ignite/services/hydrants_services.dart';

class FirebaseHydrantsServices implements HydrantsServices {
  FirebaseHydrantsController _hydrantsController =
      FirebaseControllerFactory().getHydrantsController();
  FirebaseRequestsServices _requestsServices =
      FirebaseServicesFactory().getRequestsServices();

  @override
  Future<List<Hydrant>> getApprovedHydrants() async {
    print("SASSI");
    List<Hydrant> approvedHydrants = new List<Hydrant>();
    List<Request> approvedRequests =
        await _requestsServices.getApprovedRequests();
    print("VUOTO ${approvedRequests.isEmpty}");
    for (Request request in approvedRequests) {
      print("RICHIESTA ${request.getId()}");
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
