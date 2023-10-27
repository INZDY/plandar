import 'package:flutter/material.dart';

Widget editProfileField({
  required String label,
  required String initialValue,
  required Function(String) onChanged,
}) {
  return Padding(
    padding: const EdgeInsets.only(top: 5),
    child: TextFormField(
        initialValue: initialValue,
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white, fontSize: 20),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
        ),
        style: const TextStyle(color: Colors.white, fontSize: 20)),
  );
}
