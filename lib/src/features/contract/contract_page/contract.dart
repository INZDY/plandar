import 'package:fitgap/src/features/contract/contract_page/add_contract.dart';
import 'package:fitgap/src/features/contract/contract_page/contract_profile.dart';
import 'package:fitgap/src/utils/firestore/firestore.dart';
import 'package:flutter/material.dart';

class ContractPage extends StatefulWidget {
  const ContractPage({super.key});

  @override
  State<ContractPage> createState() => _ContractPageState();
}

class _ContractPageState extends State<ContractPage> {
  late List<Map<String, dynamic>> contacts;
  List<Map<String, dynamic>> visibleContacts = []; // Initialize here

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadContacts();
  }

  Future<void> _loadContacts() async {
    // Load contacts from Firestore
    contacts = await FirestoreService().getContacts();
    visibleContacts = List.from(contacts);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      //gradient background
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
                      'Contract',
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
                                builder: ((context) => const AddContract())));
                      },
                      color: Colors.white,
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),

                //searchbar
                TextField(
                  controller: _searchController, // Use _searchController here
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
                    setState(() {});
                  },
                ),

                const SizedBox(
                  height: 20,
                ),

                //list view
                Expanded(
                  flex: 2,
                  child: ListView.builder(
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
                              );
                            },
                          );
                        },
                        child: Column(
                          children: [
                            ListTile(
                              title: Row(
                                children: [
                                  const Icon(
                                    Icons.account_circle,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(width: 10),
                                  Text(contact['name']),
                                ],
                              ),
                              textColor: Colors.white,
                            ),
                           const Divider(
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
