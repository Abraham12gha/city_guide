import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../services/auth.dart';
import 'login_screen.dart';

class PasswordReset extends StatelessWidget {
  final String email;

  const PasswordReset({
    super.key,
    required this.email,
  });


  @override


  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        actions: [IconButton(onPressed: (){}, icon: Icon(Icons.clear))],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/images/pass_reset_successfully_illstration.svg',
                    width: width * 0.8,
                  ),
                  SizedBox(height: height * 0.06),

                  FittedBox(
                    child: Text(
                      "Password Reset Email Sent",
                      style: TextStyle(fontSize: 27, fontWeight: FontWeight.w800),
                    ),
                  ),

                  SizedBox(height: height * 0.01),

                  Text(
                    email,
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: height * 0.01),
                  Text(
                    "Your Account Security is Our Priority! We've Sent you a Secure Link to Safety Changes",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black45),
                  ),

                  SizedBox(height: height * 0.02),

                  SizedBox(
                    height: 55,
                    width: width * .9,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF14B8A6),
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),

                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const LoginScreen(),
                          ),
                              (route) => false,
                        );
                      },
                      child: Text(
                        "Back to Login",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: height * 0.01),

                  SizedBox(
                    height: 60,
                    width: width * .9,
                    child: TextButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black54,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () async {
                        try {
                          await FirebaseAuth.instance
                              .sendPasswordResetEmail(email: email);

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Reset email sent again"),
                            ),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(e.toString())),
                          );
                        }
                      },
                      child: Text(
                        "Resend email",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
            ),
          ),
        ),
      ),
    );
  }
}
