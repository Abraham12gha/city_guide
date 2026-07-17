import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../model/route_data.dart';
import '../services/location_service.dart';
import '../services/route_service.dart';

class DirectionScreen extends StatefulWidget {
  final String destinationName;

  final double destinationLatitude;

  final double destinationLongitude;

  const DirectionScreen({
    super.key,
    required this.destinationName,
    required this.destinationLatitude,
    required this.destinationLongitude,
  });


  @override
  State<DirectionScreen> createState() => _DirectionScreenState();
}

class _DirectionScreenState extends State<DirectionScreen> {

  String formatDuration(double minutes) {
    final totalMinutes = minutes.round();

    final hours = totalMinutes ~/ 60;

    final remainingMinutes =
        totalMinutes % 60;

    if (hours == 0) {
      return '$remainingMinutes min';
    }

    return '$hours hr $remainingMinutes min';
  }


  final routeService = RouteService();
  final locationService = LocationService();
  RouteData? routeData;
  LatLng? userLocation;
  bool isLoading = true;


  @override
  void initState() {
    super.initState();

    loadRoute();
  }


  Future<void> loadRoute() async {
    try {
      final position =
      await locationService
          .getCurrentLocation();

      final start = LatLng(
        position.latitude,
        position.longitude,
      );

      final end = LatLng(
        widget.destinationLatitude,
        widget.destinationLongitude,
      );

      final route =
      await routeService.getRoute(
        start: start,
        end: end,
      );

      setState(() {
        userLocation = start;

        routeData = route;

        isLoading = false;
      });
    } catch (e) {

      debugPrint(
        'Route Error: $e',
      );

      setState(() {
        isLoading = false;
      });
    }
  }


  @override
  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (routeData == null || userLocation == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            widget.destinationName,
          ),
        ),
        body: const Center(
          child: Text(
            'Unable to load route',
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.destinationName,
        ),
      ),

      body: Stack(
        children: [

          FlutterMap(
            options: MapOptions(
              initialCenter: userLocation!,
              initialZoom: 13,
            ),

            children: [

              TileLayer(
                urlTemplate:
                'https://{s}.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}{r}.png',
                subdomains: const [
                  'a',
                  'b',
                  'c',
                  'd',
                ],
              ),

              PolylineLayer(
                polylines: [
                  Polyline(
                    points: routeData!.points,
                    strokeWidth: 5,
                    color: Colors.blue,
                  ),
                ],
              ),

              MarkerLayer(
                markers: [

                  Marker(
                    point: userLocation!,
                    width: 50,
                    height: 50,
                    child: const Icon(
                      Icons.my_location,
                      color: Colors.blue,
                    ),
                  ),

                  Marker(
                    point: LatLng(
                      widget.destinationLatitude,
                      widget.destinationLongitude,
                    ),
                    width: 50,
                    height: 50,
                    child: const Icon(
                      Icons.location_on,
                      color: Colors.red,
                      size: 40,
                    ),
                  ),
                ],
              ),
            ],
          ),

          Positioned(
            left: 16,
            right: 16,
            bottom: 16,

            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),

                child: Column(
                  mainAxisSize: MainAxisSize.min,

                  children: [

                    Text(
                      'Distance: ${routeData!.distanceKm.toStringAsFixed(
                          1)} km',
                    ),

                    const SizedBox(
                      height: 8,
                    ),

                    Text(
                        'ETA: ${formatDuration(routeData!.durationMinutes)}'
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}