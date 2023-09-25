import 'package:flutter/material.dart';

//Non Email,Password / logout
//Google, Facebook, Apple
class AuthButton extends StatelessWidget {
  // final Color color;
  final IconData icon;
  // final String text;
  final Function logMethod;

  const AuthButton({
    super.key,
    // required this.color,
    required this.icon,
    // required this.text,
    required this.logMethod,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Colors.white,
      child: IconButton.outlined(
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
