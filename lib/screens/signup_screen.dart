import 'dart:math';

import 'package:city_guide/screens/verify_email.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../services/auth.dart';
import 'app_screen/Main_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final _auth = Auth();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();

    super.dispose();
  }

  bool _isPasswordHidden = true;
  bool _isConfirmPasswordHidden = true;

  bool _isLoading = false;
  bool _agreeTerms = false;

  String? _emailError;
  String? _passwordError;
  String? _confirmPasswordError;
  String? _termsError;
  String? _firstNameError;
  String? _lastNameError;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: .start,
            children: [
              Text(
                "Let's create your account",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
              ),
              SizedBox(height: 36.0),
              Form(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _firstNameController,
                            onChanged: (_) {
                              if (_firstNameError != null) {
                                setState(() {
                                  _firstNameError = null;
                                });
                              }
                            },
                            expands: false,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.person),
                              labelText: "First Name",
                              errorText: _firstNameError,
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
                        ),

                        SizedBox(width: 16),

                        Expanded(
                          child: TextFormField(
                            controller: _lastNameController,
                            onChanged: (_) {
                              if (_lastNameError != null) {
                                setState(() {
                                  _lastNameError = null;
                                });
                              }
                            },
                            expands: false,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.person),
                              labelText: "Last Name",
                              errorText: _lastNameError,
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
                        ),
                      ],
                    ),

                    SizedBox(height: 16),

                    TextFormField(
                      controller: _emailController,
                      onChanged: (_) {
                        if (_emailError != null) {
                          setState(() {
                            _emailError = null;
                          });
                        }
                      },
                      expands: false,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.mail),
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

                    SizedBox(height: 16),

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
                      expands: false,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.lock),
                        labelText: "Password",
                        errorText: _passwordError,
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

                    SizedBox(height: 16),

                    TextFormField(
                      controller: _confirmPasswordController,
                      onChanged: (_) {
                        if (_confirmPasswordError != null) {
                          setState(() {
                            _confirmPasswordError = null;
                          });
                        }
                      },
                      expands: false,
                      obscureText: _isConfirmPasswordHidden,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.lock),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _isConfirmPasswordHidden =
                                  !_isConfirmPasswordHidden;
                            });
                          },
                          icon: Icon(
                            _isConfirmPasswordHidden
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                        ),
                        labelText: "Confirm Password",
                        errorText: _confirmPasswordError,
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

                    SizedBox(height: 16),

                    Row(
                      children: [
                        SizedBox(
                          height: 24,
                          width: 24,
                          child: Checkbox(
                            value: _agreeTerms,
                            onChanged: (value) {
                              setState(() {
                                _agreeTerms = value ?? false;

                                if (_agreeTerms) {
                                  _termsError = null;
                                }
                              });
                            },
                            activeColor: const Color(0xFF14B8A6),
                            checkColor: Colors.white,
                          ),
                        ),

                        SizedBox(width: 5),
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: "i agree to ",
                                style: TextStyle(color: Colors.black),
                              ),
                              TextSpan(
                                text: "private policy ",
                                style: TextStyle(
                                  color: Color(0xFF1E88E5),
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                              TextSpan(
                                text: "and ",
                                style: TextStyle(color: Colors.black),
                              ),
                              TextSpan(
                                text: "term of use ",
                                style: TextStyle(
                                  color: Color(0xFF1E88E5),
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    if (_termsError != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Text(
                          _termsError!,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                          ),
                        ),
                      ),

                    SizedBox(height: 32.0),

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

                        onPressed: _isLoading
                            ? null
                            : () async {
                                try {
                                  setState(() {
                                    _firstNameError = null;
                                    _lastNameError = null;
                                    _emailError = null;
                                    _passwordError = null;
                                    _confirmPasswordError = null;
                                    _termsError = null;
                                  });

                                  bool hasError = false;

                                  if (_firstNameController.text
                                      .trim()
                                      .isEmpty) {
                                    _firstNameError = 'First name is required';
                                    hasError = true;
                                  }

                                  if (_lastNameController.text.trim().isEmpty) {
                                    _lastNameError = 'Last name is required';
                                    hasError = true;
                                  }

                                  if (_emailController.text.trim().isEmpty) {
                                    _emailError = 'Email is required';
                                    hasError = true;
                                  }

                                  if (_passwordController.text.isEmpty) {
                                    _passwordError = 'Password is required';
                                    hasError = true;
                                  }

                                  if (_confirmPasswordController.text.isEmpty) {
                                    _confirmPasswordError =
                                        'Please confirm your password';
                                    hasError = true;
                                  }

                                  if (!_agreeTerms) {
                                    _termsError =
                                        'Please accept the Terms and Privacy Policy';
                                    hasError = true;
                                  }

                                  setState(() {});

                                  if (hasError) return;

                                  if (_passwordController.text !=
                                      _confirmPasswordController.text) {
                                    setState(() {
                                      _confirmPasswordError =
                                          'Passwords do not match.';
                                    });

                                    return;
                                  }

                                  setState(() {
                                    _isLoading = true;
                                  });

                                  final user = await _auth.signup(
                                    _firstNameController.text.trim(),
                                    _lastNameController.text.trim(),
                                    _emailController.text.trim(),
                                    _passwordController.text,
                                  );

                                  await user?.sendEmailVerification();
                                } on FirebaseAuthException catch (e) {
                                  setState(() {
                                    if (e.code == 'email-already-in-use') {
                                      _emailError =
                                          'An account already exists with this email.';
                                    } else if (e.code == 'invalid-email') {
                                      _emailError =
                                          'Please enter a valid email address.';
                                    } else if (e.code == 'weak-password') {
                                      _passwordError =
                                          'Use 7+ characters with uppercase, lowercase and a numbers.';
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
                                "Create Account",
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                      ),
                    ),

                    SizedBox(height: 32.0),

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

                    SizedBox(height: 20.0),

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
                                    imagePath:
                                        "assets/images/google_logo-new.png",
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
                                    imagePath:
                                        "assets/images/Facebook_logo-new.png",
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
