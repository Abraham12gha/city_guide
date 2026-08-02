// // import '../screens/app_models/avatar_model.dart';
// // import 'package:cloud_firestore/cloud_firestore.dart';
// //
// //
// // class AvatarService {
// //   AvatarService._();
// //
// //   static final AvatarService instance = AvatarService._();
// //
// //   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
// //
// //   CollectionReference<Map<String, dynamic>> get _avatars =>
// //       _firestore.collection('avatars');
// //   /// Get all active avatars
// //
// //   Future<List<AvatarModel>> getAvatars() async {
// //     try {
// //       final snapshot = await _avatars
// //           .where('isActive', isEqualTo: true)
// //           .orderBy('createdAt')
// //           .get();
// //
// //       return snapshot.docs
// //           .map((doc) => AvatarModel.fromFirestore(doc))
// //           .toList();
// //     } catch (e) {
// //       throw Exception('Failed to fetch avatars: $e');
// //     }
// //   }
// //
// //   /// Stream active avatars
// //   Stream<List<AvatarModel>> streamAvatars() {
// //     return _avatars
// //         .where('isActive', isEqualTo: true)
// //         .orderBy('createdAt')
// //         .snapshots()
// //         .map(
// //           (snapshot) => snapshot.docs
// //           .map((doc) => AvatarModel.fromFirestore(doc))
// //           .toList(),
// //     );
// //   }
// //
// //
// //   /// Get a single avatar by ID
// //   Future<AvatarModel?> getAvatarById(String avatarId) async {
// //     try {
// //       final doc = await _avatars.doc(avatarId).get();
// //
// //       if (!doc.exists) return null;
// //
// //       return AvatarModel.fromFirestore(doc);
// //     } catch (e) {
// //       throw Exception('Failed to fetch avatar: $e');
// //     }
// //   }
// //
// //
// //
// // }
// //
//
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import '../screens/app_models/avatar_model.dart';
//
// class AvatarService {
//   AvatarService._();
//
//   static final AvatarService instance = AvatarService._();
//
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//
//   CollectionReference<Map<String, dynamic>> get _avatars =>
//       _firestore.collection('avatars');
//
//   /// Add Avatar
//   Future<void> addAvatar({
//     required String imageUrl,
//   }) async {
//     try {
//       final doc = _avatars.doc();
//
//       await doc.set({
//         'id': doc.id,
//         'imageUrl': imageUrl,
//         'isActive': true,
//         'createdAt': FieldValue.serverTimestamp(),
//       });
//     } catch (e) {
//       throw Exception('Failed to add avatar: $e');
//     }
//   }
//
//   /// Update Avatar
//   Future<void> updateAvatar({
//     required String id,
//     required String imageUrl,
//   }) async {
//     try {
//       await _avatars.doc(id).update({
//         'imageUrl': imageUrl,
//       });
//     } catch (e) {
//       throw Exception('Failed to update avatar: $e');
//     }
//   }
//
//   /// Delete Avatar (Hard Delete)
//   Future<void> deleteAvatar(String id) async {
//     try {
//       await _avatars.doc(id).delete();
//     } catch (e) {
//       throw Exception('Failed to delete avatar: $e');
//     }
//   }
//
//   /// Get all active avatars
//   Future<List<AvatarModel>> getAvatars() async {
//     try {
//       final snapshot = await _avatars
//           .where('isActive', isEqualTo: true)
//           .orderBy('createdAt')
//           .get();
//
//       return snapshot.docs
//           .map((doc) => AvatarModel.fromFirestore(doc))
//           .toList();
//     } catch (e) {
//       throw Exception('Failed to fetch avatars: $e');
//     }
//   }
//
//   /// Stream active avatars
//   Stream<List<AvatarModel>> streamAvatars() {
//     return _avatars
//         .where('isActive', isEqualTo: true)
//         .orderBy('createdAt')
//         .snapshots()
//         .map((snapshot) => snapshot.docs
//         .map((doc) => AvatarModel.fromFirestore(doc))
//         .toList());
//   }
//
//   /// Get a single avatar by ID
//   Future<AvatarModel?> getAvatarById(String avatarId) async {
//     try {
//       final doc = await _avatars.doc(avatarId).get();
//
//       if (!doc.exists) return null;
//
//       return AvatarModel.fromFirestore(doc);
//     } catch (e) {
//       throw Exception('Failed to fetch avatar: $e');
//     }
//   }
// }


import 'package:cloud_firestore/cloud_firestore.dart';
import '../screens/app_models/avatar_model.dart';

class AvatarService {
  AvatarService._();

  static final AvatarService instance = AvatarService._();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _avatars =>
      _firestore.collection('avatars');

  /// Add Avatar
  Future<void> addAvatar({
    required String imageUrl,
  }) async {
    await _avatars.add({
      'imageUrl': imageUrl,
      'isActive': true,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// Update Avatar
  Future<void> updateAvatar({
    required String id,
    required String imageUrl,
  }) async {
    await _avatars.doc(id).update({
      'imageUrl': imageUrl,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// Delete Avatar
  Future<void> deleteAvatar(String id) async {
    await _avatars.doc(id).delete();
  }

  /// Get all active avatars
  Future<List<AvatarModel>> getAvatars() async {
    final snapshot = await _avatars
        .where('isActive', isEqualTo: true)
        .get();

    return snapshot.docs
        .map((doc) => AvatarModel.fromFirestore(doc))
        .toList();
  }

  /// Stream active avatars
  Stream<List<AvatarModel>> streamAvatars() {
    return _avatars
        .where('isActive', isEqualTo: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
          .map((doc) => AvatarModel.fromFirestore(doc))
          .toList(),
    );
  }

  /// Get avatar by id
  Future<AvatarModel?> getAvatarById(String avatarId) async {
    final doc = await _avatars.doc(avatarId).get();

    if (!doc.exists) return null;

    return AvatarModel.fromFirestore(doc);
  }
}