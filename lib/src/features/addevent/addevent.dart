/*
    AddNewEvent page 
      There are 4 groups in this pages :
        1.Top menu          
          - Contains :
            - Page name and Add button
        2.Title & Location 
          - Contain :
            - 2 Text input boxes use to receive Event's title and location
        3.All-day & Starts & Ends 
          - use to determine date&time for an event
          - Contains :
            - 1 container with switch 
            - 2 container with 2 buttons in each       
        4.Tag & People
          - use to select a tag and assign people in an event
          - Contains :
            - two container with botton in each, link to other pages
*/

import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class AddNewEvent extends StatefulWidget {
  const AddNewEvent({
    super.key,
  });

  @override
  _AddNewEventState createState() => _AddNewEventState();
}

class _AddNewEventState extends State<AddNewEvent> {
  bool isAllDay = false;
  bool isAnimating = false;
  bool isStartDateExpanded = false;
  bool isStartTimeExpanded = false;

  void toggleStartDate() {
    setState(() {
      isStartDateExpanded = !isStartDateExpanded;
      isStartTimeExpanded = false; //close one tab when other appears
      isAnimating = true;
    });

    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        isAnimating = false; // Animation is complete, stop animating
      });
    });
  }

  void toggleStartTime() {
    setState(() {
      isStartTimeExpanded = !isStartTimeExpanded;
      isStartDateExpanded = false; //close one tab when other appears
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                        onPressed: () {}, child: const Text('New Event')),
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
                          ? screenHeight * 0.48 //48
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('All-day'),
                                  Switch(
                                    value: isAllDay,
                                    onChanged: (value) {
                                      setState(() {
                                        isAllDay = value;
                                        if (isAllDay == true) {
                                          isStartTimeExpanded =
                                              false; // close expanded time picker if allDay is selected
                                        }
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Starts'),
                                  Row(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 5),
                                        child: ElevatedButton(
                                            onPressed: () {
                                              toggleStartDate();
                                            },
                                            child: Text(isStartDateExpanded
                                                ? 'DateO'
                                                : 'DateC')),
                                      ),
                                      Visibility(
                                        visible: !isAllDay,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            toggleStartTime();
                                          },
                                          child: Text(isStartTimeExpanded
                                              ? 'TimeO'
                                              : 'TimeC'),
                                        ),
                                      )
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
                                ? screenHeight * 0.30
                                : 0.0,
                            color: Colors.blue,
                            child: Center(
                              child: isStartDateExpanded
                                  // if startDate is selected
                                  ? isAnimating
                                      ? null
                                      : TableCalendar(
                                          firstDay: DateTime.utc(2010, 10, 16),
                                          lastDay: DateTime.utc(2030, 3, 14),
                                          focusedDay: DateTime.now(),
                                          shouldFillViewport: true,
                                          headerStyle: const HeaderStyle(
                                            titleTextStyle: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                        )
                                  : (isStartTimeExpanded
                                      ?
                                      // if startTime is selected
                                      Text('Start Time')
                                      : Text('')),
                            ),
                          ),
                          Container(
                            height: screenHeight * 0.06,
                            color: Colors.white60,
                          )
                        ],
                      ),
                    )),
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
