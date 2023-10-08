import 'package:fitgap/src/features/authentication/applications/login_signup_switch.dart';
import 'package:flutter/material.dart';
import 'package:fitgap/src/utils/auth/auth.dart';
import 'package:fitgap/src/features/home/home.dart';
// import 'package:fitgap/pages/login.dart';

//Main Page : Auth/Home
class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: AuthService().userStream,
        builder: (context, snapshot) {
          //if connecting
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          //if error
          else if (snapshot.hasError) {
            return const Center(
              child: Text('error'),
            );
          }

          //if log in correct
          else if (snapshot.hasData) {
            return const Home();
          }

          //if not logged in
          else {
            return const LoginOrSignupPage();
          }
        });
  }
}
