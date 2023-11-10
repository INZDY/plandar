import 'package:fitgap/src/features/home/homeall.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
            Container(
              height: screenHeight * 0.0833,
              width: screenWidth * 0.9,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      width: screenWidth * 0.1, child: const CircleAvatar()),
                  Container(
                    width: screenWidth * 0.65,
                    child: Text(
                      'WELCOME BACK {JOEMama}',
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  //Link to setting page *****
                  Container(
                    width: screenWidth * 0.1,
                    child: IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.settings,
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              height: screenHeight * 0.0625,
              width: screenWidth * 0.9,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(
                    Icons.cloudy_snowing,
                    color: Colors.white,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: screenWidth * 0.05),
                    child: Text(
                      'Rainy 27°',
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 18,
                          color: Colors.white),
                    ),
                  )
                ],
              ),
            ),
            Container(
              height: screenHeight * 0.06,
              width: screenWidth * 0.9,
              alignment: Alignment.centerLeft,
              child: Text('Here is your schedule today:',
                  style: TextStyle(fontFamily: 'Poppins')),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Container(
                  height: screenHeight * 0.25,
                  width: screenWidth * 0.95,
                  child: Stack(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                              image:
                                  AssetImage('assets/images/homeElement.png'),
                              fit: BoxFit.cover),
                        ),
                      ),
                      Column(
                        children: [
                          Container(
                            height: screenHeight * 0.04,
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const HomeAll(date: 'today'),
                                  ),
                                );
                              },
                              child: const Text(
                                'See all >>',
                                style: TextStyle(
                                  color: Color.fromRGBO(184, 184, 184, 1),
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
                              child: const Text(
                                '{15 Sep 22:00pm}\nEvent: {hang hang}',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          Transform.translate(
                            offset: Offset(0, -screenHeight * 0.01),
                            child: Container(
                              height: screenHeight * 0.035,
                              width: screenWidth * 0.85,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: screenWidth * 0.6,
                                    alignment: Alignment.centerLeft,
                                    child: const Text(
                                      '{KMUTT, Bangmod, Bangkok}',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                  ),
                                  Container(
                                    child: const Text(
                                      'Rainny',
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.white),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  )),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Container(
                height: screenHeight * 0.0525,
                width: screenWidth * 0.9,
                alignment: Alignment.centerLeft,
                child: Text('Here is your schedule tomorrow:',
                    style: TextStyle(fontFamily: 'Poppins')),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Container(
                  height: screenHeight * 0.25,
                  width: screenWidth * 0.95,
                  child: Stack(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                              image:
                                  AssetImage('assets/images/homeElement.png'),
                              fit: BoxFit.cover),
                        ),
                      ),
                      Column(
                        children: [
                          Container(
                            height: screenHeight * 0.04,
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const HomeAll(date: 'tomorrow'),
                                  ),
                                );
                              },
                              child: const Text(
                                'See all >>',
                                style: TextStyle(
                                  color: Color.fromRGBO(184, 184, 184, 1),
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
                              child: const Text(
                                '{15 Sep 22:00pm}\nEvent: {hang hang}',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ),
                          ),
                          Transform.translate(
                            offset: Offset(0, -screenHeight * 0.01),
                            child: Container(
                              height: screenHeight * 0.035,
                              width: screenWidth * 0.85,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: screenWidth * 0.6,
                                    alignment: Alignment.centerLeft,
                                    child: const Text(
                                      '{KMUTT, Bangmod, Bangkok}',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                  ),
                                  Container(
                                    child: const Text(
                                      'Sunny',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                  )
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
