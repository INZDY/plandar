import 'package:flutter/material.dart';

class AddContractField extends StatefulWidget {
  final String inputBox;
  final Function(String) onValueChanged;

  const AddContractField({
    Key? key,
    required this.inputBox,
    required this.onValueChanged,
  }) : super(key: key);

  @override
  State<AddContractField> createState() => _AddContractFieldState();
}

class _AddContractFieldState extends State<AddContractField> {
  late TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      //input box
      padding: const EdgeInsets.all(10.0),
      child: SizedBox(
        width: 500,
        child: TextField(
          controller: _textController,
          obscureText: false,
          style: const TextStyle(
            color: Color(0xffA6A6A6),
          ),
          decoration: InputDecoration(
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                color: Color(0xffA6A6A6),
              ),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                color: Color(0xffA6A6A6),
              ),
            ),
            labelText: widget.inputBox,
            labelStyle: const TextStyle(
              color: Color(0xffA6A6A6),
            ),
            prefixIcon: getIcon(widget.inputBox),
          ),
          onChanged: (value) {
            widget.onValueChanged(value);
          },
        ),
      ),
    );
  }

  Icon getIcon(String inputBox) {
    switch (inputBox) {
      case 'Name':
        return const Icon(Icons.person, color: Color(0xffA6A6A6));
      case 'Email':
        return const Icon(Icons.email, color: Color(0xffA6A6A6));
      case 'Tel':
        return const Icon(Icons.call, color: Color(0xffA6A6A6));
      default:
        return const Icon(Icons.person, color: Color(0xffA6A6A6));
    }
  }
}
