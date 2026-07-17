import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeFirestore {

  // add fav
  Future<void> addToFavorites(String attractionId) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('favorites')
        .doc(attractionId)
        .set({'createdAt': FieldValue.serverTimestamp()});
  }

  //load fav
  Future<Set<String>> loadFavorites() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return {};

    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('favorites')
        .get();

    return snapshot.docs.map((doc) => doc.id).toSet();
  }


  // remove fav

  Future<void> removeFromFavorites(String attractionId) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('favorites')
        .doc(attractionId)
        .delete();
  }






}
