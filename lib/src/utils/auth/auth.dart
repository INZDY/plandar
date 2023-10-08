// import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final userStream = FirebaseAuth.instance.authStateChanges();
  final user = FirebaseAuth.instance.currentUser;

  //Email login is in login_page

  //Logout
  Future signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  //Google sign in
  Future googleLogin() async {
    //sign out first
    await GoogleSignIn().signOut();

    //interative sign in
    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

    //obtain auth detils
    final GoogleSignInAuthentication gAuth = await gUser!.authentication;

    //create new credential for user
    final credential = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );

    await FirebaseAuth.instance.signInWithCredential(credential);
  }
}
