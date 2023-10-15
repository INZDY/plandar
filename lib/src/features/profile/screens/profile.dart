import 'package:fitgap/src/features/profile/models/month_constants.dart';
import 'package:fitgap/src/features/profile/screens/edit_profile.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitgap/src/utils/firestore/firestore.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Map<String, dynamic>? _userData;
  DateTime? date;

  bool isLoading = true;

  Future loadUserData() async {
    final userData = await FirestoreService().getUserData();
    Timestamp t = userData?['birthday'] as Timestamp;

    setState(() {
      _userData = userData ?? {};
      date = t.toDate();
    });
  }

  @override
  void initState() {
    super.initState();
    loadUserData();
    Future.delayed(const Duration(milliseconds: 700), () {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: const Text(
            'Profile',
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => EditProfile(
                          currentProfile: _userData!,
                        ))),
                child: const Text('EDIT', style: TextStyle(fontSize: 15),))
          ],
          // backgroundColor: Colors.transparent,
          // shadowColor: Colors.transparent,
          centerTitle: true,
        ),
        body: Container(
          //background
          width: double.maxFinite,
          height: double.maxFinite,
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF000000), Color(0xFF07023A)])),

          //Widget Render
          child: SafeArea(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView(
                    children: [
                      //Quick Profile
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Container(
                          decoration: const BoxDecoration(
                              color: Color(0xFF191785),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          padding: const EdgeInsets.all(15),
                          child: Row(
                            children: [
                              //image
                              const SizedBox(
                                width: 100,
                              ),

                              //username, email, tel.
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Username: ${_userData?['username']}',
                                  ),
                                  Text(
                                    'Email: ${_userData?['email']}',
                                  ),
                                  Text(
                                    'Tel.: ${_userData?['phone_number']}',
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                      //Personal Information
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Container(
                          decoration: const BoxDecoration(
                              color: Color(0xFF191785),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          padding: const EdgeInsets.all(15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Personal Information',
                                style: TextStyle(color: Colors.white),
                              ),
                              const Divider(
                                height: 10,
                                color: Colors.white,
                                thickness: 0.5,
                              ),
                              Text(
                                'First Name: ${_userData?['firstname']}',
                              ),
                              Text(
                                'Middle Name: ${_userData?['middlename']}',
                              ),
                              Text(
                                'Last Name: ${_userData?['lastname']}',
                              ),
                              Text(
                                'Gender: ${_userData?['gender']}',
                              ),
                              Text(
                                'Birthday: ${date?.day} ${NumberToMonthMap.monthsInYear[date?.month]} ${date?.year}',
                              ),
                              Text(
                                'Address: ${_userData?['address']}',
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],

                    //map all to listtiles
                    // children: (_userData?.entries ?? []).map((entry) {
                    //   return ListTile(
                    //     title: Text(entry.key),
                    //     subtitle: Text(entry.value.toString()),
                    //   );
                    // }).toList(),
                  ),
          ),
        ));
  }
}
