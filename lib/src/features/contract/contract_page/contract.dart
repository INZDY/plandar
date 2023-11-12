import 'package:fitgap/src/features/contract/contract_page/add_contract.dart';
import 'package:fitgap/src/features/contract/contract_page/contract_profile.dart';
import 'package:flutter/material.dart';

class ContractPage extends StatefulWidget {
  const ContractPage({super.key});

  @override
  State<ContractPage> createState() => _ContractPageState();
}

class _ContractPageState extends State<ContractPage> {
  //example list name
  List<String> name = ['Shifu', 'Po', 'Ben', 'Max', 'Oogway'];
  late List<String> visibleName;

  get controller => null;

  @override
  void initState() {
    visibleName = name;
    super.initState();
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
                    Spacer(),
                    IconButton(
                      icon: Icon(Icons.add),
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

                //searchbar
                TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    hintText: 'Search',
                    filled: true, // Set to true to enable background color
                    fillColor:
                        Colors.grey[200], // Set the background color here
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Colors.black),
                    ),
                  ),
                  onChanged: (value) {
                    String lowercaseValue = value.toLowerCase();
                    visibleName = name
                        .where((name) =>
                            name.toLowerCase().contains(lowercaseValue))
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
                      return GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return ContractProfile(
                                name: visibleName[index],
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
                                  ), // Profile icon
                                  SizedBox(
                                      width:
                                          10), // Add some space between the icon and text
                                  Text(visibleName[index]),
                                ],
                              ),
                              textColor: Colors.white,
                            ),
                            Divider(
                                height: 1,
                                color: Colors.grey), // Add a line separator
                          ],
                        ),
                      );
                    },
                    itemCount: visibleName.length,
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
