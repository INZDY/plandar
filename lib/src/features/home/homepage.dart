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
              width: screenWidth * 1,
              color: Colors.deepPurple[600],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Container(
                height: screenHeight * 0.0625,
                width: screenWidth * 1,
                color: Colors.deepPurple[500],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Container(
                height: screenHeight * 0.0525,
                width: screenWidth * 1,
                color: Colors.deepPurple[400],
                padding: const EdgeInsets.only(left: 30),
                alignment: Alignment.centerLeft,
                child: Text('Here is your schedule today:',
                    style: Theme.of(context).textTheme.labelSmall),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Container(
                height: screenHeight * 0.25,
                width: screenWidth * 1,
                color: Colors.deepPurple[300],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Container(
                height: screenHeight * 0.0525,
                width: screenWidth * 1,
                color: Colors.deepPurple[200],
                padding: const EdgeInsets.only(left: 30),
                alignment: Alignment.centerLeft,
                child: Text('Here is your schedule tomorrow:',
                    style: Theme.of(context).textTheme.labelSmall),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Container(
                height: screenHeight * 0.25,
                width: screenWidth * 1,
                color: Colors.deepPurple[100],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
