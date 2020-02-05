import 'package:ignite/models/hydrant.dart';

abstract class HydrantsServices {
  Future<List<Hydrant>> getApprovedHydrants();
  Future<Hydrant> getHydrantById(String id);
  Future<Hydrant> addHydrant(Hydrant newHydrant);
  Future<Hydrant> updateHydrant(Hydrant updatedHydrant);
  Future<bool> deleteHydrant(String id);
}
