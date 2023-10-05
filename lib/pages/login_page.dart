// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:fitgap/components/my_text_field.dart';
// import 'package:fitgap/components/square_tile.dart';
// import 'package:flutter/material.dart';

// class LoginPage extends StatelessWidget {
//   LoginPage({super.key});

//   final emailController = TextEditingController();
//   final passwordController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     //image background
//     return Container(
//       decoration: const BoxDecoration(
//         image: DecorationImage(
//             image: AssetImage('assets/icons/bg.png'), fit: BoxFit.cover),
//       ),
//       child: Scaffold(
//         backgroundColor: Colors.transparent,
//         body: Center(
//           child: Column(
//             children: [
//               const SizedBox(
//                 height: 20,
//               ),

//               //logo
//               ClipRRect(
//                 borderRadius: BorderRadius.circular(20),
//                 child: Image.asset(
//                   'assets/icons/plandarlogo.png',
//                   height: 110,
//                   width: 500,
//                 ),
//               ),

//               const SizedBox(
//                   //height: 50,
//                   ),

//               //login text
//               const Text(
//                 'Login',
//                 style: TextStyle(fontSize: 40, color: Colors.white),
//               ),

//               const SizedBox(
//                 height: 50,
//               ),

//               //email textfield
//               MyTextField(
//                   controller: emailController,
//                   hintText: 'Email Address',
//                   obscureText: false),

//               const SizedBox(
//                 height: 20,
//               ),

//               //password textfield
//               MyTextField(
//                   controller: passwordController,
//                   hintText: 'Password',
//                   obscureText: true),

//               const SizedBox(
//                 height: 20,
//               ),

//               //remember password checkbox
//               //forget password
//               const Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 25),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       '',
//                       style: TextStyle(color: Colors.white),
//                     ),
//                     Text('Forgot passsword',
//                         style: TextStyle(color: Colors.white))
//                   ],
//                 ),
//               ),

//               const SizedBox(
//                 height: 25,
//               ),

//               //login button
//               ElevatedButton.icon(
//                 icon: const Icon(Icons.lock_open),
//                 label: const Text(
//                   'Login',
//                   style: TextStyle(fontSize: 20),
//                 ),
//                 onPressed: () {}, //login button change size
//                 style: ElevatedButton.styleFrom(
//                   fixedSize: const Size(300, 50),
//                 ),
//               ),

//               const SizedBox(
//                 height: 25,
//               ),

//               //or login with
//               const Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 25),
//                 child: Row(children: [
//                   //Left divider
//                   Expanded(
//                     child: Divider(
//                       thickness: 0.5,
//                       color: Colors.white,
//                     ),
//                   ),

//                   //Text
//                   Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 10),
//                     child: Text(
//                       'Or login with',
//                       style: TextStyle(color: Colors.white),
//                     ),
//                   ),

//                   //Right divider
//                   Expanded(
//                     child: Divider(
//                       thickness: 0.5,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ]),
//               ),

//               const SizedBox(
//                 height: 25,
//               ),

//               //google + facebook login buttons
//               const Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   SquareTile(imagePath: 'assets/icons/GoogleIcon.png'),
//                   SquareTile(imagePath: 'assets/icons/FacebookIcon.png'),
//                 ],
//               )
//               //don't have account? create now
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Future signIn() async {
//     await FirebaseAuth.instance.signInWithEmailAndPassword(
//       email: emailController.text.trim(),
//       password: passwordController.text.trim(),
//     );
//   }
// }
