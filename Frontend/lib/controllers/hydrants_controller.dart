import '../models/hydrant.dart';

abstract class HydrantsController {
  Future<List<Hydrant>> getApprovedHydrants();
  Future<Hydrant> getHydrantById(String id);
  Future<Hydrant> addHydrant(Hydrant newHydrant);
  Future<Hydrant> updateHydrant(Hydrant updatedHydrant);
  Future<void> deleteHydrant(String id);
}
