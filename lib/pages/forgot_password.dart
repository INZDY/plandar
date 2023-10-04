import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitgap/components/Utilities.dart';
import 'package:fitgap/components/email_password_field.dart';
import 'package:fitgap/main.dart';
import 'package:flutter/material.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reset Password'),
      ),
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                const Text('Enter an email to reset your password'),
                const SizedBox(
                  height: 25,
                ),
                CredentialText(
                  controller: emailController,
                  hintText: 'Email Address',
                  obscureText: false,
                  fieldType: 0,
                  warningText: 'Enter valid email',
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50)),
                      onPressed: forgotPassword,
                      child: const Text('Login'),
                    )),
              ],
            ),
          )),
    );
  }

  Future<void> forgotPassword() async {
    //loading
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    //authentication
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: emailController.text.trim(),
      );
      //pop loading
    } on FirebaseAuthException catch (e) {
      Utils.showSnackBar(e.message);
    }

    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }
}
