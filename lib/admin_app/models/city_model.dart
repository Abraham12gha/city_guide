import 'package:cloud_firestore/cloud_firestore.dart';

class CityModel {
  final String id;
  final String name;
  final String description;
  final String imageUrl;

  const CityModel({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
  });

  factory CityModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return CityModel(
      id: doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
    };
  }
}