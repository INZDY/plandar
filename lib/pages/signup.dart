// import 'package:email_validator/email_validator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitgap/components/utilities.dart';
import 'package:fitgap/components/auth_button.dart';
import 'package:fitgap/components/email_password_field.dart';
import 'package:fitgap/main.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fitgap/services/auth.dart';
import 'package:flutter/material.dart';

class SignupPage extends StatefulWidget {
  final Function()? onTap;

  const SignupPage({super.key, required this.onTap});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmController = TextEditingController();
  final _usernameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints.expand(),
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/bg.png'), fit: BoxFit.cover)),
      child: Scaffold(
        backgroundColor: const Color(0x00060239),
        body: Center(
          child: SingleChildScrollView(
            //validate before submitting
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 50,
                  ),

                  //login text
                  const Text(
                    'Create an account',
                    style: TextStyle(fontSize: 30, color: Colors.white),
                  ),

                  const SizedBox(
                    height: 50,
                  ),

                  //username textfield
                  CredentialText(
                    controller: _usernameController,
                    hintText: 'Username',
                    obscureText: false,
                    fieldType: -1,
                    warningText: '',
                  ),

                  const SizedBox(
                    height: 30,
                  ),

                  //email textfield
                  CredentialText(
                    controller: _emailController,
                    hintText: 'Email Address',
                    obscureText: false,
                    fieldType: 0,
                    warningText: 'Enter valid email',
                  ),

                  const SizedBox(
                    height: 30,
                  ),

                  //password textfield
                  CredentialText(
                    controller: _passwordController,
                    hintText: 'Password',
                    obscureText: true,
                    fieldType: 1,
                    warningText: 'Password must be more than 8 characters',
                  ),

                  const SizedBox(
                    height: 30,
                  ),

                  CredentialText(
                    controller: _passwordConfirmController,
                    hintText: 'Password',
                    obscureText: true,
                    fieldType: 1,
                    warningText: 'Password must be more than 8 characters',
                  ),

                  const SizedBox(
                    height: 50,
                  ),

                  //signup button
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
                          onPressed: signUp,
                          child: Text(
                            'Signup',
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                        ),
                      )),

                  const SizedBox(
                    height: 30,
                  ),

                  //or login with
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25),
                    child: Row(children: [
                      //Left divider
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Color(0xFFA6A6A6),
                        ),
                      ),

                      //Text
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          'Or signup with',
                          style:
                              TextStyle(fontSize: 14, color: Color(0xFFA6A6A6)),
                        ),
                      ),

                      //Right divider
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Color(0xFFA6A6A6),
                        ),
                      ),
                    ]),
                  ),

                  const SizedBox(
                    height: 25,
                  ),

                  //google + facebook login buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AuthButton(
                        icon: FontAwesomeIcons.google,
                        logMethod: AuthService().googleLogin,
                      ),
                      // SquareButton(imagePath: 'assets/icons/GoogleIcon.png'),
                      // SquareButton(imagePath: 'assets/icons/FacebookIcon.png'),
                    ],
                  ),

                  const SizedBox(
                    height: 50,
                  ),

                  //don't have account? create now
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Already have an account?',
                        style: TextStyle(color: Color(0xFFA6A6A6)),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: const Text(
                          'Login',
                          style: TextStyle(color: Color(0xFFAD76D8)),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future signUp() async {
    //form validate
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;

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
      if (passwordConfirmed()) {
        //create user
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        //add user details
        addUserDetails(
            _usernameController.text.trim(), _emailController.text.trim());
      }
      //pop loading
    } on FirebaseAuthException catch (e) {
      Utils.showSnackBar(e.message);
    }

    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }

  Future addUserDetails(String username, String email) async {
    await FirebaseFirestore.instance
        .collection('users')
        .add({'username': username, 'email': email});
  }

  bool passwordConfirmed() {
    if (_passwordController.text.trim() ==
        _passwordConfirmController.text.trim()) {
      return true;
    } else {
      return false;
    }
  }
}
