// import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:latlong2/latlong.dart';
// import '../model/route_data.dart';
// import '../services/location_service.dart';
// import '../services/route_service.dart';
//
// class DirectionScreen extends StatefulWidget {
//   final String destinationName;
//
//   final double destinationLatitude;
//
//   final double destinationLongitude;
//
//   const DirectionScreen({
//     super.key,
//     required this.destinationName,
//     required this.destinationLatitude,
//     required this.destinationLongitude,
//   });
//
//
//   @override
//   State<DirectionScreen> createState() => _DirectionScreenState();
// }
//
// class _DirectionScreenState extends State<DirectionScreen> {
//
//   String formatDuration(double minutes) {
//     final totalMinutes = minutes.round();
//
//     final hours = totalMinutes ~/ 60;
//
//     final remainingMinutes =
//         totalMinutes % 60;
//
//     if (hours == 0) {
//       return '$remainingMinutes min';
//     }
//
//     return '$hours hr $remainingMinutes min';
//   }
//
//
//   final routeService = RouteService();
//   final locationService = LocationService();
//   RouteData? routeData;
//   LatLng? userLocation;
//   bool isLoading = true;
//
//
//   @override
//   void initState() {
//     super.initState();
//
//     loadRoute();
//   }
//
//
//   Future<void> loadRoute() async {
//     try {
//       final position =
//       await locationService
//           .getCurrentLocation();
//
//       final start = LatLng(
//         position.latitude,
//         position.longitude,
//       );
//
//       final end = LatLng(
//         widget.destinationLatitude,
//         widget.destinationLongitude,
//       );
//
//       final route =
//       await routeService.getRoute(
//         start: start,
//         end: end,
//       );
//
//       setState(() {
//         userLocation = start;
//
//         routeData = route;
//
//         isLoading = false;
//       });
//     } catch (e) {
//
//       debugPrint(
//         'Route Error: $e',
//       );
//
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }
//
//
//   @override
//   @override
//   Widget build(BuildContext context) {
//     if (isLoading) {
//       return const Scaffold(
//         body: Center(
//           child: CircularProgressIndicator(),
//         ),
//       );
//     }
//
//     if (routeData == null || userLocation == null) {
//       return Scaffold(
//         appBar: AppBar(
//           title: Text(
//             widget.destinationName,
//           ),
//         ),
//         body: const Center(
//           child: Text(
//             'Unable to load route',
//           ),
//         ),
//       );
//     }
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           widget.destinationName,
//         ),
//       ),
//
//       body: Stack(
//         children: [
//
//           FlutterMap(
//             options: MapOptions(
//               initialCenter: userLocation!,
//               initialZoom: 13,
//             ),
//
//             children: [
//
//               TileLayer(
//                 urlTemplate:
//                 'https://{s}.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}{r}.png',
//                 subdomains: const [
//                   'a',
//                   'b',
//                   'c',
//                   'd',
//                 ],
//               ),
//
//               PolylineLayer(
//                 polylines: [
//                   Polyline(
//                     points: routeData!.points,
//                     strokeWidth: 5,
//                     color: Colors.blue,
//                   ),
//                 ],
//               ),
//
//               MarkerLayer(
//                 markers: [
//
//                   Marker(
//                     point: userLocation!,
//                     width: 50,
//                     height: 50,
//                     child: const Icon(
//                       Icons.my_location,
//                       color: Colors.blue,
//                     ),
//                   ),
//
//                   Marker(
//                     point: LatLng(
//                       widget.destinationLatitude,
//                       widget.destinationLongitude,
//                     ),
//                     width: 50,
//                     height: 50,
//                     child: const Icon(
//                       Icons.location_on,
//                       color: Colors.red,
//                       size: 40,
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//
//           Positioned(
//             left: 16,
//             right: 16,
//             bottom: 16,
//
//             child: Card(
//               child: Padding(
//                 padding: const EdgeInsets.all(16),
//
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//
//                   children: [
//
//                     Text(
//                       'Distance: ${routeData!.distanceKm.toStringAsFixed(
//                           1)} km',
//                     ),
//
//                     const SizedBox(
//                       height: 8,
//                     ),
//
//                     Text(
//                         'ETA: ${formatDuration(routeData!.durationMinutes)}'
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }


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
  static const primaryColor = Color(0xFF14B8A6);

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
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              CircularProgressIndicator(
                color: primaryColor,
              ),
              SizedBox(height: 16),
              Text(
                'Finding the best route...',
                style: TextStyle(
                  color: Color(0xFF6B7280),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (routeData == null || userLocation == null) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.5,
          centerTitle: true,
          title: Text(
            widget.destinationName,
            style: const TextStyle(
              color: Color(0xFF1A1A1A),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.wrong_location_outlined,
                  color: Colors.grey.shade400,
                  size: 46,
                ),
                const SizedBox(height: 12),
                Text(
                  'Unable to load route',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: true,
        title: Text(
          widget.destinationName,
          style: const TextStyle(
            color: Color(0xFF1A1A1A),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
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
                    color: primaryColor,
                  ),
                ],
              ),

              MarkerLayer(
                markers: [

                  // Current location — small solid dot
                  Marker(
                    point: userLocation!,
                    width: 26,
                    height: 26,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: primaryColor,
                        border: Border.all(
                          color: Colors.white,
                          width: 3,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Destination — pin marker
                  Marker(
                    point: LatLng(
                      widget.destinationLatitude,
                      widget.destinationLongitude,
                    ),
                    width: 44,
                    height: 44,
                    child: Container(
                      decoration: BoxDecoration(
                        color: primaryColor,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 3,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.25),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.location_on,
                        color: Colors.white,
                        size: 20,
                      ),
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

            child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: 18,
                horizontal: 12,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.12),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),

              child: Row(
                children: [

                  Expanded(
                    child: _RouteInfoTile(
                      icon: Icons.route_outlined,
                      label: 'Distance',
                      value:
                      '${routeData!.distanceKm.toStringAsFixed(1)} km',
                    ),
                  ),

                  Container(
                    width: 1,
                    height: 40,
                    color: Colors.grey.shade200,
                  ),

                  Expanded(
                    child: _RouteInfoTile(
                      icon: Icons.access_time_rounded,
                      label: 'ETA',
                      value: formatDuration(
                        routeData!.durationMinutes,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RouteInfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _RouteInfoTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF14B8A6);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: primaryColor, size: 20),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A1A1A),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }
}