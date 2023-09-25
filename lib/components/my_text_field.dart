// import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  //text controller
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
        child: TextFormField(
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            hintText: hintText,
            border: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
              borderRadius: BorderRadius.all(Radius.circular(10))
            ),
            fillColor: Colors.grey,
            filled: true,
          ),
          //validate input
          // autovalidateMode: AutovalidateMode.onUserInteraction,
          // validator: (email) => email != null && !EmailValidator.validate(email)
          //     ? 'Enter a valid email'
          //     : null,
        ),
      ),
    );
  }
}
