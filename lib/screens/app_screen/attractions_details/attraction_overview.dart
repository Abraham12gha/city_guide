// import 'package:flutter/material.dart';
// class AttractionOverview extends StatelessWidget {
//   const AttractionOverview({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             widget.attraction['description'],
//             style: const TextStyle(
//               fontSize: 15,
//               height: 1.6,
//             ),
//           ),
//
//           const SizedBox(height: 20),
//
//           Container(
//             padding: const EdgeInsets.all(12),
//             decoration: BoxDecoration(
//               color: Colors.grey.shade100,
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: Column(
//               children: [
//                 _infoRow(Icons.restaurant, "Category",
//                     widget.attraction['categoryName']),
//                 _infoRow(Icons.location_city, "City",
//                     widget.attraction['cityName']),
//                 _infoRow(Icons.access_time, "Hours",
//                     widget.attraction['openingHours']),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AttractionOverview extends StatelessWidget {
  final QueryDocumentSnapshot attraction;

  const AttractionOverview({
    super.key,
    required this.attraction,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Text(
            attraction['description'],
            style: const TextStyle(
              fontSize: 15,
              height: 1.6,
            ),
          ),

          const SizedBox(height: 20),

          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [

                _infoRow(
                  Icons.restaurant,
                  "Category",
                  attraction['categoryName'],
                ),

                _infoRow(
                  Icons.location_city,
                  "City",
                  attraction['cityName'],
                ),

                _infoRow(
                  Icons.access_time,
                  "Hours",
                  attraction['openingHours'],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(
      IconData icon,
      String title,
      String value,
      ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 10),

          Text(
            "$title: ",
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),

          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}