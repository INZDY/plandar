import 'package:flutter/material.dart';

class AddContractField extends StatelessWidget {
  final String InputBox;

  const AddContractField({
    super.key,
    required this.InputBox,
  });

  Icon GetIcon() {
    switch (InputBox) {
      case 'Name':
        return Icon(Icons.person, color: Color(0xffA6A6A6));
      case 'Email':
        return Icon(Icons.email, color: Color(0xffA6A6A6));
      case 'Tel':
        return Icon(Icons.call, color: Color(0xffA6A6A6));

      default:
        return Icon(Icons.person, color: Color(0xffA6A6A6));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      //input box
      padding: const EdgeInsets.all(10.0),
      child: SizedBox(
        width: 500,
        child: TextField(
          obscureText: false,
          style: TextStyle(
            color: Color(0xffA6A6A6),
          ),
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Color(0xffA6A6A6),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Color(0xffA6A6A6),
              ),
            ),
            labelText: InputBox,
            labelStyle: TextStyle(
              color: Color(0xffA6A6A6),
            ),
            prefixIcon: GetIcon(),
          ),
        ),
      ),
    );
  }
}
