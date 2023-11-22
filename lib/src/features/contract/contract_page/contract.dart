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
  late List<Map<String, dynamic>> contacts = [];
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
    _updateVisibleContacts('');
  }

  void _updateVisibleContacts(String query) {
    setState(() {
      visibleContacts = contacts
          .where((contact) =>
              contact['name'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });

    // If the search result is empty, show a message
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
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.transparent,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 20),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  height: 20,
                ),
                //title
                Row(
                  children: [
                    const Text(
                      'Contacts',
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
                    _updateVisibleContacts(value);
                  },
                ),

                //list contact
                Flexible(
                  flex: 2,
                  child: contacts.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "You don't have any contact.",
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white),
                              ),
                              const SizedBox(height: 20),
                              Image.asset(
                                'assets/icons/nofriend.png',
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
              ]),
        ),
      ),
    );
  }
}
