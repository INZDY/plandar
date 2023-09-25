import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

class CredentialText extends StatelessWidget {
  //text controller
  final dynamic controller;

  //check if is email field
  final bool isEmail;

  final String hintText;
  final bool obscureText;
  final String warningText;

  const CredentialText(
      {super.key,
      required this.controller,
      required this.hintText,
      required this.obscureText,
      required this.isEmail,
      required this.warningText});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Container(
        constraints: const BoxConstraints(minHeight: 50),
        child: TextFormField(
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            hintText: hintText,
            border: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
                borderRadius: BorderRadius.all(Radius.circular(15))),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
            fillColor: Colors.grey,
            filled: true,
          ),

          //validate input
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (input) => input != null &&
                  ((isEmail == true)
                      ? !EmailValidator.validate(input)
                      : input.length < 8)
              ? warningText
              : null,
        ),
      ),
    );
  }
}
