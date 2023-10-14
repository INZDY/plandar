import 'package:flutter/material.dart';

Widget editProfileField({
  required String label,
  required String initialValue,
  required Function(String) onChanged,
}) {
  return Padding(
    padding: const EdgeInsets.only(top: 0),
    child: TextFormField(
        initialValue: initialValue,
        onChanged: onChanged,
        decoration: InputDecoration(labelText: label)),
  );
}
