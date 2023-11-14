import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomeAll extends StatefulWidget {
  const HomeAll({super.key, required this.date, required this.event});

  final String date;
  final List<Map<String, dynamic>> event;

  @override
  State<HomeAll> createState() => _HomeAllState();
}

class _HomeAllState extends State<HomeAll> {
  late String date = widget.date;
  late List<Map<String, dynamic>> event = widget.event;

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        body: Container(
          height: double.infinity,
          width: screenWidth * 1,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.black, Color.fromRGBO(7, 2, 58, 1)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            children: [
              Container(
                height: screenHeight * 0.1,
                width: screenWidth * 0.95,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    CircleAvatar(),
                  ],
                ),
              ),
              Container(
                height: screenHeight * 0.05,
                width: screenWidth * 0.95,
                child: Text(
                  'Here is your schedule $date:',
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Poppins',
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                height: screenHeight * 0.03,
                width: screenWidth * 0.95,
                child: Text(
                  "${DateFormat('EEEE, d MMM').format(event[0]['start_date'].toDate())}",
                  style: TextStyle(
                      color: Colors.white, fontFamily: 'Poppins', fontSize: 16),
                ),
              ),
              Container(
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
              Container(
                height: screenHeight * 0.715,
                width: screenWidth * 1,
                child: ListView.builder(
                  itemCount: event.length,
                  itemBuilder: (context, index) {
                    Map<String, dynamic> eventData = event[index];
                    return Container(
                      height: screenHeight * 0.15,
                      child: Row(
                        children: [
                          Container(
                            height: screenHeight * 0.125,
                            width: screenWidth * 0.2,
                            alignment: Alignment.topCenter,
                            child: Text(
                              "${DateFormat('HH:mm').format(event[index]['start_date'].toDate())}",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Poppins',
                                  fontSize: 16),
                            ),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Container(
                              height: screenHeight * 0.15,
                              width: 2,
                              color: Colors.white,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                            ),
                          ),
                          Container(
                            width: screenWidth * 0.7,
                            height: screenHeight * 0.13,
                            child: Container(
                              padding: EdgeInsets.all(screenHeight * 0.01),
                              color: date == 'today'
                                  ? const Color.fromRGBO(65, 129, 225, 1)
                                  : const Color.fromRGBO(25, 23, 133, 1),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        height: screenHeight * 0.075,
                                        width: screenWidth * 0.55,
                                        child: Text(
                                          '${event[index]['title']}',
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontFamily: 'Poppins',
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
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
                                  Container(
                                    height: screenHeight * 0.03,
                                    width: screenWidth * 0.7,
                                    child: Text(
                                      '${event[index]['location']}',
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 16),
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
            ],
          ),
        ),
      ),
    );
  }
}
