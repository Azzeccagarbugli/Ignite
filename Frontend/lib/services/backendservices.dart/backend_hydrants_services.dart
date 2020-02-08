import '../../models/hydrant.dart';
import '../hydrants_services.dart';

class BackendHydrantsServices implements HydrantsServices {
  String _ip;
  BackendHydrantsServices(String ip) {
    this._ip = ip;
  }

  @override
  Future<List<Hydrant>> getApprovedHydrants() {
    // TODO: implement getApprovedHydrants
    throw UnimplementedError();
  }

  @override
  Future<Hydrant> getHydrantById(String id) {
    // TODO: implement getHydrantById
    throw UnimplementedError();
  }

  @override
  Future<Hydrant> addHydrant(Hydrant newHydrant) {
    // TODO: implement addHydrant
    throw UnimplementedError();
  }

  @override
  Future<void> deleteHydrant(String id) {
    // TODO: implement deleteHydrant
    throw UnimplementedError();
  }

  @override
  Future<Hydrant> updateHydrant(Hydrant updatedHydrant) {
    // TODO: implement updateHydrant
    throw UnimplementedError();
  }
}
