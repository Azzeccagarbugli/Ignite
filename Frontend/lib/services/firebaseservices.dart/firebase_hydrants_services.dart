import 'package:ignite/dbrepositories/dbrepository.dart';
import 'package:ignite/factories/repositoriesfactories/firebaserepositoriesfactory.dart';

import '../../factories/servicesfactories/firebaseservicesfactory.dart';
import '../../models/hydrant.dart';
import '../../models/request.dart';
import '../hydrants_services.dart';

class FirebaseHydrantsServices implements HydrantsServices {
  DbRepository<Hydrant> _hydrantsController =
      FirebaseRepositoriesFactory().getHydrantsRepository();

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

  Future<Hydrant> addHydrant(Hydrant newHydrant) async {
    return await _hydrantsController.insert(newHydrant);
  }

  Future<bool> deleteHydrant(String id) async {
    bool exists = await _hydrantsController.exists(id);
    if (exists) {
      await _hydrantsController.delete(id);
      return true;
    } else {
      return false;
    }
  }

  Future<Hydrant> updateHydrant(Hydrant updatedHydrant) async {
    return await _hydrantsController.update(updatedHydrant);
  }
}
