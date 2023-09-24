import 'package:fitgap/components/auth_button_withtext.dart';
import 'package:fitgap/services/auth.dart';
import 'package:flutter/material.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 50),
      child: ListView(
        children: [
          //Signout button

          AuthButton(
              color: Colors.black,
              icon: Icons.logout,
              text: 'Logout',
              logMethod: AuthService().signOut)
        ],
      ),
    );
  }
}
