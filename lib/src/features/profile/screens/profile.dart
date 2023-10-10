// import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

import 'package:fitgap/src/utils/firestore/firestore.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final _firestoreService = FirestoreService();

  bool isLoading = true;

  Map<String, dynamic>? _userData;

  Future loadUserData() async {
    final userData = await _firestoreService.getUserData();

    setState(() {
      _userData = userData ?? {};
    });
  }

  @override
  void initState() {
    super.initState();
    loadUserData();
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(color: Colors.black),
        ),
        // backgroundColor: Colors.transparent,
        // shadowColor: Colors.transparent,
        centerTitle: true,
      ),
      body: SafeArea(
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView(
                  children: [
                    ListTile(
                      title: const Text('Username'),
                      subtitle: Text('${_userData?['username']}'),
                    ),
                  ],

                  //map all to listtiles
                  // children: (_userData?.entries ?? []).map((entry) {
                  //   return ListTile(
                  //     title: Text(entry.key),
                  //     subtitle: Text(entry.value.toString()),
                  //   );
                  // }).toList(),
                )),
    );
  }
}