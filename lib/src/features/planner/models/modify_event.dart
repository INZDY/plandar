/*
    ModifyEvent page 
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
            - 1 color picker
            - 1 button linked to addeventpeople.dart  
        5.Delete Event
      The event can be added only when at least :
        1. Title field is filled
        2. Ends date&time > Start date&time
*/

import 'package:fitgap/src/features/planner/screens/planner.dart';
import 'package:flutter/material.dart';
import 'package:fitgap/src/utils/utility/utility.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:intl/intl.dart';
import 'package:fitgap/src/features/addevent/addeventpeople.dart';
import 'package:fitgap/src/common_widgets/snackbar.dart';

import 'package:fitgap/src/utils/firestore/firestore.dart';

class ModifyEvent extends StatefulWidget {
  final Appointment eventDetail;

  const ModifyEvent({super.key, required this.eventDetail});

  @override
  State<ModifyEvent> createState() => _ModifyEventState();
}

class _ModifyEventState extends State<ModifyEvent> {
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

  //allow update from start
  bool allowUpdate = true;

  //init startdate/enddate without hours and mins
  DateTime startDate = DateFormat('yyyy-MM-dd')
      .parse(DateFormat('yyyy-MM-dd').format(DateTime.now()));
  DateTime endDate = DateFormat('yyyy-MM-dd')
      .parse(DateFormat('yyyy-MM-dd').format(DateTime.now()));

  String startHours = DateTime.now().hour.toString().padLeft(2, '0');
  String startMins = DateTime.now().minute.toString().padLeft(2, '0');
  String endHours = DateTime.now().hour.toString().padLeft(2, '0');
  String endMins = DateTime.now().minute.toString().padLeft(2, '0');

  Color pickerColor = const Color(0xff443a49);
  String finalColor = '';

  List<String> peoplelist = [];

  @override
  void initState() {
    super.initState();
    //load existing event values
    Appointment event = widget.eventDetail;

    setState(() {
      //use controller to set/update the text
      _titleTextController.text = event.title;
      //also set current event titletext at load
      titleText = event.title;
      _locationTextController.text = event.location;
      isAllDay = event.isAllDay;
      startDate = event.startTime;
      endDate = event.endTime;
      startHours = event.startTime.hour.toString().padLeft(2, '0');
      startMins = event.startTime.minute.toString().padLeft(2, '0');
      endHours = event.endTime.hour.toString().padLeft(2, '0');
      endMins = event.endTime.minute.toString().padLeft(2, '0');
      finalColor = event.color.value.toString();
      peoplelist = event.people;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(12, 7, 67, 1),
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.chevron_left),
            color: Colors.white,
          ),
          title: const Text(
            'Event Details',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          actions: [
            TextButton(
              onPressed: () {
                allowUpdate ? updateEvent() : null;
                Navigator.pop(context, true);
              },
              child: Text(
                'Update',
                style: TextStyle(color: allowUpdate ? Colors.red : Colors.grey),
              ),
            ),
          ],
        ),

        //Body
        body: Container(
          height: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //Title & Location group
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: SizedBox(
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
                              checkcondition();
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

                //Date & Time
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
                            SizedBox(
                              height: screenHeight * 0.06,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15.0),
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
                                            // close expanded time picker if allDay is selected
                                            setState(() {
                                              isStartTimeExpanded = false;
                                              startHours = '00';
                                              endHours = '00';
                                              startMins = '00';
                                              endMins = '00';
                                            });
                                          }
                                        });
                                        checkcondition();
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
                            SizedBox(
                              height: screenHeight * 0.06,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15.0),
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
                                                color: Color.fromRGBO(
                                                    88, 88, 88, 1),
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
                                                color: Color.fromRGBO(
                                                    88, 88, 88, 1),
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
                                            daysOfWeekStyle:
                                                const DaysOfWeekStyle(
                                              weekdayStyle: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black),
                                              weekendStyle: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.red),
                                            ),
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
                                              outsideTextStyle: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.grey),
                                            ),
                                            selectedDayPredicate: (day) =>
                                                isSameDay(day, startDate),
                                            onDaySelected: _startDateSelected,
                                          )
                                    : (isStartTimeExpanded
                                        ? isAnimating
                                            // if startTime is selected
                                            ? null
                                            : Row(
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
                                                        checkcondition();
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
                                                        checkcondition();
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
                                              )
                                        : null),
                              ),
                            ),
                            // Container for selecting Ends Date&Time
                            SizedBox(
                              height: screenHeight * 0.06,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15.0),
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
                                                color: Color.fromRGBO(
                                                    88, 88, 88, 1),
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
                                                color: Color.fromRGBO(
                                                    88, 88, 88, 1),
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
                                            daysOfWeekStyle:
                                                const DaysOfWeekStyle(
                                              weekdayStyle: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black),
                                              weekendStyle: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.red),
                                            ),
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
                                              outsideTextStyle: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.grey),
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
                                            : Row(
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
                                                        checkcondition();
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
                                                        checkcondition();
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
                                              )
                                        : null),
                              ),
                            ),
                          ],
                        ),
                      )),
                ),

                //Tag & People group
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      height: screenHeight * 0.12,
                      width: screenWidth * 0.9,
                      color: const Color.fromRGBO(153, 175, 255, 1),
                      child: Column(
                        children: [
                          //tag
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
                                  Text('Tag',
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelSmall),
                                  SizedBox(
                                    width: screenWidth * 0.3,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: finalColor == ''
                                            ? const Color.fromRGBO(
                                                217, 217, 217, 1)
                                            : //convert from color int to color type
                                            Color(int.parse(finalColor))
                                                .withOpacity(1),
                                      ),
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: const Text(
                                                  "Select tag's color"),
                                              content: SingleChildScrollView(
                                                child: BlockPicker(
                                                  pickerColor: pickerColor,
                                                  onColorChanged: changeColor,
                                                ),
                                              ),
                                              actions: <Widget>[
                                                ElevatedButton(
                                                  child: const Text('Confirm'),
                                                  onPressed: () {
                                                    setState(() {
                                                      finalColor = pickerColor
                                                          .value
                                                          .toString();
                                                    });

                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              finalColor == '' ? 'None' : '',
                                              style: const TextStyle(
                                                color: Color.fromRGBO(
                                                    88, 88, 88, 1),
                                              ),
                                            ),
                                            Icon(
                                              finalColor == ''
                                                  ? Icons.manage_search
                                                  : null,
                                              color: const Color.fromRGBO(
                                                  88, 88, 88, 1),
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

                          //people
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
                                  Text('People',
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelSmall),
                                  SizedBox(
                                    width: peoplelist.isEmpty
                                        ? screenWidth * 0.3
                                        : screenWidth * 0.35,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color.fromRGBO(
                                            217, 217, 217, 1),
                                      ),
                                      onPressed: () async {
                                        List<String> returndata =
                                            await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                AddNewEventPeople(
                                                    chosenPeople: peoplelist),
                                          ),
                                        );
                                        setState(() {
                                          peoplelist = returndata;
                                        });
                                      },
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              peoplelist.isEmpty
                                                  ? 'None'
                                                  : '${peoplelist.length.toString()} selected',
                                              style: const TextStyle(
                                                color: Color.fromRGBO(
                                                    88, 88, 88, 1),
                                              ),
                                            ),
                                            const Icon(
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

                //Delete button
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 30),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      width: screenWidth * 0.3,
                      height: screenHeight * 0.05,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color.fromARGB(255, 249, 58, 58),
                            Color.fromARGB(255, 156, 44, 243),
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
                          FirestoreService().deleteEvent(widget.eventDetail.id);
                          Navigator.pop(context, true);
                        },
                        child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.delete),
                              Text(
                                'Delete',
                                style: TextStyle(
                                  color: Colors.white, // Text color
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold, // Text size
                                ),
                              ),
                            ]),
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
    checkcondition();
  }

  void _endDateSelected(DateTime day, DateTime focusedDay) {
    setState(() {
      endDate = day;
    });
    checkcondition();
  }

  String dMyformat(DateTime dateTime) {
    return DateFormat('dd MMM yyyy').format(dateTime);
  }

  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  void checkcondition() {
    DateTime endDateTime = DateTime(endDate.year, endDate.month, endDate.day,
        int.parse(endHours), int.parse(endMins));

    DateTime startDateTime = DateTime(startDate.year, startDate.month,
        startDate.day, int.parse(startHours), int.parse(startMins));

    if (titleText.isNotEmpty) {
      //(isAllDay AND same time) OR end more than start)
      if ((isAllDay == true && endDate.isAtSameMomentAs(startDate)) ||
          endDateTime.isAfter(startDateTime)) {
        setState(() {
          allowUpdate = true;
        });
      } else {
        setState(() {
          allowUpdate = false;
        });
      }
    } else {
      setState(() {
        allowUpdate = false;
      });
    }
  }

  void updateEvent() async {
    try {
      DateTime endDateTime = DateTime(endDate.year, endDate.month, endDate.day,
          int.parse(endHours), int.parse(endMins));
      DateTime startDateTime = DateTime(startDate.year, startDate.month,
          startDate.day, int.parse(startHours), int.parse(startMins));

      await FirestoreService().updateEvent(
          widget.eventDetail.id,
          titleText,
          locationText,
          startDateTime,
          endDateTime,
          isAllDay,
          finalColor,
          peoplelist);
      SnackbarUtil.showSnackBar('Event updated');
    } catch (e) {
      SnackbarUtil.showSnackBar(e.toString());
    }
  }
}
