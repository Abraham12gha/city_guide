import 'package:cloud_firestore/cloud_firestore.dart';

import '../admin_app/models/category_model.dart';

class CategoryService {
  final firestore = FirebaseFirestore.instance;

  Future<void> addCategory({
    required String name,
    required String imageUrl,
  }) async {
    await firestore.collection('categories').add({
      'name': name,
      'imageUrl': imageUrl,
      'createdAt': Timestamp.now(),
    });
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<CategoryModel>> getCategories() {
    return _firestore
        .collection('categories')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => CategoryModel.fromFirestore(doc))
              .toList(),
        );
  }

  Future<void> deleteCategory(String id) async {
    await _firestore.collection('categories').doc(id).delete();
  }

  Future<void> updateCategory({
    required String id,
    required String name,
    required String imageUrl,
  }) async {
    await _firestore.collection('categories').doc(id).update({
      'name': name,
      'imageUrl': imageUrl,
    });
  }
}
