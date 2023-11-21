/*
    Dashboard page 
      
*/

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fitgap/src/utils/firestore/firestore.dart';
import 'package:fitgap/src/features/dashboard/models/PopupDashboard.dart';
import 'package:intl/intl.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({super.key});

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  late List<EventDetails> eventsDataToday;
  late List<EventDetails> eventsDataTomorrow;
  late List<EventDetails> eventsDataFuture;
  bool isLoading = true;
  DateTime now = DateTime.now();
  late DateTime today = DateTime(now.year, now.month, now.day);
  late DateTime tomorrow = today.add(const Duration(days: 1));
  late DateTime afterTomorrow = tomorrow.add(const Duration(days: 1));

  @override
  void initState() {
    super.initState();
    loadEvents();
  }

  //get event, filter to [today,tomorrow,future] set to variable
  Future loadEvents() async {
    final allEvents = await FirestoreService().getEvents();

    List<EventDetails> todayEvents = [];
    List<EventDetails> tomorrowEvents = [];
    List<EventDetails> futureEvents = [];

    for (var event in allEvents) {
      DateTime eventStartDate = event.start_date.toDate();
      if (eventStartDate.isAfter(today) && eventStartDate.isBefore(tomorrow)) {
        todayEvents.add(event);
      } else if (eventStartDate.isAfter(tomorrow) &&
          eventStartDate.isBefore(afterTomorrow)) {
        tomorrowEvents.add(event);
      } else if (eventStartDate.isAfter(afterTomorrow)) {
        futureEvents.add(event);
      }
    }
    setState(() {
      eventsDataToday = todayEvents;
      eventsDataTomorrow = tomorrowEvents;
      eventsDataFuture = futureEvents;
    });

    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black, Color.fromRGBO(7, 2, 58, 1)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: screenHeight * 0.1,
                      width: screenWidth * 0.9,
                      child: const Align(
                          alignment: Alignment.centerRight,
                          child: CircleAvatar()),
                    ),
                    //Today section
                    SizedBox(
                      height: screenHeight * 0.1,
                      width: screenWidth * 0.9,
                      child: Column(
                        children: [
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Today',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding:
                                  EdgeInsets.only(left: screenWidth * 0.02),
                              child: Text(
                                DateFormat('d MMMM y').format(now),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      //height = screenHeight * 0.15 * numbers of element
                      height: screenHeight * 0.15 * eventsDataToday.length,
                      width: screenWidth * 1,
                      color: Colors.amber[60],
                      child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: eventsDataToday.length,
                        itemBuilder: (context, index) {
                          EventDetails event = eventsDataToday[index];
                          DateTime startDate = event.start_date.toDate();
                          String title = event.title;
                          String location = event.location;
                          int peopleNum = event.people.length;
                          return SizedBox(
                            height: screenHeight * 0.15,
                            child: Row(
                              children: [
                                Container(
                                  height: screenHeight * 0.125,
                                  width: screenWidth * 0.2,
                                  alignment: Alignment.topCenter,
                                  child: Text(
                                    DateFormat('HH:mm').format(startDate),
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Poppins',
                                        fontSize: 16),
                                  ),
                                ),
                                SizedBox(
                                  width: screenWidth * 0.7,
                                  height: screenHeight * 0.13,
                                  child: GestureDetector(
                                    onTap: () async {
                                      bool isChange =
                                          await eventPopup(context, event);
                                      isChange ? await loadEvents() : null;
                                    },
                                    child: Container(
                                      padding:
                                          EdgeInsets.all(screenHeight * 0.01),
                                      color:
                                          const Color.fromRGBO(65, 129, 225, 1),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              SizedBox(
                                                height: screenHeight * 0.075,
                                                width: screenWidth * 0.55,
                                                child: Text(
                                                  title,
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontFamily: 'Poppins',
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                              Container(
                                                height: screenHeight * 0.075,
                                                width: screenWidth * 0.075,
                                                decoration: const BoxDecoration(
                                                  image: DecorationImage(
                                                      image: AssetImage(
                                                          'assets/images/sunnyIcon.png'),
                                                      fit: BoxFit.contain),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: screenHeight * 0.03,
                                            width: screenWidth * 0.7,
                                            child: Text(
                                              (peopleNum == 0)
                                                  ? location
                                                  : (location == '')
                                                      ? 'with $peopleNum people'
                                                      : '$location,$peopleNum people',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontFamily: 'Poppins',
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
                          );
                        },
                      ),
                    ),
                    //Tomorrow section
                    SizedBox(
                      height: screenHeight * 0.1,
                      width: screenWidth * 0.9,
                      child: Column(
                        children: [
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Tomorrow',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding:
                                  EdgeInsets.only(left: screenWidth * 0.02),
                              child: Text(
                                DateFormat('d MMMM y').format(tomorrow),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      //height = screenHeight * 0.15 * numbers of element
                      height: screenHeight * 0.15 * eventsDataTomorrow.length,
                      width: screenWidth * 1,
                      color: Colors.amber[60],
                      child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: eventsDataTomorrow.length,
                        itemBuilder: (context, index) {
                          EventDetails event = eventsDataTomorrow[index];
                          DateTime startDate = event.start_date.toDate();
                          String title = event.title;
                          String location = event.location;
                          int peopleNum = event.people.length;
                          return SizedBox(
                            height: screenHeight * 0.15,
                            child: Row(
                              children: [
                                Container(
                                  height: screenHeight * 0.125,
                                  width: screenWidth * 0.2,
                                  alignment: Alignment.topCenter,
                                  child: Text(
                                    DateFormat('HH:mm').format(startDate),
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Poppins',
                                        fontSize: 16),
                                  ),
                                ),
                                SizedBox(
                                  width: screenWidth * 0.7,
                                  height: screenHeight * 0.13,
                                  child: GestureDetector(
                                    onTap: () async {
                                      bool isChange =
                                          await eventPopup(context, event);
                                      isChange ? await loadEvents() : null;
                                    },
                                    child: Container(
                                      padding:
                                          EdgeInsets.all(screenHeight * 0.01),
                                      color:
                                          const Color.fromRGBO(25, 23, 133, 1),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              SizedBox(
                                                height: screenHeight * 0.075,
                                                width: screenWidth * 0.55,
                                                child: Text(
                                                  title,
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontFamily: 'Poppins',
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                              Container(
                                                height: screenHeight * 0.075,
                                                width: screenWidth * 0.075,
                                                decoration: const BoxDecoration(
                                                  image: DecorationImage(
                                                      image: AssetImage(
                                                          'assets/images/sunnyIcon.png'),
                                                      fit: BoxFit.contain),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: screenHeight * 0.03,
                                            width: screenWidth * 0.7,
                                            child: Text(
                                              (peopleNum == 0)
                                                  ? location
                                                  : (location == '')
                                                      ? 'with $peopleNum people'
                                                      : '$location,$peopleNum people',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontFamily: 'Poppins',
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
                          );
                        },
                      ),
                    ),
                    //Upcoming section
                    SizedBox(
                      height: screenHeight * 0.05,
                      width: screenWidth * 0.9,
                      child: const Text(
                        'Upcoming',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                    Container(
                      //height = screenHeight * 0.15 * numbers of element
                      height: screenHeight * 0.2 * eventsDataFuture.length,
                      width: screenWidth * 1,
                      color: Colors.amber[60],
                      child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: eventsDataFuture.length,
                        itemBuilder: (context, index) {
                          EventDetails event = eventsDataFuture[index];
                          DateTime startDate = event.start_date.toDate();
                          String title = event.title;
                          String location = event.location;
                          String startdate = DateFormat('d MMMM y')
                              .format(event.start_date.toDate());
                          int peopleNum = event.people.length;
                          return SizedBox(
                            height: screenHeight * 0.2,
                            child: Column(
                              children: [
                                SizedBox(
                                  height: screenHeight * 0.05,
                                  width: screenWidth * 0.87,
                                  child: Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        startdate,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontFamily: 'Poppins',
                                        ),
                                      )),
                                ),
                                Row(
                                  children: [
                                    Container(
                                      height: screenHeight * 0.125,
                                      width: screenWidth * 0.2,
                                      alignment: Alignment.topCenter,
                                      child: Text(
                                        DateFormat('HH:mm').format(startDate),
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'Poppins',
                                            fontSize: 16),
                                      ),
                                    ),
                                    SizedBox(
                                      width: screenWidth * 0.7,
                                      height: screenHeight * 0.13,
                                      child: GestureDetector(
                                        onTap: () async {
                                          bool isChange =
                                              await eventPopup(context, event);
                                          isChange ? await loadEvents() : null;
                                        },
                                        child: Container(
                                          padding: EdgeInsets.all(
                                              screenHeight * 0.01),
                                          color: const Color.fromRGBO(
                                              73, 15, 194, 1),
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  SizedBox(
                                                    height:
                                                        screenHeight * 0.075,
                                                    width: screenWidth * 0.55,
                                                    child: Text(
                                                      title,
                                                      style: const TextStyle(
                                                          color: Colors.white,
                                                          fontFamily: 'Poppins',
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                  Container(
                                                    height:
                                                        screenHeight * 0.075,
                                                    width: screenWidth * 0.075,
                                                    decoration:
                                                        const BoxDecoration(
                                                      image: DecorationImage(
                                                          image: AssetImage(
                                                              'assets/images/sunnyIcon.png'),
                                                          fit: BoxFit.contain),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: screenHeight * 0.03,
                                                width: screenWidth * 0.7,
                                                child: Text(
                                                  (peopleNum == 0)
                                                      ? location
                                                      : (location == '')
                                                          ? 'with $peopleNum people'
                                                          : '$location,$peopleNum people',
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16,
                                                    fontFamily: 'Poppins',
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
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Future<bool> eventPopup(BuildContext context, EventDetails event) {
    Completer<bool> completer = Completer<bool>();

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Container(
            width: double.infinity,
            height: double.infinity,
            alignment: Alignment.center,
            color: const Color.fromARGB(0, 45, 45, 45),
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
            child: PopupDashboard(
              eventDetail: event,
            ),
          );
        }).then((value) => completer.complete(value));
    return completer.future;
  }
}
