import '../models/hydrant.dart';

abstract class HydrantsServices {
  Future<List<Hydrant>> getApprovedHydrants();
  Future<Hydrant> getHydrantById(String id);
}
