import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'account_created_successfully.dart';

class VerifyEmail extends StatefulWidget {
  const VerifyEmail({super.key});

  @override
  State<VerifyEmail> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  DateTime? _lastResendTime;
  @override
  void initState() {
    super.initState();

    FirebaseAuth.instance.currentUser
        ?.sendEmailVerification();

    _lastResendTime = DateTime.now();
  }
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            icon: Icon(Icons.clear),
          ),
        ],
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
                  'assets/images/emailVerificationSVG.svg',
                  width: width * 0.8,
                  // height: height * 0.4,
                ),
                SizedBox(height: height * 0.06),

                FittedBox(
                  child: Text(
                    "Verify your email address!",
                    style: TextStyle(fontSize: 27, fontWeight: FontWeight.w800),
                  ),
                ),

                SizedBox(height: height * 0.01),
                Text(
                  FirebaseAuth.instance.currentUser?.email ?? "",
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                SizedBox(height: height * 0.01),
                Text(
                  "Check ${FirebaseAuth.instance.currentUser?.email ?? ""} for a verification email. Once verified, you'll be ready to explore your city and nearby places with City Compass.",
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

                    onPressed: () async {

                      final user = FirebaseAuth.instance.currentUser;

                      await user?.reload();

                      final refreshedUser =
                          FirebaseAuth.instance.currentUser;

                      if (refreshedUser != null &&
                          refreshedUser.emailVerified) {

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                            const AccountCreatedSuccessfully(),
                          ),
                        );

                      } else {

                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Email not verified'),
                            content: const Text(
                              'Please verify your email before continuing.',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          ),
                        );

                      }
                    },
                    child: Text(
                      "Continue",
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

                      final now = DateTime.now();

                      if (_lastResendTime != null) {

                        final difference =
                        now.difference(_lastResendTime!);

                        if (difference.inMinutes < 3) {

                          final remaining =
                              3 - difference.inMinutes;

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'You can resend after $remaining minute(s)',
                              ),
                            ),
                          );

                          return;
                        }
                      }

                      await FirebaseAuth.instance.currentUser
                          ?.sendEmailVerification();

                      _lastResendTime = DateTime.now();

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Verification email sent',
                          ),
                        ),
                      );
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
