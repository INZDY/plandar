import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitgap/src/features/profile/models/edit_fields.dart';
import 'package:fitgap/src/utils/firestore/firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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

  TextEditingController dateInput = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    DateTime picked = (await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1900),
        lastDate: DateTime(2100)))!;

    String formattedDate = DateFormat('dd MMMM yyyy').format(picked);
    setState(() {
      selectedDate = picked;
      dateInput.text = formattedDate;

      editedProfileData['birthday'] = selectedDate;
    });
  }

  void saveProfileChanges() {
    FirestoreService().updateUserDetails(editedProfileData);
    Navigator.pop(context);
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
          style: TextStyle(color: Colors.red, fontSize: 20),
        ),
        actions: [
          TextButton(
            onPressed: () => saveProfileChanges(),
            child: const Text(
              'DONE',
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
              ),
            ),
          )
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
          child: SingleChildScrollView(
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
                        color: Color(0xFF2B1A6D),
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
                          height: 5,
                          color: Colors.white,
                          thickness: 0.5,
                        ),

                        //fields
                        editProfileField(
                          label: 'Username',
                          initialValue:
                              editedProfileData['username'].toString(),
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
                          initialValue:
                              editedProfileData['firstname'].toString(),
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
                          initialValue:
                              editedProfileData['lastname'].toString(),
                          onChanged: (value) =>
                              editedProfileData['lastname'] = value,
                        ),

                        //gendertext
                        const Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Text(
                            'Gender',
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                        ),

                        //gender picker
                        DropdownButton(
                          //styling
                          style: const TextStyle(
                              color: Colors.white, fontSize: 20),
                          dropdownColor: const Color(0xFF9DE2FF),
                          iconEnabledColor: Colors.white,
                          underline: Container(
                            height: 1,
                            color: Colors.white,
                          ),
                          isExpanded: true,

                          //logic
                          value: selectedGender,
                          items: ['Male', 'Female', 'Other'].map((value) {
                            return DropdownMenuItem(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedGender = newValue!;
                              editedProfileData['gender'] = newValue;
                            });
                          },
                        ),

                        //birthday picker
                        TextField(
                          controller: dateInput,
                          decoration: const InputDecoration(
                            labelText: 'Birthday',
                            labelStyle:
                                TextStyle(color: Colors.white, fontSize: 20),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                          ),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                          onTap: () => _selectDate(context),
                          readOnly: true,
                        ),

                        editProfileField(
                          label: 'Address',
                          initialValue: editedProfileData['address'].toString(),
                          onChanged: (value) =>
                              editedProfileData['address'] = value,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
