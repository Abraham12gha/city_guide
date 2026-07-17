import 'package:geolocator/geolocator.dart';

class LocationService {
  Future<Position> getCurrentLocation() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      throw Exception('LOCATION_DISABLED');
    }

    var permission =
    await Geolocator.checkPermission();

    if (permission ==
        LocationPermission.denied) {
      permission =
      await Geolocator.requestPermission();
    }

    if (permission ==
        LocationPermission.denied ||
        permission ==
            LocationPermission.deniedForever) {
      throw Exception('LOCATION_PERMISSION_DENIED');
    }

    return await Geolocator.getCurrentPosition(
      locationSettings:
      const LocationSettings(
        accuracy: LocationAccuracy.medium,
      ),
    );
  }



  Future<Position?> getLocationIfAvailable() async {

    if (!await Geolocator.isLocationServiceEnabled()) {
      return null;
    }

    var permission =
    await Geolocator.checkPermission();

    if (permission ==
        LocationPermission.denied) {

      permission =
      await Geolocator.requestPermission();
    }

    if (permission ==
        LocationPermission.denied ||
        permission ==
            LocationPermission.deniedForever) {
      return null;
    }

    return Geolocator.getCurrentPosition();
  }
}