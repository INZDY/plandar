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
  _ContractProfileState createState() => _ContractProfileState();
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
    return AlertDialog(
      backgroundColor: Colors.transparent,
      content: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xff5936B4), Color(0xff362A84)],
            ),
            borderRadius: BorderRadius.circular(30.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.8,
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Row(
                          children: [
                            //cancel | back to contacts
                            Icon(
                              Icons.chevron_left,
                              color: Colors.white,
                            ),
                            Text(
                              isEditMode ? 'Cancel' : 'Contacts',
                              style: TextStyle(
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
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),

                  //call contact profile field
                  //email
                  CustomTextField(
                    label: 'Email',
                    controller: emailController,
                    isEditMode: isEditMode,
                  ),
                  SizedBox(height: 20),

                  //tel
                  CustomTextField(
                    label: 'Tel',
                    controller: telController,
                    isEditMode: isEditMode,
                  ),
                  SizedBox(height: 20),

                  //Note
                  CustomTextField(
                    label: 'Note',
                    controller: noteController,
                    isEditMode: isEditMode,
                  ),
                  SizedBox(height: 20),

                  //delete button
                  Visibility(
                    visible: isEditMode,
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xff2B1A6D),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextButton(
                        onPressed: () async {
                          await FirestoreService()
                              .deleteContact(widget.contactId);
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
      ),
    );
  }
}
