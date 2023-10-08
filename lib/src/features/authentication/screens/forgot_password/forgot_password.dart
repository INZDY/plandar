import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitgap/src/common_widgets/snackbar.dart';
import 'package:fitgap/src/common_widgets/text_field_validate_controller.dart';
import 'package:fitgap/main.dart';
import 'package:flutter/material.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints.expand(),
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/bg.png'), fit: BoxFit.cover)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text(
            'Reset Password',
          ),
          backgroundColor: Colors.transparent,
        ),
        body: Center(
            child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 25),
                child: Text(
                  'Enter an email to reset your password',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, color: Color(0xFFA6A6A6)),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              CredentialText(
                controller: _emailController,
                hintText: 'Email Address',
                obscureText: false,
                fieldType: 0,
                warningText: 'Enter valid email',
              ),
              const SizedBox(
                height: 50,
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                        gradient: const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color(0xFFFFFFFF),
                              Color(0xFF5B8AEB),
                            ]),
                        borderRadius: BorderRadius.circular(5)),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          minimumSize: const Size.fromHeight(50)),
                      onPressed: forgotPassword,
                      child: Text(
                        'Send Password Reset',
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                    ),
                  )),
            ],
          ),
        )),
      ),
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
        email: _emailController.text.trim(),
      );
      //pop loading
    } on FirebaseAuthException catch (e) {
      SnackbarUtil.showSnackBar(e.message);
    }

    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }
}
