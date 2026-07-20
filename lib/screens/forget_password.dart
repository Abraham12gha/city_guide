import 'package:city_guide/screens/password_reset.dart';
import 'package:city_guide/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final _auth = Auth();

  @override
  void dispose(){
    _emailController.dispose();
    super.dispose();
  }


  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: .start,
          children: [
            Text(
              "Forget password",
              style: TextStyle(fontSize: 23, fontWeight: FontWeight.w800),
            ),

            SizedBox(height: height * 0.01),

            Text(
              "Don't worry, forgetting your password happens sometimes. Enter your email, and we'll send you a link to reset it.",
              style: TextStyle(color: Colors.black45),
            ),

            SizedBox(height: height * 0.06),

            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.email),
                labelText: "E-mail",
                // errorText: _emailError,
                labelStyle: const TextStyle(fontWeight: FontWeight.w700),

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: Colors.grey.shade300,
                    width: 1.5,
                  ),
                ),

                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: Color(0xFFBDBDBD),
                    width: 2,
                  ),
                ),

                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: Colors.grey.shade300,
                    width: 1.5,
                  ),
                ),
              ),
            ),

            SizedBox(height: height * 0.03),

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
                  try{
                    await _auth.sendPasswordResetEmail(_emailController.text);
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PasswordReset(
                            email: _emailController.text.trim(),
                          ),
                        )
                    );
                  }on FirebaseAuthException catch(e){
                    rethrow;
                  }
                },
                child: Text(
                  "Continue",
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
