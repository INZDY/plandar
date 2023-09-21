import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final dynamic controller;
  final String hintText;
  final bool obscureText;

  const MyTextField(
      {super.key,
      required this.controller,
      required this.hintText,
      required this.obscureText});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: SizedBox(
        height: 50,
        child: TextField(
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            hintText: hintText,
            enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
                borderRadius: BorderRadius.all(Radius.circular(10))),
            focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
                borderRadius: BorderRadius.all(Radius.circular(10))),
            fillColor: Colors.grey,
            filled: true,
          ),
        ),
      ),
    );
  }
}
