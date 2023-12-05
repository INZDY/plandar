import 'package:flutter/material.dart';

//Non Email,Password /logout
//Google, Facebook, Apple
class AuthButtonIconText extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String text;
  final Function logMethod;

  const AuthButtonIconText({
    super.key,
    required this.color,
    required this.icon,
    required this.text,
    required this.logMethod,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: Icon(
        icon,
        color: Colors.red,
        size: 20,
      ),
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        backgroundColor: color,
      ),
      label: Text(
        text,
        style: const TextStyle(color: Colors.red),
      ),
      onPressed: () => logMethod(),
    );
  }
}
