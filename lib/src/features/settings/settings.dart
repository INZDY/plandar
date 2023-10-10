import 'package:fitgap/src/features/authentication/models/auth_button_withtext.dart';
import 'package:fitgap/src/features/profile/screens/profile.dart';
import 'package:fitgap/src/utils/auth/auth.dart';
import 'package:flutter/material.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 50),
      child: ListView(
        children: [
          //profile
          ListTile(
            leading: const Text('Profile', style: TextStyle(color: Colors.black),),
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const Profile(),
            )),
          ),

          //Signout button
          AuthButtonIconText(
              color: Colors.black,
              icon: Icons.logout,
              text: 'Logout',
              logMethod: AuthService().signOut)
        ],
      ),
    );
  }
}
