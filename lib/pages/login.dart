import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitgap/components/my_text_field.dart';
import 'package:fitgap/components/square_tile.dart';
import 'package:fitgap/services/auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0x00060239),
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 100,
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
              'Login',
              style: TextStyle(fontSize: 40, color: Colors.white),
            ),

            const SizedBox(
              height: 50,
            ),

            //email textfield
            MyTextField(
                controller: emailController,
                hintText: 'Email Address',
                obscureText: false),

            const SizedBox(
              height: 20,
            ),

            //password textfield
            MyTextField(
                controller: passwordController,
                hintText: 'Password',
                obscureText: true),

            const SizedBox(
              height: 20,
            ),

            //remember password checkbox
            //forget password
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '',
                    style: TextStyle(color: Colors.white),
                  ),
                  Text('Forgot passsword',
                      style: TextStyle(color: Colors.white))
                ],
              ),
            ),

            const SizedBox(
              height: 25,
            ),

            //login button
            Flexible(
              child: ElevatedButton.icon(
                onPressed: signIn,
                icon: const Icon(Icons.lock_open),
                label: const Text('Login')
              )
            ),

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
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SquareTile(imagePath: 'assets/icons/GoogleIcon.png'),
                SquareTile(imagePath: 'assets/icons/FacebookIcon.png'),
              ],
            )
            //don't have account? create now
          ],
        ),
      ),
    );
  }

  Future<void> signIn() async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );
  }
}