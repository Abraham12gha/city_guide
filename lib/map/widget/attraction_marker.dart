// import 'package:flutter/material.dart';
// import 'package:latlong2/latlong.dart';
//
// import '../../admin_app/models/attraction_model.dart';
//
//
// class AttractionMarker extends StatelessWidget {
//   final AttractionModel attraction;
//   final VoidCallback onTap;
//
//   const AttractionMarker({
//     super.key,
//     required this.attraction,
//     required this.onTap,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: const Icon(
//         Icons.location_pin,
//         color: Colors.red,
//         size: 40,
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

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
    const primaryColor = Color(0xFF14B8A6);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 42,
        height: 42,
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
    );
  }
}