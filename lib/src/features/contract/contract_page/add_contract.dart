import 'package:fitgap/src/features/contract/contract_wiget/add_contract_field.dart';
import 'package:fitgap/src/utils/firestore/firestore.dart';
import 'package:flutter/material.dart';

class AddContract extends StatefulWidget {
  const AddContract({super.key});

  @override
  State<AddContract> createState() => _AddContractState();
}

class _AddContractState extends State<AddContract> {
  String name = '';
  String email = '';
  String tel = '';
  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      constraints: const BoxConstraints.expand(),
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/add_contract.png'),
              fit: BoxFit.cover)),
      child: Center(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 20,
                ),

                //back to contrct button
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.chevron_left,
                        size: 32,
                      ),
                      color: Colors.white,
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    const Text(
                      'Add Contact',
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),

                //Add image button ??
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Transform.scale(
                        scale: 3.0,
                        child: IconButton(
                          icon: const Icon(
                            Icons.account_circle,
                          ),
                          color: Colors.white,
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Center(
                  child: GestureDetector(
                    onTap: () {},
                    child: const Text(
                      'ADD IMAGE',
                      style: TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),

                //call input box
                AddContractField(
                  inputBox: 'Name',
                  onValueChanged: (value) {
                    setState(() {
                      name = value;
                    });
                  },
                ),
                AddContractField(
                  inputBox: 'Email',
                  onValueChanged: (value) {
                    setState(() {
                      email = value;
                    });
                  },
                ),
                AddContractField(
                  inputBox: 'Tel.',
                  onValueChanged: (value) {
                    setState(() {
                      tel = value;
                    });
                  },
                ),

                //add button
                Center(
                  child: SizedBox(
                    width: 115,
                    height: 50,
                    child: TextButton(
                      onPressed: () {
                        FirestoreService().addContact(name, email, tel);
                        Navigator.of(context).pop();
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: const Color(0xff5936B4),
                        elevation: 10,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(35),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                          SizedBox(width: 1.25),
                          Text(
                            'Add',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 15, color: Colors.white),
                          ),
                        ],
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
