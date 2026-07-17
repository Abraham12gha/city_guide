import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewFirestore {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _updateAttractionStats(
      String attractionId,
      ) async {

    final reviewsSnapshot =
    await _firestore
        .collection('attractions')
        .doc(attractionId)
        .collection('reviews')
        .get();

    final reviews = reviewsSnapshot.docs;

    int totalReviews = reviews.length;

    double totalRating = 0;

    for (final review in reviews) {

      totalRating +=
          (review['rating'] as num)
              .toDouble();
    }

    double averageRating =
    totalReviews == 0
        ? 0
        : totalRating / totalReviews;

    await _firestore
        .collection('attractions')
        .doc(attractionId)
        .update({

      'averageRating':
      double.parse(
        averageRating.toStringAsFixed(1),
      ),

      'totalReviews': totalReviews,
    });
  }


  Future<void> submitOrUpdateReview({
    required String attractionId,
    required String userId,
    required String userName,
    required String userPhoto,
    required double rating,
    required String review,
  }) async {

    final attractionRef =
    _firestore.collection('attractions')
        .doc(attractionId);

    final reviewRef =
    attractionRef
        .collection('reviews')
        .doc(userId);

    await reviewRef.set({
      'userId': userId,
      'userName': userName,
      'userPhoto': userPhoto,
      'rating': rating,
      'review': review,
      'updatedAt': FieldValue.serverTimestamp(),
    });

    await _updateAttractionStats(attractionId);
    if (review.trim().isEmpty) {
      throw Exception('Review is required');
    }
  }

  Future<bool> hasReviewed({
    required String attractionId,
    required String userId,
  }) async {

    final doc = await _firestore
        .collection('attractions')
        .doc(attractionId)
        .collection('reviews')
        .doc(userId)
        .get();

    return doc.exists;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getReviews(
      String attractionId,
      ) {
    return _firestore
        .collection('attractions')
        .doc(attractionId)
        .collection('reviews')
        .orderBy(
      'updatedAt',
      descending: true,
    )
        .snapshots();
  }


  Future<Map<String, dynamic>?> getUserReview({
    required String attractionId,
    required String userId,
  }) async {
    final doc = await _firestore
        .collection('attractions')
        .doc(attractionId)
        .collection('reviews')
        .doc(userId)
        .get();

    if (!doc.exists) return null;

    return doc.data();
  }
}