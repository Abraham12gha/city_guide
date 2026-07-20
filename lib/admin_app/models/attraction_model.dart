import 'package:cloud_firestore/cloud_firestore.dart';

class AttractionModel {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final String address;
  final String cityName;
  final String cityId;
  final String categoryId;
  final String categoryName;
  final String phoneNumber;
  final String website;
  final String openingHours;
  final double latitude;
  final double longitude;
  final int averageRating;
  final int totalReviews;

  const AttractionModel({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.address,
    required this.cityName,
    required this.cityId,
    required this.categoryId,
    required this.categoryName,
    required this.phoneNumber,
    required this.website,
    required this.openingHours,
    required this.latitude,
    required this.longitude,
    required this.averageRating,
    required this.totalReviews,
  });

  factory AttractionModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return AttractionModel(
      id: doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      address: data['address'] ?? '',
      cityName: data['cityName'] ?? '',
        cityId: data['cityId'] ?? '',
        categoryId: data['categoryId'] ?? '',
      categoryName: data['categoryName'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
      website: data['website'] ?? '',
      openingHours: data['openingHours'] ?? '',
      latitude: (data['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (data['longitude'] as num?)?.toDouble() ?? 0.0,
      averageRating: (data['averageRating'] as num?)?.toInt() ?? 0,
      totalReviews: (data['totalReviews'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'address': address,
      'cityName': cityName,

      'cityId': cityId,
      'categoryId': categoryId,

      'categoryName': categoryName,
      'phoneNumber': phoneNumber,
      'website': website,
      'openingHours': openingHours,
      'latitude': latitude,
      'longitude': longitude,
      'averageRating': averageRating,
      'totalReviews': totalReviews,
    };
  }

  AttractionModel copyWith({
    String? id,
    String? name,
    String? description,
    String? imageUrl,
    String? address,
    String? cityName,
    String? cityId,
    String? categoryName,
    String? phoneNumber,
    String? website,
    String? openingHours,
    double? latitude,
    double? longitude,
    int? averageRating,
    int? totalReviews,
  }) {
    return AttractionModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      address: address ?? this.address,
      cityName: cityName ?? this.cityName,
      cityId: this.cityId,
      categoryId: this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      website: website ?? this.website,
      openingHours: openingHours ?? this.openingHours,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      averageRating: averageRating ?? this.averageRating,
      totalReviews: totalReviews ?? this.totalReviews,
    );
  }
}
