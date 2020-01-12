import 'package:url_launcher/url_launcher.dart';

class MapUtils {
  MapUtils._();

  static Future<void> openMap(
      double destinationlatitude,
      double destinationlongitude,
      double originlatitude,
      double originlongitude) async {
    String googleUrl =
        'https://www.google.com/maps/dir/?api=1&origin=$originlatitude,$originlongitude&destination=$destinationlatitude,$destinationlongitude';
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      throw 'Could not open the map.';
    }
  }
}
