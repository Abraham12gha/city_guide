import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import '../../core/config/api_key.dart';
import '../model/route_data.dart';

class RouteService {
  Future<RouteData> getRoute({
    required LatLng start,
    required LatLng end,
  }) async {
    final uri = Uri.parse(
      'https://api.openrouteservice.org/v2/directions/driving-car',
    );

    final response = await http.post(
      uri,

      headers: {
        'Authorization': ApiKeys.orsApiKey,
        'Content-Type': 'application/json',
      },

      body: jsonEncode({
        'coordinates': [
          [start.longitude, start.latitude],
          [end.longitude, end.latitude],
        ],
        'format': 'geojson',
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch route');
    }

    final data = jsonDecode(response.body);
    debugPrint(data.toString());
    debugPrint(response.body);
    debugPrint(
      'Status Code: ${response.statusCode}',
    );

    debugPrint(
      'HAS ROUTES: ${data.containsKey('routes')}',
    );

    debugPrint(
      'FIRST ROUTE KEYS: ${data['routes'][0].keys.toList()}',
    );

    final route = data['routes'][0];

    final summary = route['summary'];

    final distanceKm =
        (summary['distance'] as num).toDouble() / 1000;

    final durationMinutes =
        (summary['duration'] as num).toDouble() / 60;

    debugPrint(
      'GEOMETRY TYPE: ${route['geometry'].runtimeType}',
    );

    debugPrint(
      'GEOMETRY VALUE: ${route['geometry']}',
    );

    final encodedGeometry =
    route['geometry'] as String;

    // final polylinePoints = PolylinePoints();

    final decoded = PolylinePoints.decodePolyline(
      encodedGeometry,
    );

    final points = decoded.map(
          (point) => LatLng(
        point.latitude,
        point.longitude,
      ),
    ).toList();

    return RouteData(
      points: points,
      distanceKm: distanceKm,
      durationMinutes: durationMinutes,
    );

  }
}
