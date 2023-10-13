import 'package:flutter/material.dart';

/*
the class must return the value as int since it has to be used for index in 'ListWheelChildBuilderDelegate' 
and later converted as string to put in Text()
*/

class MyMinutes extends StatelessWidget {
  final int mins;
  const MyMinutes({
    required this.mins,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Center(
        child: Text(
          mins < 10 ? '0${mins.toString()}' : mins.toString(),
          style: const TextStyle(
              fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class MyHours extends StatelessWidget {
  final int hours;

  const MyHours({
    required this.hours,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Center(
        child: Text(
          hours < 10 ? '0${hours.toString()}' : hours.toString(),
          style: const TextStyle(
              fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
