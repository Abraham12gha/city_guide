import 'package:cloud_firestore/cloud_firestore.dart';
import '../admin_app/models/attraction_model.dart';

class AttractionService {
  final firestore = FirebaseFirestore.instance;

  Future<void> addAttraction({
    required String name,
    required String description,

    required String cityId,
    required String cityName,

    required String categoryId,
    required String categoryName,

    required String address,

    required double latitude,
    required double longitude,

    required String phoneNumber,
    required String website,
    required String openingHours,

    required String imageUrl,
  }) async {

    await firestore.collection('attractions').add({

      'name': name,
      'description': description,

      'cityId': cityId,
      'cityName': cityName,

      'categoryId': categoryId,
      'categoryName': categoryName,

      'address': address,

      'latitude': latitude,
      'longitude': longitude,

      'phoneNumber': phoneNumber,
      'website': website,
      'openingHours': openingHours,

      'imageUrl': imageUrl,

      'averageRating': 0,
      'totalReviews': 0,

      'createdAt': Timestamp.now(),
    });
  }












  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  Stream<List<AttractionModel>> getAttractions() {
    return _firestore
        .collection('attractions')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
          .map(
            (doc) => AttractionModel.fromFirestore(doc),
      )
          .toList(),
    );
  }


  Future<void> deleteAttraction(String id) async {
    await _firestore
        .collection('attractions')
        .doc(id)
        .delete();
  }

  Future<void> updateAttraction(AttractionModel attraction) async {
    await _firestore
        .collection('attractions')
        .doc(attraction.id)
        .update(attraction.toMap());
  }




}




