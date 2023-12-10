import 'package:fitgap/src/utils/weather/weather_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomeAll extends StatefulWidget {
  const HomeAll({
    super.key,
    required this.date,
    required this.events,
    required this.weatherList,
  });

  final String date;
  final List<Map<String, dynamic>> events;
  final List<WeatherForecast>? weatherList;

  @override
  State<HomeAll> createState() => _HomeAllState();
}

class _HomeAllState extends State<HomeAll> {
  late String date = widget.date;
  late List<Map<String, dynamic>> events = widget.events;
  late List<WeatherForecast>? weatherList = widget.weatherList;

  void weatherMapping() {
    for (WeatherForecast weather in weatherList!) {
      DateTime weatherTime = DateTime.parse(weather.time);
      for (Map<String, dynamic> event in events) {
        DateTime eventTime = event['start_date'].toDate();

        if (eventTime.day == weatherTime.day &&
            eventTime.hour == weatherTime.hour) {
          event['weather'] = weather.icon;
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    weatherMapping();
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
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.black, Color.fromRGBO(7, 2, 58, 1)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            children: [
              SizedBox(
                height: screenHeight * 0.1,
                width: screenWidth * 0.95,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.chevron_left,
                        color: Colors.white,
                      ),
                    ),
                    const CircleAvatar(),
                  ],
                ),
              ),
              SizedBox(
                height: screenHeight * 0.05,
                width: screenWidth * 0.95,
                child: Text(
                  'Here is your schedule $date:',
                  style: const TextStyle(
                      color: Colors.white,
                      fontFamily: 'Poppins',
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: screenHeight * 0.03,
                width: screenWidth * 0.95,
                child: Text(
                  DateFormat('EEEE, d MMM')
                      .format(events[0]['start_date'].toDate()),
                  style: const TextStyle(
                      color: Colors.white, fontFamily: 'Poppins', fontSize: 16),
                ),
              ),
              SizedBox(
                height: screenHeight * 0.06,
                width: screenWidth * 0.95,
                child: Row(
                  children: [
                    const Text(
                      'Time',
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Poppins',
                          fontSize: 18),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: screenWidth * 0.15),
                      child: const Text(
                        'Events',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Poppins',
                            fontSize: 18),
                      ),
                    )
                  ],
                ),
              ),

              //EVENT LIST
              SizedBox(
                height: screenHeight * 0.7,
                width: screenWidth * 1,
                child: ListView.builder(
                  itemCount: events.length,
                  itemBuilder: (context, index) {
                    return SizedBox(
                      height: screenHeight * 0.15,
                      child: Row(
                        children: [
                          Container(
                            height: screenHeight * 0.125,
                            width: screenWidth * 0.2,
                            alignment: Alignment.topCenter,
                            child: Text(
                              DateFormat('HH:mm')
                                  .format(events[index]['start_date'].toDate()),
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Poppins',
                                  fontSize: 16),
                            ),
                          ),
                          Container(
                            height: screenHeight * 0.15,
                            width: 2,
                            alignment: Alignment.center,
                            color: Colors.white,
                            margin: const EdgeInsets.symmetric(horizontal: 8.0),
                          ),
                          Container(
                            padding: EdgeInsets.all(screenHeight * 0.01),
                            color: date == 'today'
                                ? const Color.fromRGBO(65, 129, 225, 1)
                                : const Color.fromRGBO(25, 23, 133, 1),
                            width: screenWidth * 0.7,
                            height: screenHeight * 0.13,
                            //EVENT DETAIL BOX
                            child: Row(
                              children: [
                                //left side
                                SizedBox(
                                  width: screenWidth * 0.45,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          '${events[index]['title']}',
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontFamily: 'Poppins',
                                              fontSize: 25,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Text(
                                        '${events[index]['location']}',
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ),
                                //right side
                                Expanded(
                                  child: Image.network(
                                    'https:${events[index]['weather']}',
                                    // width: screenWidth * 0.4,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ],
                            ),
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
}
