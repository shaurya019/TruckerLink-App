// ignore_for_file: use_build_context_synchronously
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import "package:trucker/screens/navigation_screen/bottom.dart";

class AuthService {
  Future<void> signInwithgoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication gAuth = await gUser!.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken,
        idToken: gAuth.idToken,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
      // If login is successful, navigate to the second page
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => Bottom(selectedIndex: 0, newIndex: 0)));
    } catch (error) {
      print("Error signing in with Google: $error");
      // Handle the error as needed.
    }
  }
}
