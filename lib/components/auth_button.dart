import 'package:flutter/material.dart';

//Google, Facebook, Apple login/signup
//logout
class AuthButton extends StatelessWidget {
  // final Color color;
  final IconData icon;
  final Function logMethod;

  const AuthButton({
    super.key,
    // required this.color,
    required this.icon,
    required this.logMethod,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Colors.white,
      child: IconButton(
        icon: Icon(
          icon,
          color: Colors.black,
          size: 20,
        ),
        onPressed: () => logMethod(),
      ),
    );
  }
}
