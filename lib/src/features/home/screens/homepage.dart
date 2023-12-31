/*
    Home page 
      There are 6 section in total for this page, arranged by column
      list with ordinal number in comment.
        -First column element : welcome text and setting button
        -Second column element : today's weather
        -Third column element : plain text
        -Fourth column element : today event card & see all option (if avaliable)
        -Fifth column element : plain text
        -Sixth column element : tomorrow event card & see all option (if avaliable)
*/
import 'package:fitgap/src/utils/weather/weather_service.dart';
import 'package:fitgap/src/features/home/screens/homeall.dart';
import 'package:fitgap/src/features/settings/screens/settings.dart';
import 'package:fitgap/src/utils/weather/weather_api_key.dart';
import 'package:fitgap/src/utils/weather/weather_model.dart';
import 'package:flutter/material.dart';
import 'package:fitgap/src/utils/firestore/firestore.dart';
import 'package:intl/intl.dart';
import 'package:marquee/marquee.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<Map<String, dynamic>> eventsDataToday;
  late List<Map<String, dynamic>> eventsDataTomorrow;
  late Map<String, dynamic> userData;
  late Map<String, dynamic> firstEventToday;
  late Map<String, dynamic> firstEventTomorrow;
  bool isLoading = true;

  //weather
  final _weatherService = WeatherService(WeatherAPIKey.weatherAPI);
  late Weather _weatherCurrent;
  late List<WeatherForecast> _weatherForecast;
  late WeatherForecast firstWeatherToday;
  late WeatherForecast firstWeatherTomorrow;
  bool isLoadingWeather = true;

  //get event and user's data, set to variable
  Future loadEvents() async {
    isLoading = true;

    final userDetail = await FirestoreService().getUserData();

    DateTime now = DateTime.now();
    final List<Map<String, dynamic>> eventsToday = await FirestoreService()
        .getEventsInDay(DateTime(now.year, now.month, now.day),
            DateTime(now.year, now.month, now.day + 1));
    final List<Map<String, dynamic>> eventsTomorrow = await FirestoreService()
        .getEventsInDay(DateTime(now.year, now.month, now.day + 1),
            DateTime(now.year, now.month, now.day + 2));

    setState(() {
      eventsDataToday = eventsToday;
      eventsDataTomorrow = eventsTomorrow;
      userData = userDetail ?? {};
      if (eventsToday.isNotEmpty) {
        firstEventToday = eventsToday[0];
      } else {
        firstEventToday = {};
      }
      if (eventsTomorrow.isNotEmpty) {
        firstEventTomorrow = eventsTomorrow[0];
      } else {
        firstEventTomorrow = {};
      }
    });

    isLoading = false;
  }

  void fetchWeather() async {
    //need to wait for events
    await loadEvents();

    isLoadingWeather = true;

    String position = await _weatherService.getCurrentPosition();

    final weatherCurrent = await _weatherService.getCurrentWeather(position);
    final weatherForecast =
        await _weatherService.getWeatherForecast(position, 2);

    setState(() {
      _weatherCurrent = weatherCurrent;
      _weatherForecast = weatherForecast;

      //FIND SOLUTION FOR EMPTY MAP
      //This is a very confusing ifs
      //Have to do this because we can't access objects if null
      //Adding if conditions to check and assign before is redundant

      for (WeatherForecast weather in _weatherForecast) {
        DateTime weatherTime = DateTime.parse(weather.time);

        if (firstEventToday.isNotEmpty &&
            weatherTime.day == firstEventToday['start_date'].toDate().day &&
            weatherTime.hour ==
                (firstEventToday['allday']
                    ? 12
                    : firstEventToday['start_date'].toDate().hour)) {
          firstWeatherToday = weather;
        } else if (firstEventTomorrow.isNotEmpty &&
            weatherTime.day == firstEventTomorrow['start_date'].toDate().day &&
            weatherTime.hour ==
                (firstEventTomorrow['allday']
                    ? 12
                    : firstEventTomorrow['start_date'].toDate().hour)) {
          firstWeatherTomorrow = weather;
        }
      }
      isLoadingWeather = false;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchWeather();
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //First column element : welcome text and setting button
            SizedBox(
              height: screenHeight * 0.0833,
              width: screenWidth * 0.9,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                      width: screenWidth * 0.1, child: const CircleAvatar()),
                  SizedBox(
                    width: screenWidth * 0.65,
                    child: isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : Text(
                            "WELCOME BACK ${userData['username']}",
                            style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                  ),
                  SizedBox(
                    width: screenWidth * 0.1,
                    child: IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Settings(),
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.settings,
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
            ),

            //Second column element : today's weather
            SizedBox(
              height: screenHeight * 0.0625,
              width: screenWidth * 0.9,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: isLoadingWeather
                    ? [const CircularProgressIndicator()]
                    : [
                        Image.network('https:${_weatherCurrent.icon}'),
                        const SizedBox(
                          width: 15,
                        ),
                        SizedBox(
                          width: screenWidth * 0.7,
                          child: Marquee(
                            pauseAfterRound: const Duration(seconds: 1),
                            text: '${_weatherCurrent.condition} '
                                '${_weatherCurrent.temperature.round()} °C, '
                                '${_weatherCurrent.cityName}.'
                                '   ',
                            style: const TextStyle(
                                fontSize: 18, color: Colors.white),
                          ),
                        )
                      ],
              ),
            ),

            //Third column element : plain text
            Container(
              height: screenHeight * 0.06,
              width: screenWidth * 0.9,
              alignment: Alignment.centerLeft,
              child: const Text('Here is your schedule today:',
                  style: TextStyle(fontFamily: 'Poppins')),
            ),

            //Fourth column element : today event card & see all option (if avaliable)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: SizedBox(
                height: screenHeight * 0.25,
                width: screenWidth * 0.95,
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                              image:
                                  AssetImage('assets/images/homeElement.png'),
                              fit: BoxFit.contain),
                        ),

                        //Data in card
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            //left side
                            Container(
                              constraints:
                                  BoxConstraints(maxWidth: screenWidth * 0.55),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Temperature
                                  Text(
                                    (isLoadingWeather ||
                                            firstEventToday.isEmpty)
                                        ? ''
                                        : '${firstWeatherToday.temperature.round().toString()} °C',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),

                                  //Event title
                                  //Event time
                                  Text(
                                    (firstEventToday.isEmpty)
                                        ? "You don’t have any schedule today!!"
                                        : firstEventToday['allday'] == true
                                            ? "${DateFormat('dd MMM').format(firstEventToday['start_date'].toDate())} All Day\n"
                                                "Event: ${firstEventToday['title']}"
                                            : "${DateFormat('dd MMM HH:mma').format(firstEventToday['start_date'].toDate())}\n"
                                                "Event: ${firstEventToday['title']}",
                                    style: const TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 20,
                                      color: Colors.white,
                                    ),
                                  ),

                                  //Location
                                  Text(
                                    (firstEventToday.isEmpty)
                                        ? ''
                                        : "${firstEventToday['location']}",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            //right side
                            Container(
                              constraints:
                                  BoxConstraints(maxWidth: screenWidth * 0.3),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  //see all
                                  Container(
                                    child: (firstEventToday.isEmpty)
                                        ? null
                                        : TextButton(
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => HomeAll(
                                                    date: 'today',
                                                    events: eventsDataToday,
                                                    weatherList:
                                                        _weatherForecast,
                                                  ),
                                                ),
                                              );
                                            },
                                            child: const Text(
                                              'See all >>',
                                              style: TextStyle(
                                                color: Color.fromRGBO(
                                                    184, 184, 184, 1),
                                                fontSize: 14,
                                                fontFamily: 'Poppins',
                                              ),
                                            ),
                                          ),
                                  ),

                                  //weather icon
                                  Container(
                                    child: isLoadingWeather
                                        ? const CircularProgressIndicator()
                                        : firstEventToday.isEmpty
                                            ? null
                                            : Image.network(
                                                'https:${firstWeatherToday.icon}'),
                                  ),

                                  //weather condition
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: (isLoadingWeather ||
                                            firstEventToday.isEmpty)
                                        ? null
                                        : Text(
                                            firstWeatherToday.condition,
                                            style: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.white),
                                          ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
            ),
            //Fifth column element : plain text
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Container(
                height: screenHeight * 0.0525,
                width: screenWidth * 0.9,
                alignment: Alignment.centerLeft,
                child: const Text('Here is your schedule tomorrow:',
                    style: TextStyle(fontFamily: 'Poppins')),
              ),
            ),
            //Sixth column element : tomorrow event card & see all option (if avaliable)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: SizedBox(
                height: screenHeight * 0.25,
                width: screenWidth * 0.95,
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                              image:
                                  AssetImage('assets/images/homeElement.png'),
                              fit: BoxFit.contain),
                        ),

                        //Data in card
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            //left side
                            Container(
                              constraints:
                                  BoxConstraints(maxWidth: screenWidth * 0.55),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Temperature
                                  Text(
                                    (isLoadingWeather ||
                                            firstEventTomorrow.isEmpty)
                                        ? ''
                                        : '${firstWeatherTomorrow.temperature.round().toString()} °C',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),

                                  //Event title
                                  //Event time
                                  Text(
                                    (firstEventTomorrow.isEmpty)
                                        ? "You don’t have any schedule today!!"
                                        : firstEventTomorrow['allday'] == true
                                            ? "${DateFormat('dd MMM').format(firstEventTomorrow['start_date'].toDate())} All Day\n"
                                                "Event: ${firstEventTomorrow['title']}"
                                            : "${DateFormat('dd MMM HH:mma').format(firstEventTomorrow['start_date'].toDate())}\n"
                                                "Event: ${firstEventTomorrow['title']}",
                                    style: const TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 20,
                                      color: Colors.white,
                                    ),
                                  ),

                                  //Location
                                  Text(
                                    (firstEventTomorrow.isEmpty)
                                        ? ''
                                        : "${firstEventTomorrow['location']}",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            //right side
                            Container(
                              constraints:
                                  BoxConstraints(maxWidth: screenWidth * 0.3),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  //see all
                                  Container(
                                    child: (firstEventTomorrow.isEmpty)
                                        ? null
                                        : TextButton(
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => HomeAll(
                                                    date: 'today',
                                                    events: eventsDataToday,
                                                    weatherList:
                                                        _weatherForecast,
                                                  ),
                                                ),
                                              );
                                            },
                                            child: const Text(
                                              'See all >>',
                                              style: TextStyle(
                                                color: Color.fromRGBO(
                                                    184, 184, 184, 1),
                                                fontSize: 14,
                                                fontFamily: 'Poppins',
                                              ),
                                            ),
                                          ),
                                  ),

                                  //weather icon
                                  Container(
                                    child: isLoadingWeather
                                        ? const CircularProgressIndicator()
                                        : firstEventTomorrow.isEmpty
                                            ? null
                                            : Image.network(
                                                'https:${firstWeatherTomorrow.icon}'),
                                  ),

                                  //weather condition
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: (isLoadingWeather ||
                                            firstEventTomorrow.isEmpty)
                                        ? null
                                        : Text(
                                            firstWeatherTomorrow.condition,
                                            style: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.white),
                                          ),
                                  ),
                                ],
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
    );
  }
}
