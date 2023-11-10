/*  
    AddNewEventPeople page 
      -sub page of AddNewEvent page 
      -query list of people in contract
      -return list of selected people

      -doesn't remember element in selected list after this page is popped 
*/
import 'package:fitgap/src/utils/firestore/firestore.dart';
import 'package:flutter/material.dart';

class AddNewEventPeople extends StatefulWidget {
  final List<String> chosenPeople;

  const AddNewEventPeople({super.key, required this.chosenPeople});

  @override
  State<AddNewEventPeople> createState() => _AddNewEventPeopleState();
}

class _AddNewEventPeopleState extends State<AddNewEventPeople> {
  List<Map<String, dynamic>> people = [];
  List<Map<String, dynamic>> filteredPeople = [];
  List<String> selectedPeople = [];

  @override
  void initState() {
    super.initState();
    //initialize all people list and base unfiltered(searched) list
    loadPeople();
    selectedPeople = widget.chosenPeople;
  }

  Future loadPeople() async {
    final peopleData = await FirestoreService().getContacts();

    //no need to show circulr load
    //not a full page render

    setState(() {
      people = peopleData.map((map) {
        Map<String, dynamic> newMap = {};
        for (String key in ['id', 'name']) {
          if (map.containsKey(key)) {
            newMap[key] = map[key];
          }
        }
        return newMap;
      }).toList();

      filteredPeople = people;
    });
  }

  void filter(String value) {
    setState(() {
      filteredPeople = people.where((person) {
        return person['name'].toLowerCase().contains(value.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        body: Container(
          height: double.infinity,
          width: screenWidth,
          decoration: const BoxDecoration(color: Color.fromRGBO(12, 7, 67, 1)),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  //Top menu
                  height: screenHeight * 0.07,
                  width: screenWidth * 0.95,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: GestureDetector(
                          onTap: () {
                            // Clear the selected people list
                            setState(() {
                              selectedPeople.clear();
                            });
                            Navigator.pop(context, selectedPeople);
                          },
                          child: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const Expanded(
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.only(right: 40.0),
                            child: Text(
                              'Select People',
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // search bar
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: SizedBox(
                    height: screenHeight * 0.06,
                    width: screenWidth * 0.8,
                    child: TextField(
                      textAlignVertical: TextAlignVertical.bottom,
                      decoration: InputDecoration(
                        hintText: 'Search',
                        prefixIcon: const Icon(Icons.search),
                        iconColor: Colors.white,
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      onChanged: (value) {
                        filter(value);
                      },
                    ),
                  ),
                ),

                //people listview
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 13.0),
                  child: SizedBox(
                    height: screenHeight * 0.7,
                    width: screenWidth * 0.85,
                    child: ListView.builder(
                      itemCount: filteredPeople.length,
                      itemBuilder: (context, index) {
                        final person = filteredPeople[index];
                        final isSelected =
                            selectedPeople.contains(person['id']);
                        //changeto checkboxlisttile?
                        return Column(
                          children: [
                            Row(
                              children: [
                                //image
                                const CircleAvatar(),
                                SizedBox(width: screenWidth * 0.05),
                                // name
                                Text(person['name'],
                                    style: const TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 16,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                                const Spacer(),

                                // checkbox
                                Container(
                                  width: screenWidth * 0.2,
                                  height: screenHeight * 0.03,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                  ),
                                  child: Theme(
                                    data: ThemeData(
                                      unselectedWidgetColor: Colors.transparent,
                                    ),
                                    child: Checkbox(
                                      value: isSelected,
                                      onChanged: (bool? value) {
                                        setState(() {
                                          if (value != null) {
                                            if (value) {
                                              selectedPeople.add(person['id']);
                                            } else {
                                              selectedPeople
                                                  .remove(person['id']);
                                            }
                                          }
                                        });
                                      },
                                      activeColor: Colors.transparent,
                                      checkColor: Colors.green,
                                    ),
                                  ),
                                )
                              ],
                            ),
                            const Divider(
                              color: Colors.white,
                              thickness: 1.0,
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
                // select button
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    width: screenWidth * 0.4,
                    height: screenHeight * 0.05,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color.fromARGB(255, 156, 44, 243),
                          Color.fromARGB(255, 58, 73, 249)
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                      ),
                      onPressed: () {
                        Navigator.pop(context, selectedPeople);
                      },
                      child: const Center(
                        child: Text(
                          'Select',
                          style: TextStyle(
                            color: Colors.white, // Text color
                            fontSize: 16,
                            fontWeight: FontWeight.bold, // Text size
                          ),
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
