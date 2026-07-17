import 'package:city_guide/admin_app/models/city_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CityService {

  final firestore = FirebaseFirestore.instance;

  Future<void> addCity({
    required String name,
    required String description,
    required String imageUrl,
  }) async {

    await firestore.collection('cities').add({
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'createdAt': Timestamp.now(),
    });
  }



  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  Stream<List<CityModel>> getCities() {
    return _firestore
        .collection('cities')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
          .map(
            (doc) => CityModel.fromFirestore(doc),
      )
          .toList(),
    );
  }

  Future<void> deleteCity(String id) async {
    await _firestore
        .collection('cities')
        .doc(id)
        .delete();
  }

  Future<void> updateCity({
    required String id,
    required String name,
    required String description,
    required String imageUrl,
  }) async {
    await FirebaseFirestore.instance
        .collection("cities")
        .doc(id)
        .update({
      "name": name,
      "description": description,
      "imageUrl": imageUrl,
    });
  }
}
