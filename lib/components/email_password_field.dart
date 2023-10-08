import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

class CredentialText extends StatelessWidget {
  //text controller
  final dynamic controller;

  //check:
  //-1 : no criteria
  //0 : email
  //1 : password
  final int fieldType;

  final String hintText;
  final bool obscureText;
  final String warningText;

  const CredentialText(
      {super.key,
      required this.controller,
      required this.hintText,
      required this.obscureText,
      required this.fieldType,
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
          style: const TextStyle(fontSize: 18),
          decoration: InputDecoration(
            hintText: hintText,
            border: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
                borderRadius: BorderRadius.all(Radius.circular(10))),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 14, horizontal: 15),
            fillColor: const Color(0xFFD9D9D9),
            filled: true,
          ),

          //validate input
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (input) => input != null &&
                  fieldType != -1 &&
                  ((fieldType == 0)
                      ? !EmailValidator.validate(input)
                      : input.length < 8)
              ? warningText
              : null,
        ),
      ),
    );
  }
}
