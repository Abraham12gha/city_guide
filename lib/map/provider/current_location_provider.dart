import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

import '../services/location_service.dart';

final currentLocationProvider =
FutureProvider<Position>((ref) async {
  final service = LocationService();

  return service.getCurrentLocation();
});