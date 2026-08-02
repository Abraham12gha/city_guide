import 'package:geocoding/geocoding.dart';
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


  final geocoding = Geocoding();
  Future<Position?> getLocationIfAvailable() async {

    if (!await Geolocator.isLocationServiceEnabled()) {
      return null;
    }

    var permission =
    await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {

      permission = await Geolocator.requestPermission();
    }

    if (permission ==
        LocationPermission.denied ||
        permission ==
            LocationPermission.deniedForever) {
      return null;
    }

    return Geolocator.getCurrentPosition();
  }




  Future<String?> getCurrentCity() async {
    final position = await getLocationIfAvailable();

    if (position == null) {
      return null;
    }

    final placemarks = await geocoding.placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    if (placemarks.isEmpty) {
      return null;
    }

    final place = placemarks.first;

    final city = place.locality?.trim();
    final country = place.country?.trim();

    if (city == null || city.isEmpty) {
      return country;
    }

    return "$city, $country";
  }
}