import 'package:fitgap/src/features/authentication/models/auth_button_withtext.dart';
import 'package:fitgap/src/features/profile/screens/profile.dart';
import 'package:fitgap/src/utils/auth/auth.dart';
import 'package:flutter/material.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black, Color.fromRGBO(7, 2, 58, 1)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Container(
          padding: const EdgeInsets.only(top: 50),
          child: ListView(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
              ),
              //profile
              ListTile(
                leading: const Text('Profile'),
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
        ),
      ),
    );
  }
}
