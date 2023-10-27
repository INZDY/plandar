/*  
    AddNewEventPeople page 
      -sub page of AddNewEvent page 
      -query list of people in contract
      -return list of selected people
*/

import 'package:flutter/material.dart';

class AddNewEventPeople extends StatefulWidget {
  const AddNewEventPeople({
    super.key,
  });

  @override
  State<AddNewEventPeople> createState() => _AddNewEventPeopleState();
}

class _AddNewEventPeopleState extends State<AddNewEventPeople> {
  List<String> people = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, 'Yep!');
                },
                child: const Text('Yep!'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, 'Nope!');
                },
                child: const Text('Nope.'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
