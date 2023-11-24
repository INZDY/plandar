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
import 'package:fitgap/src/features/home/applications/weather_service.dart';
import 'package:fitgap/src/features/home/models/weather_api_key.dart';
import 'package:fitgap/src/features/home/models/weather_model.dart';
import 'package:fitgap/src/features/home/screens/homeall.dart';
import 'package:fitgap/src/features/settings/settings.dart';
import 'package:flutter/material.dart';
import 'package:fitgap/src/utils/firestore/firestore.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<Map<String, dynamic>> eventsDataToday;
  late List<Map<String, dynamic>> eventsDataTomorrow;
  Map<String, dynamic>? userData;
  Map<String, dynamic>? firstEventToday;
  Map<String, dynamic>? firstEventTomorrow;
  bool isLoading = true;

  //weather
  final _weatherService = WeatherService(WeatherAPIKey.weatherAPI);
  Weather? _weather;

  @override
  void initState() {
    super.initState();
    loadEvents();
    fetchWeather();
  }

  //get event and user's data, set to variable
  Future loadEvents() async {
    DateTime now = DateTime.now();
    final List<Map<String, dynamic>> eventsToday = await FirestoreService()
        .getEventsInDay(
            now, DateTime(now.year, now.month, now.day + 1, 0, 0, 0));
    final List<Map<String, dynamic>> eventsTomorrow = await FirestoreService()
        .getEventsInDay(DateTime(now.year, now.month, now.day + 1, 0, 0, 0),
            DateTime(now.year, now.month, now.day + 2, 0, 0, 0));
    final userDetail = await FirestoreService().getUserData();

    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        isLoading = false;
      });
    });

    setState(() {
      eventsDataToday = eventsToday;
      eventsDataTomorrow = eventsTomorrow;
      userData = userDetail;
      if (eventsToday.isNotEmpty) {
        firstEventToday = eventsToday[0];
      } else {
        firstEventToday = null;
      }
      if (eventsTomorrow.isNotEmpty) {
        firstEventTomorrow = eventsTomorrow[0];
      } else {
        firstEventTomorrow = null;
      }
    });
  }

  fetchWeather() async {
    String cityName = await _weatherService.getCurrentPosition();

    try {
      final weather = await _weatherService.getCurrentWeather(cityName);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      print(e);
    }
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
                            "WELCOME BACK ${userData!['username']}",
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
                children: [
                  const Icon(
                    Icons.cloudy_snowing,
                    color: Colors.white,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: screenWidth * 0.05),
                    child: Text(
                      '${_weather?.condition ?? ''} '
                      '${_weather?.temperature.round()}°C, '
                      '${_weather?.cityName ?? ''}',
                      style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 18,
                          color: Colors.white),
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
                  child: Stack(
                    children: isLoading
                        ? [const Center(child: CircularProgressIndicator())]
                        : [
                            Container(
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage(
                                        'assets/images/homeElement.png'),
                                    fit: BoxFit.cover),
                              ),
                            ),
                            Column(
                              children: [
                                Container(
                                  height: screenHeight * 0.04,
                                  alignment: Alignment.centerRight,
                                  child: (firstEventToday == null)
                                      ? null
                                      : TextButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => HomeAll(
                                                    date: 'today',
                                                    event: eventsDataToday),
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
                                Transform.translate(
                                  offset: Offset(0, -screenHeight * 0.01),
                                  child: Container(
                                    height: screenHeight * 0.05,
                                    width: screenWidth * 0.85,
                                    alignment: Alignment.centerLeft,
                                    child: const Text(
                                      '27°',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: screenHeight * 0.05,
                                  width: screenWidth * 0.9,
                                  alignment: Alignment.centerRight,
                                  child: Container(
                                    height: screenHeight * 0.08,
                                    width: screenWidth * 0.08,
                                    decoration: const BoxDecoration(
                                      image: DecorationImage(
                                          image: AssetImage(
                                              'assets/images/rainnyIcon.png'),
                                          fit: BoxFit.contain),
                                    ),
                                  ),
                                ),
                                Transform.translate(
                                  offset: Offset(0, -screenHeight * 0.04),
                                  child: Container(
                                    height: screenHeight * 0.075,
                                    width: screenWidth * 0.85,
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      (firstEventToday == null)
                                          ? "You don’t have any schedule today!!"
                                          : "${DateFormat('dd MMM HH:mma').format(firstEventToday!['start_date'].toDate())}\nEvent: ${firstEventToday!['title']}",
                                      style: const TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 20,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                Transform.translate(
                                  offset: Offset(0, -screenHeight * 0.01),
                                  child: SizedBox(
                                    height: screenHeight * 0.035,
                                    width: screenWidth * 0.85,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          width: screenWidth * 0.6,
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            (firstEventToday == null)
                                                ? ''
                                                : "${firstEventToday!['location']}",
                                            style: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.white,
                                              fontFamily: 'Poppins',
                                            ),
                                          ),
                                        ),
                                        const Text(
                                          'Rainny',
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ],
                  )),
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
                  child: Stack(
                    children: isLoading
                        ? [const Center(child: CircularProgressIndicator())]
                        : [
                            Container(
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage(
                                        'assets/images/homeElement.png'),
                                    fit: BoxFit.cover),
                              ),
                            ),
                            Column(
                              children: [
                                Container(
                                  height: screenHeight * 0.04,
                                  alignment: Alignment.centerRight,
                                  child: (firstEventTomorrow == null)
                                      ? null
                                      : TextButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => HomeAll(
                                                    date: 'tomorrow',
                                                    event: eventsDataTomorrow),
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
                                Transform.translate(
                                  offset: Offset(0, -screenHeight * 0.01),
                                  child: Container(
                                    height: screenHeight * 0.05,
                                    width: screenWidth * 0.85,
                                    alignment: Alignment.centerLeft,
                                    child: const Text(
                                      '30°',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: screenHeight * 0.05,
                                  width: screenWidth * 0.9,
                                  alignment: Alignment.centerRight,
                                  child: Container(
                                    height: screenHeight * 0.08,
                                    width: screenWidth * 0.08,
                                    decoration: const BoxDecoration(
                                      image: DecorationImage(
                                          image: AssetImage(
                                              'assets/images/sunnyIcon.png'),
                                          fit: BoxFit.contain),
                                    ),
                                  ),
                                ),
                                Transform.translate(
                                  offset: Offset(0, -screenHeight * 0.04),
                                  child: Container(
                                    height: screenHeight * 0.075,
                                    width: screenWidth * 0.85,
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      (firstEventTomorrow == null)
                                          ? "You don’t have any schedule tomorrow!!"
                                          : "${DateFormat('dd MMM HH:mma').format(firstEventTomorrow!['start_date'].toDate())}\nEvent: ${firstEventTomorrow!['title']}",
                                      style: const TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                  ),
                                ),
                                Transform.translate(
                                  offset: Offset(0, -screenHeight * 0.01),
                                  child: SizedBox(
                                    height: screenHeight * 0.035,
                                    width: screenWidth * 0.85,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          width: screenWidth * 0.6,
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            (firstEventTomorrow == null)
                                                ? ''
                                                : "${firstEventTomorrow!['location']}",
                                            style: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.white,
                                              fontFamily: 'Poppins',
                                            ),
                                          ),
                                        ),
                                        const Text(
                                          'Sunny',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.white,
                                            fontFamily: 'Poppins',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ],
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
