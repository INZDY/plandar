import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitgap/src/features/profile/models/edit_fields.dart';
import 'package:flutter/material.dart';

class EditProfile extends StatefulWidget {
  final Map<String, dynamic> currentProfile;

  const EditProfile({super.key, required this.currentProfile});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  late Map<String, dynamic> editedProfileData;
  late String selectedGender;
  late DateTime selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = (await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1900),
        lastDate: DateTime(2100)))!;

    if (picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    //initialize edited data to be current data
    editedProfileData = Map.from(widget.currentProfile);

    Timestamp t = editedProfileData['birthday'] as Timestamp;

    selectedGender = editedProfileData['gender'].toString();
    selectedDate = t.toDate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text(
          'Edit Profile',
          style: TextStyle(color: Colors.red),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Done'))
        ],
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

        //widget render
        child: Center(
          child: Column(
            children: [
              //image
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: const BoxDecoration(
                      color: Colors.white, shape: BoxShape.circle),
                ),
              ),

              //text under image
              const Text('Change Profile Picture'),

              //Personal Information
              Padding(
                padding: const EdgeInsets.all(10),
                child: Container(
                  decoration: const BoxDecoration(
                      color: Color(0xFF191785),
                      borderRadius: BorderRadius.all(Radius.circular(10))),
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

                      //fields
                      editProfileField(
                        label: 'Username',
                        initialValue: editedProfileData['username'].toString(),
                        onChanged: (value) =>
                            editedProfileData['username'] = value,
                      ),
                      editProfileField(
                        label: 'Tel',
                        initialValue:
                            editedProfileData['phone_number'].toString(),
                        onChanged: (value) =>
                            editedProfileData['phone_number'] = value,
                      ),
                      editProfileField(
                        label: 'First Name',
                        initialValue: editedProfileData['firstname'].toString(),
                        onChanged: (value) =>
                            editedProfileData['firstname'] = value,
                      ),
                      editProfileField(
                        label: 'Middle Name',
                        initialValue:
                            editedProfileData['middlename'].toString(),
                        onChanged: (value) =>
                            editedProfileData['middlename'] = value,
                      ),
                      editProfileField(
                        label: 'Last Name',
                        initialValue: editedProfileData['lastname'].toString(),
                        onChanged: (value) =>
                            editedProfileData['lastname'] = value,
                      ),
                      editProfileField(
                        label: 'Last Name',
                        initialValue: editedProfileData['lastname'].toString(),
                        onChanged: (value) =>
                            editedProfileData['lastname'] = value,
                      ),

                      //gender picker
                      DropdownButton(
                          value: selectedGender,
                          items: ['Male', 'Female', 'Other'].map((value) {
                            return DropdownMenuItem(
                                value: value, child: Text(value));
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedGender = newValue!;
                            });
                          }),

                      //date picker
                      TextButton(
                          onPressed: () => _selectDate(context),
                          child: const Text('Select date of birth')),
                      Text('Selected Date: ${selectedDate.toLocal()}'.split(' ')[0])
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
