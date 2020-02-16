import 'package:ignite/dbrepositories/dbrepository.dart';
import 'package:ignite/factories/controllersfactories/firestorecontrollersfactory.dart';
import 'package:ignite/factories/repositoriesfactories/firestorerepositoriesfactory.dart';
import '../../models/hydrant.dart';
import '../../models/request.dart';
import '../hydrants_controller.dart';

class FirestoreHydrantsController implements HydrantsController {
  DbRepository<Hydrant> _hydrantsServices =
      FirestoreRepositoriesFactory().getHydrantsRepository();

  @override
  Future<List<Hydrant>> getApprovedHydrants() async {
    List<Hydrant> approvedHydrants = new List<Hydrant>();
    List<Request> approvedRequests = await FirestoreControllersFactory()
        .getRequestsController()
        .getApprovedRequests();
    for (Request request in approvedRequests) {
      Hydrant hydrant = await getHydrantById(request.getHydrantId());
      approvedHydrants.add(hydrant);
    }
    return approvedHydrants;
  }

  @override
  Future<Hydrant> getHydrantById(String id) async {
    return await _hydrantsServices.get(id);
  }

  Future<Hydrant> addHydrant(Hydrant newHydrant) async {
    return await _hydrantsServices.insert(newHydrant);
  }

  Future<bool> deleteHydrant(String id) async {
    bool exists = await _hydrantsServices.exists(id);
    if (exists) {
      await _hydrantsServices.delete(id);
      return true;
    } else {
      return false;
    }
  }

  Future<Hydrant> updateHydrant(Hydrant updatedHydrant) async {
    return await _hydrantsServices.update(updatedHydrant);
  }
}
