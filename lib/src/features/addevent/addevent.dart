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
import 'package:intl/intl.dart';

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
  bool isEndDateExpanded = false;
  bool isEndTimeExpanded = false;
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();

  void toggleStartDate() {
    setState(() {
      isStartDateExpanded = !isStartDateExpanded;
      isEndDateExpanded = false;
      isEndTimeExpanded = false;
      isAnimating = true;
    });

    if (isStartTimeExpanded) {
      setState(() {
        isStartTimeExpanded = false;
        isAnimating = false;
      });
    } else {
      Future.delayed(const Duration(milliseconds: 500), () {
        setState(() {
          isAnimating = false; // Animation is complete, stop animating
        });
      });
    }
  }

  void toggleStartTime() {
    setState(() {
      isStartTimeExpanded = !isStartTimeExpanded;
      isStartDateExpanded = false; //close one tab when other appears
      isEndDateExpanded = false;
      isEndTimeExpanded = false;
    });
  }

  void toggleEndDate() {
    setState(() {
      isEndDateExpanded = !isEndDateExpanded;
      isEndTimeExpanded = false; //close one tab when other appears
      isStartDateExpanded = false;
      isStartTimeExpanded = false;
      isAnimating = true;
    });

    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        isAnimating = false; // Animation is complete, stop animating
      });
    });
  }

  void toggleEndTime() {
    setState(() {
      isEndTimeExpanded = !isEndTimeExpanded;
      isEndDateExpanded = false; //close one tab when other appears
      isStartDateExpanded = false;
      isStartTimeExpanded = false;
    });
  }

  void _startDateSelected(DateTime day, DateTime focusedDay) {
    setState(() {
      startDate = day;
    });
  }

  void _endDateSelected(DateTime day, DateTime focusedDay) {
    setState(() {
      endDate = day;
    });
  }

  String dMyformat(DateTime dateTime) {
    return DateFormat('dd MMM yyyy').format(dateTime);
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
                padding: const EdgeInsets.symmetric(vertical: 5.0),
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
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      height: isStartDateExpanded ||
                              isStartTimeExpanded ||
                              isEndDateExpanded ||
                              isEndTimeExpanded
                          ? screenHeight * 0.49 //48
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
                          // Container for selecting Start Date&Time
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
                                                ? dMyformat(startDate)
                                                : dMyformat(startDate))),
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
                          // AnimateContainer for table calendar for start Date
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 500),
                            width: screenWidth * 0.9,
                            height: isStartDateExpanded || isStartTimeExpanded
                                ? screenHeight * 0.31
                                : 0.0,
                            color: Colors.blue,
                            child: Center(
                              child: isStartDateExpanded
                                  // if startDate is selected
                                  ? isAnimating
                                      ? null
                                      : TableCalendar(
                                          firstDay: DateTime.utc(2023, 1, 1),
                                          lastDay: DateTime.utc(2030, 12, 31),
                                          focusedDay: startDate,
                                          shouldFillViewport: true,
                                          headerStyle: const HeaderStyle(
                                            formatButtonVisible: false,
                                            titleTextStyle: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                          selectedDayPredicate: (day) =>
                                              isSameDay(day, startDate),
                                          onDaySelected: _startDateSelected,
                                        )
                                  : (isStartTimeExpanded
                                      ?
                                      // if startTime is selected
                                      Text('Start Time')
                                      : Text('')),
                            ),
                          ),
                          // Container for selecting Ends Date&Time
                          Container(
                            height: screenHeight * 0.06,
                            color: Colors.white60,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Ends'),
                                  Row(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 5),
                                        child: ElevatedButton(
                                            onPressed: () {
                                              toggleEndDate();
                                            },
                                            child: Text(isEndDateExpanded
                                                ? dMyformat(endDate)
                                                : dMyformat(endDate))),
                                      ),
                                      Visibility(
                                        visible: !isAllDay,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            toggleEndTime();
                                          },
                                          child: Text(isEndTimeExpanded
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
                          // AnimateContainer for table calendar for End Date
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 500),
                            width: screenWidth * 0.9,
                            height: isEndDateExpanded || isEndTimeExpanded
                                ? screenHeight * 0.31
                                : 0.0,
                            color: Colors.blue,
                            child: Center(
                              child: isEndDateExpanded
                                  // if startDate is selected
                                  ? isAnimating
                                      ? null
                                      : TableCalendar(
                                          firstDay: DateTime.utc(2023, 1, 1),
                                          lastDay: DateTime.utc(2030, 12, 31),
                                          focusedDay: endDate,
                                          shouldFillViewport: true,
                                          headerStyle: const HeaderStyle(
                                            formatButtonVisible: false,
                                            titleTextStyle: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                          selectedDayPredicate: (day) =>
                                              isSameDay(day, endDate),
                                          onDaySelected: _endDateSelected,
                                        )
                                  : (isEndTimeExpanded
                                      ?
                                      // if startTime is selected
                                      Text('End Time')
                                      : Text('')),
                            ),
                          ),
                        ],
                      ),
                    )),
              ),
              Padding(
                //Tag & People group
                padding: const EdgeInsets.symmetric(vertical: 10.0),
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
