import 'dart:ui';

import 'package:fitgap/src/features/contract/contract_page/add_contract.dart';
import 'package:fitgap/src/features/contract/contract_page/contract_profile.dart';
import 'package:fitgap/src/utils/firestore/firestore.dart';
import 'package:flutter/material.dart';

class ContractPage extends StatefulWidget {
  const ContractPage({Key? key});

  @override
  State<ContractPage> createState() => _ContractPageState();
}

class _ContractPageState extends State<ContractPage> {
  late List<Map<String, dynamic>> contacts;
  List<Map<String, dynamic>> visibleContacts = [];

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadContacts();
  }

  Future<void> loadContacts() async {
    // Load contacts from Firestore
    contacts = await FirestoreService().getContacts();
    _updateVisibleContacts();
  }

  void _updateVisibleContacts() {
    setState(() {
      visibleContacts = List.from(contacts);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xff000000), Color(0xff07023A)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 20,
                ),
                //title
                Row(
                  children: [
                    const Text(
                      'Contact',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 25,
                        color: Colors.white,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: ((context) => AddContract())));
                      },
                      color: Colors.white,
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),

                //search
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    hintText: 'Search',
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(color: Colors.black),
                    ),
                  ),
                  onChanged: (value) {
                    String lowercaseValue = value.toLowerCase();
                    visibleContacts = contacts
                        .where((contact) => contact['name']
                            .toLowerCase()
                            .contains(lowercaseValue))
                        .toList();
                    _updateVisibleContacts();
                  },
                ),
                const SizedBox(
                  height: 20,
                ),

                //list contact
                Expanded(
                  flex: 2,
                  //check is it no contact
                  child: visibleContacts.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "You don't have any contact.",
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Image.asset(
                                'assets/icons/nofriend.png',
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Ink(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Color(0xFF9C2CF3),
                                      Color(0xFF3A49F9)
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  ),
                                  borderRadius: BorderRadius.circular(35),
                                ),
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => AddContract(),
                                      ),
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 24, vertical: 10),
                                    child: Text(
                                      "Add Contact",
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          itemBuilder: (context, index) {
                            final contact = visibleContacts[index];
                            return GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return ContractProfile(
                                      name: contact['name'],
                                      email: contact['email'],
                                      tel: contact['tel'],
                                      contactId: contact['id'],
                                      onSaveChanges: (updatedData) async {
                                        await FirestoreService().updateContact(
                                          contact['id'],
                                          updatedData,
                                        );
                                        loadContacts();
                                      },
                                    );
                                  },
                                );
                              },
                              child: Column(
                                children: [
                                  ListTile(
                                    title: Row(
                                      children: [
                                        Icon(
                                          Icons.account_circle,
                                          color: Colors.white,
                                        ),
                                        SizedBox(width: 10),
                                        Text(contact['name']),
                                      ],
                                    ),
                                    textColor: Colors.white,
                                  ),
                                  Divider(
                                    height: 1,
                                    color: Colors.grey,
                                  ),
                                ],
                              ),
                            );
                          },
                          itemCount: visibleContacts.length,
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
