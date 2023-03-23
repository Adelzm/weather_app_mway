import 'package:geolocator/geolocator.dart';

class GeolocatorService {
  Future<String?> getPermission() async {
    bool serviceEnabled = false;
    LocationPermission? permission;

    // Check if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      throw Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return null;
  }

  Future<Position?> getCurrentLocation() async {
    try {
      String? permission = await getPermission();
      if (permission == null) {
        Position position =
          await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.low);
      return position;
      }
      throw Future.error(permission);
      
    } catch (e) {
     throw Future.error(e.toString());
    }
  }
}
