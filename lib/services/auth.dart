import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'notification_service.dart';

class Auth {
  final _authService = FirebaseAuth.instance;
  Future<User?> signup(
      String firstName,
      String lastName,
      String email,
      String password,
      ) async {
    try {
      final userCred = await _authService.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCred.user;

      if (user != null) {
        await NotificationService().initializeFCM();
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .set({
          'firstName': firstName,
          'lastName': lastName,
          'email': email,
          'role': 'user',
          'createdAt': Timestamp.now(),
        });
      }

      return user;
    } on FirebaseAuthException {
      rethrow;
    }
  }


  Future<Map<String, dynamic>?> login(
      String email,
      String password,
      ) async {
    try {
      final userCred = await _authService.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCred.user;

      if (user != null) {
        await NotificationService().initializeFCM();
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        return {
          'user': user,
          'role': doc.data()?['role'] ?? 'user',
        };
      }

      return null;
    } on FirebaseAuthException {
      rethrow;
    }
  }

//   logout
  Future<void> logout() async {
    try {
      await GoogleSignIn().signOut();
      await FacebookAuth.instance.logOut();
      await _authService.signOut();
    } catch (e) {
      rethrow;
    }
  }


//   Password reset  button

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _authService.sendPasswordResetEmail(
        email: email,
      );
    } on FirebaseAuthException {
      rethrow;
    }
  }



//   google sign in method
  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser =
      await GoogleSignIn().signIn();

      if (googleUser == null) {
        return null; // User cancelled
      }

      final GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await FirebaseAuth.instance
          .signInWithCredential(credential);

      final user = userCredential.user;

      if (user != null) {
        await NotificationService().initializeFCM();

        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (!doc.exists) {
          final displayName = user.displayName ?? '';
          final nameParts = displayName.trim().split(' ');

          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .set({
            'firstName': nameParts.isNotEmpty
                ? nameParts.first
                : '',
            'lastName': nameParts.length > 1
                ? nameParts.sublist(1).join(' ')
                : '',
            'email': user.email,
            'role': 'user',
            'createdAt': Timestamp.now(),
          });
        }
      }

      return userCredential;
    } on FirebaseAuthException catch (e) {
      print('Firebase Error: ${e.code}');
      rethrow;
    } catch (e) {
      print('Google Sign In Error: $e');
      rethrow;
    }
  }
  //sign in wih facebook

  Future<UserCredential?> signInWithFacebook() async {
    try {
      final LoginResult result =
      await FacebookAuth.instance.login();

      if (result.status != LoginStatus.success) {
        return null;
      }

      final OAuthCredential credential =
      FacebookAuthProvider.credential(
        result.accessToken!.tokenString,
      );

      final userCredential =
      await FirebaseAuth.instance
          .signInWithCredential(credential);

      // Create Firestore document if it doesn't exist
      final user = userCredential.user;

      if (user != null) {
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (!doc.exists) {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .set({
            'firstName': user.displayName ?? '',
            'lastName': '',
            'email': user.email,
            'role': 'user',
            'createdAt': Timestamp.now(),
          });
        }
      }

      return userCredential;
    } on FirebaseAuthException {
      rethrow;
    }
  }
  


}
