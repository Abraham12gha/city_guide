import 'package:city_guide/screens/verify_email.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'admin_app/admin_main_home.dart';
import 'screens/app_screen/Main_screen.dart';
import 'screens/welcome_screen.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, authSnapshot) {

        if (authSnapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        final user = authSnapshot.data;

        if (user == null) {
          return const mainScreen();
        }

        final isEmailPasswordUser = user.providerData.any(
              (provider) => provider.providerId == 'password',
        );

        if (isEmailPasswordUser && !user.emailVerified) {
          return const VerifyEmail();
        }

        return FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get(),
          builder: (context, roleSnapshot) {

            if (roleSnapshot.connectionState ==
                ConnectionState.waiting) {
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }

            final role =
                roleSnapshot.data?.get('role') ?? 'user';

            if (role == 'admin') {
              return const AdminMainHome();
            }
            return const MainScreen();
          },
        );
      },
    );
  }
}
