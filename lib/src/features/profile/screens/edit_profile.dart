import 'package:flutter/material.dart';

class EditProfile extends StatelessWidget {
  const EditProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Done'))
        ],
      ),
      body: Container(),
    );
  }
}
