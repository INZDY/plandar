/*
    Dashboard page 
      
*/

import 'dart:async';
import 'package:fitgap/src/utils/weather/weather_service.dart';
import 'package:fitgap/src/utils/weather/weather_api_key.dart';
import 'package:fitgap/src/utils/weather/weather_model.dart';
import 'package:flutter/material.dart';
import 'package:fitgap/src/utils/firestore/firestore.dart';
import 'package:fitgap/src/features/dashboard/models/popup_dashboard.dart';
import 'package:intl/intl.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({super.key});

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  late List<EventDetails> _allEvents;
  late List<EventDetails> eventsDataToday;
  late List<EventDetails> eventsDataTomorrow;
  late List<EventDetails> eventsDataFuture;
  bool isLoading = true;

  DateTime now = DateTime.now();
  late DateTime today;
  late DateTime tomorrow;
  late DateTime afterTomorrow;

  //weather
  final _weatherService = WeatherService(WeatherAPIKey.weatherAPI);
  late List<String> _todayWeather;
  late List<String> _tomorrowWeather;
  late List<String> _futureWeather;
  bool isLoadingWeather = true;

  //get event, filter to [today,tomorrow,future] set to variable
  Future loadEvents() async {
    _allEvents = await FirestoreService().getEvents();

    List<EventDetails> todayEvents = [];
    List<EventDetails> tomorrowEvents = [];
    List<EventDetails> futureEvents = [];

    //set days in here
    today = DateTime(now.year, now.month, now.day);
    tomorrow = today.add(const Duration(days: 1));
    afterTomorrow = tomorrow.add(const Duration(days: 1));

    isLoading = true;

    for (var event in _allEvents) {
      DateTime eventStartDate = event.start_date.toDate();
      // today <= eventstartdate < tomorrow
      if (eventStartDate.isAtSameMomentAs(today) ||
          eventStartDate.isAfter(today) && eventStartDate.isBefore(tomorrow)) {
        todayEvents.add(event);
      }
      // tomorrow <= eventstartdate < aftertomorrow
      else if (eventStartDate.isAtSameMomentAs(tomorrow) ||
          eventStartDate.isAfter(tomorrow) &&
              eventStartDate.isBefore(afterTomorrow)) {
        tomorrowEvents.add(event);
      }
      //aftertomorrow <= eventstartdate
      else if (eventStartDate.isAtSameMomentAs(afterTomorrow) ||
          eventStartDate.isAfter(afterTomorrow)) {
        futureEvents.add(event);
      }
    }
    setState(() {
      eventsDataToday = todayEvents;
      eventsDataTomorrow = tomorrowEvents;
      eventsDataFuture = futureEvents;
      isLoading = false;
    });
  }

  void fetchWeatherMapping() async {
    //need to wait for events
    await loadEvents();

    isLoadingWeather = true;

    String position = await _weatherService.getCurrentPosition();
    final weatherForecast = await _weatherService.getWeatherForecast(position);

    List<String> todayWeather = [];
    List<String> tomorrowWeather = [];
    List<String> futureWeather = [];

    //maximum weather view for event is 3 days
    for (EventDetails event in _allEvents) {
      DateTime eventTime = event.start_date.toDate();

      if (event.allday == true) {
        eventTime = eventTime.add(const Duration(hours: 12));
      }
      for (WeatherForecast weather in weatherForecast) {
        DateTime weatherTime = DateTime.parse(weather.time);

        if (eventTime.day == weatherTime.day &&
            eventTime.hour == weatherTime.hour) {
          // today <= eventstartdate < tomorrow
          if (eventTime.isAtSameMomentAs(today) ||
              eventTime.isAfter(today) && eventTime.isBefore(tomorrow)) {
            todayWeather.add(weather.icon);
          }
          // tomorrow <= eventTime < aftertomorrow
          else if (eventTime.isAtSameMomentAs(tomorrow) ||
              eventTime.isAfter(tomorrow) &&
                  eventTime.isBefore(afterTomorrow)) {
            tomorrowWeather.add(weather.icon);
          }
          //aftertomorrow <= eventTime
          else if (eventTime.isAtSameMomentAs(afterTomorrow) ||
              eventTime.isAfter(afterTomorrow)) {
            futureWeather.add(weather.icon);
          }
        }
      }
    }
    setState(() {
      _todayWeather = todayWeather;
      _tomorrowWeather = tomorrowWeather;
      _futureWeather = futureWeather;
      isLoadingWeather = false;
    });
  }

  @override
  void initState() {
    super.initState();
    // loadEvents();
    fetchWeatherMapping();
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

                    //TODAY SECTION
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
                                    event.allday
                                        ? 'All Day'
                                        : DateFormat('HH:mm').format(startDate),
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Poppins',
                                        fontSize: 16),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    bool isChange =
                                        await eventPopup(context, event);
                                    isChange ? await loadEvents() : null;
                                  },
                                  child: Container(
                                    height: screenHeight * 0.13,
                                    width: screenWidth * 0.7,
                                    padding:
                                        EdgeInsets.all(screenHeight * 0.01),
                                    color:
                                        const Color.fromRGBO(65, 129, 225, 1),
                                    child: Row(
                                      children: [
                                        //left
                                        SizedBox(
                                          width: screenWidth * 0.45,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              //event title
                                              Expanded(
                                                child: Text(
                                                  title,
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontFamily: 'Poppins',
                                                      fontSize: 25,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),

                                              //people
                                              Text(
                                                peopleNum != 0
                                                    ? location != ''
                                                        ? '$location, $peopleNum people'
                                                        : 'with $peopleNum people'
                                                    : location != ''
                                                        ? location
                                                        : '',
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontFamily: 'Poppins',
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        //right
                                        isLoadingWeather
                                            ? const CircularProgressIndicator()
                                            : Expanded(
                                                child: Image.network(
                                                  'https:${_todayWeather[index]}',
                                                  fit: BoxFit.contain,
                                                ),
                                              ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
//------------------------------------------
                    //TOMORROW SECTION
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
                                    event.allday
                                        ? 'All Day'
                                        : DateFormat('HH:mm').format(startDate),
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Poppins',
                                        fontSize: 16),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    bool isChange =
                                        await eventPopup(context, event);
                                    isChange ? await loadEvents() : null;
                                  },
                                  child: Container(
                                    height: screenHeight * 0.13,
                                    width: screenWidth * 0.7,
                                    padding:
                                        EdgeInsets.all(screenHeight * 0.01),
                                    color:
                                        const Color.fromRGBO(65, 129, 225, 1),
                                    child: Row(
                                      children: [
                                        //left
                                        SizedBox(
                                          width: screenWidth * 0.45,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              //event title
                                              Expanded(
                                                child: Text(
                                                  title,
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontFamily: 'Poppins',
                                                      fontSize: 25,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),

                                              //people
                                              Text(
                                                peopleNum != 0
                                                    ? location != ''
                                                        ? '$location, $peopleNum people'
                                                        : 'with $peopleNum people'
                                                    : location != ''
                                                        ? location
                                                        : '',
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontFamily: 'Poppins',
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        //right
                                        isLoadingWeather
                                            ? const CircularProgressIndicator()
                                            : Expanded(
                                                child: Image.network(
                                                  'https:${_tomorrowWeather[index]}',
                                                  fit: BoxFit.contain,
                                                ),
                                              ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
//------------------------------------------
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
                                        event.allday
                                            ? 'All Day'
                                            : DateFormat('HH:mm')
                                                .format(startDate),
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'Poppins',
                                            fontSize: 16),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        bool isChange =
                                            await eventPopup(context, event);
                                        isChange ? await loadEvents() : null;
                                      },
                                      child: Container(
                                        height: screenHeight * 0.13,
                                        width: screenWidth * 0.7,
                                        padding:
                                            EdgeInsets.all(screenHeight * 0.01),
                                        color: const Color.fromRGBO(
                                            65, 129, 225, 1),
                                        child: Row(
                                          children: [
                                            //left
                                            SizedBox(
                                              width: screenWidth * 0.45,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  //event title
                                                  Expanded(
                                                    child: Text(
                                                      title,
                                                      style: const TextStyle(
                                                          color: Colors.white,
                                                          fontFamily: 'Poppins',
                                                          fontSize: 25,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),

                                                  //people
                                                  Text(
                                                    peopleNum != 0
                                                        ? location != ''
                                                            ? '$location, $peopleNum people'
                                                            : 'with $peopleNum people'
                                                        : location != ''
                                                            ? location
                                                            : '',
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16,
                                                      fontFamily: 'Poppins',
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            //right
                                            isLoadingWeather
                                                ? const CircularProgressIndicator()
                                                : _futureWeather.isEmpty
                                                    ? Container()
                                                    : Expanded(
                                                        child: Image.network(
                                                          'https:${_futureWeather[index]}',
                                                          fit: BoxFit.contain,
                                                        ),
                                                      ),
                                          ],
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
