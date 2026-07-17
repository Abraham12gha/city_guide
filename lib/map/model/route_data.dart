import 'package:latlong2/latlong.dart';

class RouteData {
  final List<LatLng> points;

  final double distanceKm;

  final double durationMinutes;

  const RouteData({
    required this.points,
    required this.distanceKm,
    required this.durationMinutes,
  });
}