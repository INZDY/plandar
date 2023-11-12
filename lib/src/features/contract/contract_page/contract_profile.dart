import 'package:fitgap/src/features/contract/contract_wiget/edit_contract_field.dart';
import 'package:flutter/material.dart';

class ContractProfile extends StatefulWidget {
  final String name;

  const ContractProfile({Key? key, required this.name}) : super(key: key);

  @override
  _ContractProfileState createState() => _ContractProfileState();
}

class _ContractProfileState extends State<ContractProfile> {
  bool isEditMode = false;
  // default and var for input box
  TextEditingController emailController =
      TextEditingController(text: 'Email@example.com');
  TextEditingController telController =
      TextEditingController(text: '(+66) 12-345-6789');
  TextEditingController noteController = TextEditingController(text: '-');

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
                      // Back contract / Cancel
                      TextButton(
                        onPressed: () {
                          Navigator.of(context)
                              .pop(); // Handle cancel button click
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

                      // Edit button
                      TextButton(
                        onPressed: () {
                          setState(() {
                            // Toggle edit mode
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

                  //image section
                  Icon(
                    Icons.account_circle,
                    size: 75,
                    color: Colors.white,
                  ),

                  //name section
                  Text(
                    widget.name, // Use the name from the widget parameter
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  // Adjust the spacing as needed

                  //box Email can refactor
                  CustomTextField(
                    label: 'Email',
                    controller: emailController,
                    isEditMode: isEditMode,
                  ),

                  SizedBox(height: 20),

                  //tel box
                  CustomTextField(
                    label: 'Tel',
                    controller: telController,
                    isEditMode: isEditMode,
                  ),
                  SizedBox(height: 20),

                  //Note box
                  CustomTextField(
                    label: 'Note',
                    controller: noteController,
                    isEditMode: isEditMode,
                  ),
                  SizedBox(height: 20),

                  //delete
                  Visibility(
                    visible: isEditMode,
                    child: Container(
                      decoration: BoxDecoration(
                        color:
                            Color(0xff2B1A6D), // Set the background color here
                        borderRadius: BorderRadius.circular(
                            8), // Optional: Add border radius for rounded corners
                      ),
                      child: TextButton(
                        onPressed: () {
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
