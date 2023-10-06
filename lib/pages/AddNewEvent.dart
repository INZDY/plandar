import 'package:flutter/material.dart';

class AddNewEvent extends StatefulWidget {
  const AddNewEvent({
    super.key,
  });

  @override
  _AddNewEventState createState() => _AddNewEventState();
}

class _AddNewEventState extends State<AddNewEvent> {
  bool isAllDay = false;
  bool isStartDateExpanded = false;
  bool isStartTimeExpanded = false;

  void toggleStartDate() {
    setState(() {
      isStartDateExpanded = !isStartDateExpanded;
      isStartTimeExpanded = false; //close Date extend tab
    });
  }

  void toggleStartTime() {
    setState(() {
      isStartTimeExpanded = !isStartTimeExpanded;
      isStartDateExpanded = false; //close Date extend tab
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black, Color.fromRGBO(7, 2, 58, 1)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                //Top menu
                height: screenHeight * 0.07,
                width: screenWidth * 1,
                color: Colors.deepPurple[600],
                child: Row(
                  children: [
                    TextButton(onPressed: () {}, child: const Text('Cancel')),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: screenWidth * 0.23),
                      child: TextButton(
                          onPressed: () {}, child: const Text('New Event')),
                    ),
                    TextButton(onPressed: () {}, child: const Text('Add')),
                  ],
                ),
              ),
              Padding(
                //Title & Location group
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                child: Container(
                  height: screenHeight * 0.13,
                  width: screenWidth * 1,
                  color: Colors.deepPurple[500],
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          height: screenHeight * 0.06,
                          width: screenWidth * 0.9,
                          color: Colors.white,
                        ),
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          height: screenHeight * 0.06,
                          width: screenWidth * 0.9,
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                //All-day & Starts & Ends group
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    height: isStartDateExpanded || isStartTimeExpanded
                        ? screenHeight * 0.39
                        : screenHeight * 0.18,
                    width: screenWidth * 0.9,
                    color: Colors.deepPurple[500],
                    child: Column(
                      children: [
                        Container(
                          height: screenHeight * 0.06,
                          color: Colors.white10,
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 15.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('All-day'),
                                SwitchAllDay(
                                  onValueChanged: (value) {
                                    setState(() {
                                      isAllDay = value;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          height: screenHeight * 0.06,
                          color: Colors.white30,
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 15.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Starts'),
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(right: 5),
                                      child: ElevatedButton(
                                          onPressed: () {
                                            toggleStartDate();
                                          },
                                          child: Text(isStartDateExpanded
                                              ? 'DateO'
                                              : 'DateC')),
                                    ),
                                    ElevatedButton(
                                        onPressed: () {
                                          toggleStartTime();
                                        },
                                        child: Text(isStartTimeExpanded
                                            ? 'TimeO'
                                            : 'TimeC'))
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 500),
                          width: screenWidth * 0.9,
                          height: isStartDateExpanded || isStartTimeExpanded
                              ? screenHeight * 0.21
                              : 0.0,
                          color: Colors.blue,
                          child: Center(
                            child: Text(
                              isStartDateExpanded
                                  ? 'Start Date'
                                  : (isStartTimeExpanded ? 'Start Time' : ''),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        Container(
                          height: screenHeight * 0.06,
                          color: Colors.white60,
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                //Tag & People group
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    height: screenHeight * 0.12,
                    width: screenWidth * 0.9,
                    color: Colors.deepPurple[500],
                    child: Column(
                      children: [
                        Container(
                          height: screenHeight * 0.06,
                          color: Colors.white10,
                        ),
                        Container(
                          height: screenHeight * 0.06,
                          color: Colors.white30,
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
    );
  }
}

// All day Switch class
class SwitchAllDay extends StatefulWidget {
  final ValueChanged<bool> onValueChanged;
  const SwitchAllDay({Key? key, required this.onValueChanged})
      : super(key: key);

  @override
  State<SwitchAllDay> createState() => _SwitchAllDayState();
}

class _SwitchAllDayState extends State<SwitchAllDay> {
  bool light = false;

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: light,
      onChanged: (bool value) {
        setState(() {
          light = value;
        });
        widget.onValueChanged(light);
      },
    );
  }
}
