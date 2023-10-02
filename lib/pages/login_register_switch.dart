import 'package:fitgap/pages/login.dart';
import 'package:fitgap/pages/signup.dart';
import 'package:flutter/material.dart';

class LoginOrSignupPage extends StatefulWidget {
  const LoginOrSignupPage({super.key});

  @override
  State<LoginOrSignupPage> createState() => _LoginOrSignupPageState();
}

class _LoginOrSignupPageState extends State<LoginOrSignupPage> {
  bool isLoginPage = true;

  //arrow function, only one statement
  void togglePage() => setState(() {
        isLoginPage = !isLoginPage;
      });

  @override
  Widget build(BuildContext context) => isLoginPage
      ? LoginPage(onTap: togglePage)
      : SignupPage(onTap: togglePage);
}
