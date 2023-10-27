// import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitgap/src/utils/firestore/firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final userStream = FirebaseAuth.instance.authStateChanges();

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

    //sign user in, obtain auth result
    final UserCredential authResult =
        await FirebaseAuth.instance.signInWithCredential(credential);

    //add user detail to DB if new
    final userEmail = authResult.user?.email ?? '';
    final userExist = await FirestoreService().existUser(userEmail);

    if (!userExist) {
      FirestoreService().addUserDetails(
        userEmail.split('@').first,
        userEmail,
      );
    }
  }
}
