// import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitgap/components/utilities.dart';
import 'package:fitgap/components/auth_button.dart';
import 'package:fitgap/components/email_password_field.dart';
import 'package:fitgap/main.dart';
import 'package:fitgap/pages/forgot_password.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fitgap/services/auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;

  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints.expand(),
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/bg.png'), fit: BoxFit.cover)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
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
                      'assets/icons/plandarlogo.png',
                      height: 110,
                      width: 500,
                    ),
                  ),

                  const SizedBox(
                    height: 50,
                  ),

                  //login text
                  const Text(
                    'Login',
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
                    fieldType: -1,
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
                    fieldType: -1,
                    warningText: 'Password must be more than 8 characters',
                  ),

                  const SizedBox(
                    height: 10,
                  ),

                  //remember password checkbox
                  //forget password
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () =>
                              Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const ForgotPassword(),
                          )),
                          child: const Text('Forgot passsword',
                              textAlign: TextAlign.right,
                              style: TextStyle(color: Colors.white)),
                        )),
                  ),

                  const SizedBox(
                    height: 10,
                  ),

                  //login button
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            minimumSize: const Size.fromHeight(50)),
                        onPressed: signIn,
                        child: const Text('Login'),
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
                          'Or login with',
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
                        'Not a member?',
                        style: TextStyle(color: Colors.white),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: const Text(
                          'Register now',
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

  Future<void> signIn() async {
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
      await FirebaseAuth.instance.signInWithEmailAndPassword(
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
