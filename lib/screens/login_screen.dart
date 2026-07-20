import 'package:city_guide/screens/signup_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../admin_app/admin_main_home.dart';
import '../services/auth.dart';
import 'app_screen/Main_screen.dart';
import 'forget_password.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final _auth = Auth();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool _rememberMe = true;

  bool _isLoading = false;
  bool _isPasswordHidden = true;

  // input error
  String? _emailError;
  String? _passwordError;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 20.0),
          child: Column(
            children: [
              Column(
                crossAxisAlignment: .start,
                children: [
                  Image.asset(
                    "assets/images/logo-new.png",
                    height: height * 0.12,
                  ),
                  Text(
                    "Welcome Back,",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
                  ),
                  Text(
                    "Find exciting places, popular attractions, and unique experiences wherever your journey takes you.",
                    style: TextStyle(color: Colors.black45),
                  ),
                ],
              ),

              SizedBox(height: height * 0.04),
              Form(
                child: Column(
                  children: [
                    TextFormField(
                      controller: _emailController,
                      onChanged: (_) {
                        if (_emailError != null) {
                          setState(() {
                            _emailError = null;
                          });
                        }
                      },
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.email),
                        labelText: "E-mail",
                        errorText: _emailError,
                        labelStyle: const TextStyle(
                          fontWeight: FontWeight.w700,
                        ),

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
                    SizedBox(height: height * 0.01),
                    TextFormField(
                      controller: _passwordController,
                      onChanged: (_) {
                        if (_passwordError != null) {
                          setState(() {
                            _passwordError = null;
                          });
                        }
                      },
                      obscureText: _isPasswordHidden,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.lock),
                        labelText: "Password",
                        errorText: _passwordError,
                        labelStyle: const TextStyle(
                          fontWeight: FontWeight.w700,
                        ),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _isPasswordHidden = !_isPasswordHidden;
                            });
                          },
                          icon: Icon(
                            _isPasswordHidden
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                        ),

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
                    SizedBox(height: height * 0.01),
                    Row(
                      mainAxisAlignment: .spaceBetween,
                      children: [
                        Row(
                          children: [

                            Checkbox(
                              value: _rememberMe,
                              onChanged: (value) {
                                setState(() {
                                  _rememberMe = value ?? false;
                                });
                              },
                              activeColor: const Color(0xFF14B8A6),
                              checkColor: Colors.white,
                            ),

                            Text("Remember me"),
                          ],
                        ),
                        TextButton(
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ForgetPassword(),
                            ),
                          ),
                          child: Text(
                            "Forget Password?",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: height * 0.04),
                    SizedBox(
                      height: height * 0.067,
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

                        onPressed: _isLoading
                            ? null
                            : () async {
                                setState(() {
                                  _emailError = null;
                                  _passwordError = null;
                                });

                                bool hasError = false;

                                if (_emailController.text.trim().isEmpty) {
                                  _emailError = 'Email is required';
                                  hasError = true;
                                }

                                if (_passwordController.text.isEmpty) {
                                  _passwordError = 'Password is required';
                                  hasError = true;
                                }

                                setState(() {});

                                if (hasError) return;

                                try {
                                  setState(() {
                                    _isLoading = true;
                                  });

                                  // final user = await _auth.login(
                                  //   _emailController.text.trim(),
                                  //   _passwordController.text,
                                  // );
                                  //
                                  // if (user != null && mounted) {
                                  //   Navigator.pushReplacement(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //       builder: (_) => const MainScreen(),
                                  //     ),
                                  //   );
                                  // }

                                  await _auth.login(
                                    _emailController.text.trim(),
                                    _passwordController.text,
                                  );

                                } on FirebaseAuthException catch (e) {
                                  setState(() {
                                    if (e.code == 'user-not-found') {
                                      _emailError =
                                          'No account found with this email.';
                                    } else if (e.code == 'wrong-password') {
                                      _passwordError = 'Incorrect password.';
                                    } else if (e.code == 'invalid-email') {
                                      _emailError =
                                          'Please enter a valid email address.';
                                    } else if (e.code == 'invalid-credential') {
                                      _passwordError =
                                          'Invalid email or password.';
                                    }
                                  });
                                } finally {
                                  if (mounted) {
                                    setState(() {
                                      _isLoading = false;
                                    });
                                  }
                                }
                              },

                        child: _isLoading
                            ? const SizedBox(
                                height: 22,
                                width: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                "Login",
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                      ),
                    ),
                    SizedBox(height: height * 0.008),

                    SizedBox(
                      width: width * .9,
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignupScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                          foregroundColor: Colors.black,
                          side: const BorderSide(
                            color: Color(0xFFD9D9D9),
                            width: 1.5,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: Text(
                          "Create Account",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.04),
                  ],
                ),
              ),

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

              SizedBox(height: height * 0.03),
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
