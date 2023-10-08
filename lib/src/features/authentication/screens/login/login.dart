// import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitgap/src/common_widgets/snackbar.dart';
import 'package:fitgap/src/common_widgets/text_field_validate_controller.dart';
import 'package:fitgap/main.dart';
import 'package:fitgap/src/features/authentication/models/auth_button.dart';
import 'package:fitgap/src/features/authentication/screens/forgot_password/forgot_password.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fitgap/src/utils/auth/auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;

  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

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
                  Container(
                    height: 50,
                    width: 200,
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/icons/plandarlogo.png'),
                            fit: BoxFit.fitWidth)),
                  ),

                  const SizedBox(
                    height: 30,
                  ),

                  //login text
                  const Text(
                    'Login',
                    style: TextStyle(fontSize: 30, color: Colors.white),
                  ),

                  const SizedBox(
                    height: 50,
                  ),

                  //email textfield
                  CredentialText(
                    controller: _emailController,
                    hintText: 'Email Address',
                    obscureText: false,
                    fieldType: -1,
                    warningText: '',
                  ),

                  const SizedBox(
                    height: 30,
                  ),

                  //password textfield
                  CredentialText(
                    controller: _passwordController,
                    hintText: 'Password',
                    obscureText: true,
                    fieldType: -1,
                    warningText: '',
                  ),

                  const SizedBox(
                    height: 30,
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
                    height: 50,
                  ),

                  //login button
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
                          onPressed: signIn,
                          child: Text(
                            'Login',
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
                          'Or login with',
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
                      AuthButtonIcon(
                        icon: FontAwesomeIcons.google,
                        logMethod: AuthService().googleLogin,
                      ),
                    ],
                  ),

                  const SizedBox(
                    height: 100,
                  ),

                  //don't have account? create now
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Not a member?',
                        style:
                            TextStyle(fontSize: 14, color: Color(0xFFA6A6A6)),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: const Text(
                          'Signup now',
                          style:
                              TextStyle(fontSize: 14, color: Color(0xFFAD76D8)),
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
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      //pop loading
    } on FirebaseAuthException catch (e) {
      SnackbarUtil.showSnackBar(e.message);
    }

    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }
}
