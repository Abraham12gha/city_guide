import 'package:city_guide/screens/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../services/auth.dart';
import 'login_screen.dart';

class mainScreen extends StatelessWidget {
  const mainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Column(
              children: [
                SvgPicture.asset(
                  'assets/images/welcome_screen.svg',
                  width: width * 0.9,
                  height: height * 0.4,
                  fit: BoxFit.contain,
                ),

                Column(
                  children: [
                    Image.asset(
                      "assets/images/logo_with_name-new.png",
                      height: height * 0.15,
                    ),

                    Text(
                      "Explore top attractions, local favorites, and unforgettable experiences that bring the city to life.",
                      style: TextStyle(fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                //   signup and login button
                SizedBox(height: height * 0.03),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  },
                  child: Container(
                    height: height * 0.056,
                    width: width * 0.7,
                    alignment: .center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Color(0xFF14B8A6),
                    ),
                    child: Text(
                      "Login",
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 7),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SignupScreen(),
                      ),
                    );
                  },
                  child: Container(
                    height: height * 0.056,
                    width: width * 0.7,
                    alignment: .center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(color: Color(0xFF14B8A6), width: 2.0),
                    ),
                    child: Text(
                      "Signup",
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: height * 0.08),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Divider(
                        color: Colors.grey,
                        thickness: 0.5,
                        indent: 60,
                        endIndent: 5,
                      ),
                    ),
                    Text(
                      "or continue with",
                      style: TextStyle(color: Colors.grey.shade500),
                    ),
                    Flexible(
                      child: Divider(
                        color: Colors.grey,
                        thickness: 0.5,
                        indent: 5,
                        endIndent: 60,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: height * 0.018),

                Row(
                  mainAxisAlignment: .center,
                  children: [
                    Container(
                      width: width * 0.7,
                      child: Row(
                        mainAxisAlignment: .spaceEvenly,
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () async {
                                await Auth().signInWithGoogle();
                              },
                              child: SocialIcon(
                                imagePath: "assets/images/google_logo-new.png",
                                name: "Google",
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: GestureDetector(
                              onTap: () async {
                                await Auth().signInWithFacebook();
                              },
                              child: SocialIcon(
                                imagePath: "assets/images/Facebook_logo-new.png",
                                name: "Facebook",
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SocialIcon extends StatelessWidget {
  final String imagePath;
  final String name;

  const SocialIcon({super.key, required this.imagePath, required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 110,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(width: 1, color: Colors.grey),
      ),
      child: Row(
        mainAxisAlignment: .center,
        children: [
          Image.asset(imagePath, height: 20, fit: BoxFit.contain),
          SizedBox(width: 5),
          Text(name, style: TextStyle(fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}
