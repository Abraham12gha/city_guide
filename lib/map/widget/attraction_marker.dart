import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

import '../../admin_app/models/attraction_model.dart';


class AttractionMarker extends StatelessWidget {
  final AttractionModel attraction;
  final VoidCallback onTap;

  const AttractionMarker({
    super.key,
    required this.attraction,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: const Icon(
        Icons.location_pin,
        color: Colors.red,
        size: 40,
      ),
    );
  }
}