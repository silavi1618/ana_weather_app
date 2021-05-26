import 'package:geolocator/geolocator.dart';

class LocationService {

  LocationService() {}

  static Future<Position> getUserLocation() async {
    try {
      bool serviceEnabled;
      LocationPermission permission;

      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return Future.error('Location services are disabled.');
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return Future.error('Location permissions are denied');
        }
      }
      
      if (permission == LocationPermission.deniedForever) {
        return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
      } 

      return await Geolocator.getCurrentPosition();
    } on Exception catch (_) {
      return Future.error(_);
    }
    
    return Future.error(
          "Error");
  }
}
