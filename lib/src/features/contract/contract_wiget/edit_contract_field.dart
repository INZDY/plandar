import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool isEditMode;

  const CustomTextField({
    Key? key,
    required this.label,
    required this.controller,
    required this.isEditMode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xff2B1A6D),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '  $label:',
              style: const TextStyle(color: Colors.white, fontSize: 15),
            ),
            const SizedBox(height: 8),
            isEditMode
                ? TextField(
                    controller: controller,
                    style: const TextStyle(color: Colors.white, fontSize: 15),
                    enabled: isEditMode,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                    ),
                  )
                : Column(
                    children: [
                      Text(
                        '    ${_truncateText(controller.text)}',
                        style:
                            const TextStyle(color: Colors.white, fontSize: 15),
                      ),
                      const SizedBox(
                        height: 10,
                      )
                    ],
                  ),
          ],
        ),
      ),
    );
  }

//text limite length
  String _truncateText(String text) {
    const maxLength = 15;

    if (text.length <= maxLength) {
      return text;
    } else {
      return '${text.substring(0, maxLength - 3)}...';
    }
  }
}
