// ignore_for_file: use_build_context_synchronously, avoid_print, library_private_types_in_public_api

import 'package:auth0/reusable_widgets/reusable_widget.dart';
import 'package:auth0/screens/signin_screen.dart';
import 'package:auth0/utils/color_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _userNameTextController = TextEditingController();
  final String _selectedRole = 'student';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Sign Up",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              hexStringToColor("216ea4"),
              hexStringToColor("288bd0"),
              hexStringToColor("28a6ff"),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 120, 20, 0),
            child: Column(
              children: <Widget>[
                const SizedBox(
                  height: 20,
                ),
                reusableTextField(
                  "Enter UserName",
                  Icons.person_outline,
                  false,
                  _userNameTextController,
                ),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField(
                  "Enter Email",
                  Icons.email,
                  false,
                  _emailTextController,
                ),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField(
                  "Enter Password",
                  Icons.lock,
                  true,
                  _passwordTextController,
                ),
                const SizedBox(
                  height: 20,
                ),
                const SizedBox(
                  height: 20,
                ),
                firebaseUIButton(context, "Sign Up", () async {
                  try {
                    UserCredential userCredential = await FirebaseAuth.instance
                        .createUserWithEmailAndPassword(
                      email: _emailTextController.text,
                      password: _passwordTextController.text,
                    );

                    await userCredential.user!.sendEmailVerification();

                    await FirebaseAuth.instance.signOut();

                    await FirebaseFirestore.instance
                        .collection("roles")
                        .doc(userCredential.user!.uid)
                        .set({
                      'roles': _selectedRole,
                      'username' : _userNameTextController.text,
                      'password' : _passwordTextController.text,
                      'email' : _emailTextController.text,
                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Verification email sent. Please check your email to verify.',
                        ),
                      ),
                    );

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SignInScreen(),
                      ),
                    );
                  } catch (error) {
                    if (error is FirebaseAuthException) {
                      if (error.code == 'email-already-in-use') {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Email is already in use. Please use another email.',
                            ),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'An error occurred. Please try again later.',
                            ),
                          ),
                        );
                        print(
                            "Firebase Authentication Error: ${error.toString()}");
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'An error occurred. Please try again later.',
                          ),
                        ),
                      );
                      print("Error: ${error.toString()}");
                    }
                  }
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget roleSelectionDropdown() {
  //   return DropdownButton<String>(
  //     value: _selectedRole,
  //     items: const [
  //       DropdownMenuItem(
  //         value: 'student',
  //         child: Text('Student'),
  //       ),
  //       DropdownMenuItem(
  //         value: 'teacher',
  //         child: Text('Teacher'),
  //       ),
  //     ],
  //     onChanged: (value) {
  //       setState(() {
  //         _selectedRole = value;
  //       });
  //     },
  //   );
  // }
}
