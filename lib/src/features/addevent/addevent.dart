/*
    AddNewEvent page 
      There are 4 groups in this pages :
        1.Top menu          
          - Contains :
            - Page name and Add button
        2.Title & Location 
          - Contain :
            - 1 plain Text input boxes use to receive Event's title 
            - 1 Text input with map api to receive Event's location
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
import 'package:fitgap/src/utils/utility/utility.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class AddNewEvent extends StatefulWidget {
  const AddNewEvent({
    super.key,
  });

  @override
  State<AddNewEvent> createState() => _AddNewEventState();
}

class _AddNewEventState extends State<AddNewEvent> {
  final TextEditingController _titleTextController = TextEditingController();
  final TextEditingController _locationTextController = TextEditingController();
  String titleText = '';
  String locationText = '';

  bool isAllDay = false;
  bool isAnimating = false;

  bool isStartDateExpanded = false;
  bool isStartTimeExpanded = false;
  bool isEndDateExpanded = false;
  bool isEndTimeExpanded = false;

  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
  String startHours = DateTime.now().hour.toString().padLeft(2, '0');
  String startMins = DateTime.now().minute.toString().padLeft(2, '0');
  String endHours = DateTime.now().hour.toString().padLeft(2, '0');
  String endMins = DateTime.now().minute.toString().padLeft(2, '0');

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
      isEndDateExpanded = false;
      isEndTimeExpanded = false;
      isAnimating = true;
    });

    if (isStartDateExpanded) {
      setState(() {
        isStartDateExpanded = false;
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

  void toggleEndDate() {
    setState(() {
      isEndDateExpanded = !isEndDateExpanded;
      isStartDateExpanded = false;
      isStartTimeExpanded = false;
      isAnimating = true;
    });

    if (isEndTimeExpanded) {
      setState(() {
        isEndTimeExpanded = false;
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

  void toggleEndTime() {
    setState(() {
      isEndTimeExpanded = !isEndTimeExpanded;
      isStartDateExpanded = false;
      isStartTimeExpanded = false;
      isAnimating = true;
    });

    if (isEndDateExpanded) {
      setState(() {
        isEndDateExpanded = false;
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
        decoration: const BoxDecoration(color: Color.fromRGBO(12, 7, 67, 1)),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                //Top menu
                height: screenHeight * 0.07,
                width: screenWidth * 1,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                          onPressed: () {},
                          child: const Text(
                            'Create New Event',
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          )),
                      TextButton(
                        onPressed: () {},
                        child: const Text('Add'),
                      ), // Submit event data (Sprint 3)
                    ],
                  ),
                ),
              ),
              Padding(
                //Title & Location group
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: Container(
                  height: screenHeight * 0.13,
                  width: screenWidth * 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        height: screenHeight * 0.06,
                        width: screenWidth * 0.9,
                        child: TextField(
                          controller: _titleTextController,
                          textAlignVertical: TextAlignVertical.bottom,
                          decoration: InputDecoration(
                            hintText: 'Title',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                  10.0), // Adjust the radius as needed
                            ),
                            filled: true,
                            fillColor: const Color.fromRGBO(153, 175, 255,
                                1), // Adjust the background color
                          ),
                          onChanged: (text) {
                            setState(() {
                              titleText = text;
                            });
                          },
                        ),
                      ),
                      SizedBox(
                        height: screenHeight * 0.06,
                        width: screenWidth * 0.9,
                        child: TextField(
                          controller: _locationTextController,
                          textAlignVertical: TextAlignVertical.bottom,
                          decoration: InputDecoration(
                            hintText: 'Location',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                  10.0), // Adjust the radius as needed
                            ),
                            filled: true,
                            fillColor: const Color.fromRGBO(153, 175, 255,
                                1), // Adjust the background color
                          ),
                          onChanged: (text) {
                            setState(() {
                              locationText = text;
                            });
                          },
                        ),
                      ),
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
                      color: const Color.fromRGBO(153, 175, 255, 1),
                      child: Column(
                        children: [
                          Container(
                            height: screenHeight * 0.06,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('All-day',
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelSmall),
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
                          Expanded(
                            child: SizedBox(
                              width: screenWidth * 0.8,
                              child: const Divider(
                                color: Colors.white,
                                thickness: 1.0,
                              ),
                            ),
                          ),
                          // Container for selecting Start Date&Time
                          Container(
                            height: screenHeight * 0.06,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Starts',
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelSmall),
                                  Row(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 5),
                                        child: ElevatedButton(
                                          onPressed: () {
                                            toggleStartDate();
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                const Color.fromRGBO(
                                                    217, 217, 217, 1),
                                          ),
                                          child: Text(
                                            dMyformat(startDate),
                                            style: const TextStyle(
                                              color:
                                                  Color.fromRGBO(88, 88, 88, 1),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Visibility(
                                        visible: !isAllDay,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            toggleStartTime();
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                const Color.fromRGBO(
                                                    217, 217, 217, 1),
                                          ),
                                          child: Text(
                                            '$startHours:$startMins',
                                            style: const TextStyle(
                                              color:
                                                  Color.fromRGBO(88, 88, 88, 1),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: SizedBox(
                              width: screenWidth * 0.8,
                              child: const Divider(
                                color: Colors.white,
                                thickness: 1.0,
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
                            color: const Color.fromRGBO(153, 175, 255, 1),
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
                                            titleCentered: true,
                                            titleTextStyle: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                          calendarStyle: const CalendarStyle(
                                            defaultTextStyle: TextStyle(
                                                fontSize: 14,
                                                color: Colors.black),
                                            weekendTextStyle: TextStyle(
                                                fontSize: 14,
                                                color: Colors.red),
                                          ),
                                          selectedDayPredicate: (day) =>
                                              isSameDay(day, startDate),
                                          onDaySelected: _startDateSelected,
                                        )
                                  : (isStartTimeExpanded
                                      ? isAnimating
                                          // if startTime is selected
                                          ? null
                                          : Container(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  // hour wheel
                                                  SizedBox(
                                                    width: screenWidth * 0.3,
                                                    child: ListWheelScrollView
                                                        .useDelegate(
                                                      itemExtent: 45,
                                                      perspective: 0.005,
                                                      diameterRatio: 1.2,
                                                      controller:
                                                          FixedExtentScrollController(
                                                              initialItem:
                                                                  int.parse(
                                                                      startHours)),
                                                      onSelectedItemChanged:
                                                          (value) {
                                                        setState(() {
                                                          startHours = value
                                                              .toString()
                                                              .padLeft(2, '0');
                                                        });
                                                      },
                                                      physics:
                                                          const FixedExtentScrollPhysics(),
                                                      childDelegate:
                                                          ListWheelChildBuilderDelegate(
                                                        childCount: 25,
                                                        builder:
                                                            (context, index) {
                                                          return MyHours(
                                                              hours: index);
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                  const Text(
                                                    " : ",
                                                    style: TextStyle(
                                                        fontSize: 30,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  // min wheel
                                                  SizedBox(
                                                    width: screenWidth * 0.3,
                                                    child: ListWheelScrollView
                                                        .useDelegate(
                                                      itemExtent: 45,
                                                      perspective: 0.005,
                                                      diameterRatio: 1.2,
                                                      controller:
                                                          FixedExtentScrollController(
                                                              initialItem:
                                                                  int.parse(
                                                                      startMins)),
                                                      onSelectedItemChanged:
                                                          (value) {
                                                        setState(() {
                                                          startMins = value
                                                              .toString()
                                                              .padLeft(2, '0');
                                                        });
                                                      },
                                                      physics:
                                                          const FixedExtentScrollPhysics(),
                                                      childDelegate:
                                                          ListWheelChildBuilderDelegate(
                                                        childCount: 60,
                                                        builder:
                                                            (context, index) {
                                                          return MyMinutes(
                                                              mins: index);
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                      : null),
                            ),
                          ),
                          // Container for selecting Ends Date&Time
                          Container(
                            height: screenHeight * 0.06,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Ends',
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelSmall),
                                  Row(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 5),
                                        child: ElevatedButton(
                                          onPressed: () {
                                            toggleEndDate();
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                const Color.fromRGBO(
                                                    217, 217, 217, 1),
                                          ),
                                          child: Text(
                                            dMyformat(endDate),
                                            style: const TextStyle(
                                              color:
                                                  Color.fromRGBO(88, 88, 88, 1),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Visibility(
                                        visible: !isAllDay,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            toggleEndTime();
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                const Color.fromRGBO(
                                                    217, 217, 217, 1),
                                          ),
                                          child: Text(
                                            '$endHours:$endMins',
                                            style: const TextStyle(
                                              color:
                                                  Color.fromRGBO(88, 88, 88, 1),
                                            ),
                                          ),
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
                            color: const Color.fromRGBO(153, 175, 255, 1),
                            child: Center(
                              child: isEndDateExpanded
                                  // if endDate is selected
                                  ? isAnimating
                                      ? null
                                      : TableCalendar(
                                          firstDay: DateTime.utc(2023, 1, 1),
                                          lastDay: DateTime.utc(2030, 12, 31),
                                          focusedDay: endDate,
                                          shouldFillViewport: true,
                                          headerStyle: const HeaderStyle(
                                            formatButtonVisible: false,
                                            titleCentered: true,
                                            titleTextStyle: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                          calendarStyle: const CalendarStyle(
                                            defaultTextStyle: TextStyle(
                                                fontSize: 14,
                                                color: Colors.black),
                                            weekendTextStyle:
                                                TextStyle(color: Colors.red),
                                          ),
                                          selectedDayPredicate: (day) =>
                                              isSameDay(day, endDate),
                                          onDaySelected: _endDateSelected,
                                        )
                                  : (isEndTimeExpanded
                                      ? isAnimating
                                          ?
                                          // if endTime is selected
                                          null
                                          : Container(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  // hour wheel
                                                  SizedBox(
                                                    width: screenWidth * 0.3,
                                                    child: ListWheelScrollView
                                                        .useDelegate(
                                                      itemExtent: 45,
                                                      perspective: 0.005,
                                                      diameterRatio: 1.2,
                                                      controller:
                                                          FixedExtentScrollController(
                                                              initialItem:
                                                                  int.parse(
                                                                      endHours)),
                                                      onSelectedItemChanged:
                                                          (value) {
                                                        setState(() {
                                                          endHours = value
                                                              .toString()
                                                              .padLeft(2, '0');
                                                        });
                                                      },
                                                      physics:
                                                          const FixedExtentScrollPhysics(),
                                                      childDelegate:
                                                          ListWheelChildBuilderDelegate(
                                                        childCount: 25,
                                                        builder:
                                                            (context, index) {
                                                          return MyHours(
                                                              hours: index);
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                  const Text(
                                                    " : ",
                                                    style: TextStyle(
                                                        fontSize: 30,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  // min wheel
                                                  SizedBox(
                                                    width: screenWidth * 0.3,
                                                    child: ListWheelScrollView
                                                        .useDelegate(
                                                      itemExtent: 45,
                                                      perspective: 0.005,
                                                      diameterRatio: 1.2,
                                                      controller:
                                                          FixedExtentScrollController(
                                                              initialItem:
                                                                  int.parse(
                                                                      endMins)),
                                                      onSelectedItemChanged:
                                                          (value) {
                                                        setState(() {
                                                          endMins = value
                                                              .toString()
                                                              .padLeft(2, '0');
                                                        });
                                                      },
                                                      physics:
                                                          const FixedExtentScrollPhysics(),
                                                      childDelegate:
                                                          ListWheelChildBuilderDelegate(
                                                        childCount: 60,
                                                        builder:
                                                            (context, index) {
                                                          return MyMinutes(
                                                              mins: index);
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                      : null),
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
                    color: const Color.fromRGBO(153, 175, 255, 1),
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
                                Text('Tag',
                                    style:
                                        Theme.of(context).textTheme.labelSmall),
                                SizedBox(
                                  width: screenWidth * 0.3,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color.fromRGBO(
                                          217, 217, 217, 1),
                                    ),
                                    onPressed:
                                        () {}, // route to Tag pages (Sprint 3)
                                    child: const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'None',
                                            style: TextStyle(
                                              color:
                                                  Color.fromRGBO(88, 88, 88, 1),
                                            ),
                                          ),
                                          Icon(
                                            Icons.manage_search,
                                            color:
                                                Color.fromRGBO(88, 88, 88, 1),
                                          )
                                        ]),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: SizedBox(
                            width: screenWidth * 0.8,
                            child: const Divider(
                              color: Colors.white,
                              thickness: 1.0,
                            ),
                          ),
                        ),
                        Container(
                          height: screenHeight * 0.06,
                          color: Colors.white10,
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 15.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('People',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall), // route to People pages (Sprint 3)
                                SizedBox(
                                  width: screenWidth * 0.3,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color.fromRGBO(
                                          217, 217, 217, 1),
                                    ),
                                    onPressed: () {},
                                    child: const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'None',
                                            style: TextStyle(
                                              color:
                                                  Color.fromRGBO(88, 88, 88, 1),
                                            ),
                                          ),
                                          Icon(
                                            Icons.manage_search,
                                            color:
                                                Color.fromRGBO(88, 88, 88, 1),
                                          )
                                        ]),
                                  ),
                                ),
                              ],
                            ),
                          ),
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