// import 'package:email_validator/email_validator.dart';
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
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0x00060239),
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 50,
                ),

                //logo
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    'assets/icons/AppIcon.png',
                    height: 150,
                    width: 150,
                  ),
                ),

                const SizedBox(
                  height: 50,
                ),

                //login text
                const Text(
                  'Signup',
                  style: TextStyle(fontSize: 40, color: Colors.white),
                ),

                const SizedBox(
                  height: 50,
                ),

                //email textfield
                CredentialText(
                  controller: emailController,
                  hintText: 'Email Address',
                  obscureText: false,
                  fieldType: 0,
                  warningText: 'Enter valid email',
                ),

                const SizedBox(
                  height: 20,
                ),

                //password textfield
                CredentialText(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                  fieldType: 1,
                  warningText: 'Password must be more than 8 characters',
                ),

                const SizedBox(
                  height: 25,
                ),

                //signup button
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50)),
                      onPressed: signUp,
                      child: const Text('Signup'),
                    )),

                const SizedBox(
                  height: 25,
                ),

                //or login with
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  child: Row(children: [
                    //Left divider
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.white,
                      ),
                    ),

                    //Text
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        'Or signup with',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),

                    //Right divider
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.white,
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
                      style: TextStyle(color: Colors.white),
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
    );
  }

  Future<void> signUp() async {
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
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      //pop loading
    } on FirebaseAuthException catch (e) {
      Utils.showSnackBar(e.message);
    }

    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }
}
