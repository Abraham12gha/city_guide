import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AttractionInformation extends StatelessWidget {
  final QueryDocumentSnapshot attraction;

  const AttractionInformation({
    super.key,
    required this.attraction,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [

          _detailTile(
            Icons.location_on,
            "Address",
            attraction['address'],
          ),

          _detailTile(
            Icons.phone,
            "Phone",
            attraction['phoneNumber'],
          ),

          _detailTile(
            Icons.language,
            "Website",
            attraction['website'],
          ),

          _detailTile(
            Icons.access_time,
            "Opening Hours",
            attraction['openingHours'],
          ),

          _detailTile(
            Icons.star,
            "Rating",
            attraction['averageRating'].toString(),
          ),
        ],
      ),
    );
  }

  Widget _detailTile(
      IconData icon,
      String title,
      String value,
      ) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(value),
    );
  }
}