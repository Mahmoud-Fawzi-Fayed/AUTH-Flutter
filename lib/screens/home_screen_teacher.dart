// ignore_for_file: prefer_const_constructors, avoid_print, library_private_types_in_public_api

import 'package:firebase_auth/firebase_auth.dart';
import 'package:auth0/screens/signin_screen.dart';
import 'package:flutter/material.dart';

class HomeScreencopy extends StatefulWidget {
  const HomeScreencopy({Key? key}) : super(key: key);

  @override
  _HomeScreencopyState createState() => _HomeScreencopyState();
}

class _HomeScreencopyState extends State<HomeScreencopy> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        body: Center(
          child: ElevatedButton(
            child: Text("Logout - teacher"),
            onPressed: () {
              FirebaseAuth.instance.signOut().then((value) {
                print("Signed Out");
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SignInScreen()));
              });
            },
          ),
        ),
      ),
    );
  }
}
