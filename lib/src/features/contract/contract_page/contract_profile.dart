import 'package:fitgap/src/features/contract/contract_wiget/edit_contract_field.dart';
import 'package:fitgap/src/utils/firestore/firestore.dart';
import 'package:flutter/material.dart';

class ContractProfile extends StatefulWidget {
  final String name;
  final String email;
  final String tel;
  final String contactId; // Add this line
  final Function(Map<String, dynamic> updatedData)
      onSaveChanges; // Add this line

  const ContractProfile({
    Key? key,
    required this.name,
    required this.email,
    required this.tel,
    required this.contactId, // Add this line
    required this.onSaveChanges, // Add this line
  }) : super(key: key);

  @override
  State<ContractProfile> createState() => _ContractProfileState();
}

class _ContractProfileState extends State<ContractProfile> {
  bool isEditMode = false;

  TextEditingController emailController = TextEditingController();
  TextEditingController telController = TextEditingController();
  TextEditingController noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize controllers with the provided data
    emailController.text = widget.email;
    telController.text = widget.tel;
    // You may add similar lines for other fields if needed
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      //big screen
      body: Container(
        width: double.infinity,
        height: double.infinity,
        alignment: Alignment.center,
        color: const Color.fromARGB(0, 45, 45, 45),
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
        //pop up area
        child: Container(
          height: MediaQuery.of(context).size.height * 0.7,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xff5936B4), Color(0xff362A84)],
            ),
            borderRadius: BorderRadius.circular(30.0),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Row(
                        children: [
                          //cancel | back to contacts
                          const Icon(
                            Icons.chevron_left,
                            color: Colors.white,
                          ),
                          Text(
                            isEditMode ? 'Cancel' : 'Contacts',
                            style: const TextStyle(
                              fontSize: 16.0,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),

                    //done| edit
                    TextButton(
                      onPressed: () {
                        if (isEditMode) {
                          widget.onSaveChanges({
                            'email': emailController.text,
                            'tel': telController.text,
                            'note': noteController.text,
                          });
                        }
                        setState(() {
                          isEditMode = !isEditMode;
                        });
                      },
                      child: Text(
                        isEditMode ? 'Done' : 'Edit',
                        style: TextStyle(
                          fontSize: isEditMode ? 14.0 : 16.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),

                //Profile image section
                const Icon(
                  Icons.account_circle,
                  size: 75,
                  color: Colors.white,
                ),
                Text(
                  widget.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),

                //call contact profile field
                //email
                CustomTextField(
                  label: 'Email',
                  controller: emailController,
                  isEditMode: isEditMode,
                ),
                const SizedBox(height: 20),

                //tel
                CustomTextField(
                  label: 'Tel',
                  controller: telController,
                  isEditMode: isEditMode,
                ),
                const SizedBox(height: 20),

                //Note
                CustomTextField(
                  label: 'Note',
                  controller: noteController,
                  isEditMode: isEditMode,
                ),
                const SizedBox(height: 20),

                //delete button
                Visibility(
                  visible: isEditMode,
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xff2B1A6D),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextButton(
                      onPressed: () {
                        FirestoreService().deleteContact(widget.contactId);
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        'Delete',
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Color.fromARGB(255, 255, 0, 0),
                        ),
                      ),
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
