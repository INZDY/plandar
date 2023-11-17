import 'package:fitgap/src/features/contract/contract_wiget/edit_contract_field.dart';
import 'package:fitgap/src/utils/firestore/firestore.dart';
import 'package:flutter/material.dart';

class ContractProfile extends StatefulWidget {
  final String name;
  final String email;
  final String tel;
  final String contactId;
  final Function(Map<String, dynamic> updatedData) onSaveChanges;

  const ContractProfile({
    Key? key,
    required this.name,
    required this.email,
    required this.tel,
    required this.contactId,
    required this.onSaveChanges,
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

    emailController.text = widget.email;
    telController.text = widget.tel;
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
                            Icon(
                              Icons.chevron_left,
                              color: Colors.white,
                            ),
                            Text(
                              isEditMode ? 'Cancel' : 'Contracts',
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),

                      //done|edit
                      TextButton(
                        onPressed: () {
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

                  // icon picute
                  Icon(
                    Icons.account_circle,
                    size: 75,
                    color: Colors.white,
                  ),

                  //name
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

                  // email
                  CustomTextField(
                    label: 'Email',
                    controller: emailController,
                    isEditMode: isEditMode,
                  ),
                  SizedBox(height: 20),

                  //Tel
                  CustomTextField(
                    label: 'Tel',
                    controller: telController,
                    isEditMode: isEditMode,
                  ),
                  SizedBox(height: 20),

                  //note
                  CustomTextField(
                    label: 'Note',
                    controller: noteController,
                    isEditMode: isEditMode,
                  ),
                  SizedBox(height: 20),

                  //delete button visilbe with edit was clicked
                  Visibility(
                    visible: isEditMode,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(0xff2B1A6D),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextButton(
                        onPressed: () async {
                          await FirestoreService()
                              .deleteContact(widget.contactId);
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          'Delete',
                          style: TextStyle(
                            fontSize: 14.0,
                            color: const Color.fromARGB(255, 255, 0, 0),
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
