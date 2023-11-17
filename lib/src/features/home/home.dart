import 'package:fitgap/src/features/contract/contract_page/contract.dart';
import 'package:fitgap/src/features/planner/screens/planner.dart';
import 'package:flutter/material.dart';
import 'package:fitgap/src/features/settings/settings.dart';
import 'package:fitgap/src/features/addevent/addevent.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _BottomNavBarState();
}

//widget switching
class _BottomNavBarState extends State<Home> {
  int _selectedIndex = 0;

  //widget list
  static const List<Widget> _widgetOptions = <Widget>[
    HomePage(), //choice 0 (most left button) 'HomePage'

    ContractPage(),

    AddNewEvent(), //choice 2 (middle button) 'addNewEvent'

    Planner(),
    Settings(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
      ),

      //Navbar
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
              backgroundColor: Colors.red),
          BottomNavigationBarItem(
              icon: Icon(Icons.dashboard),
              label: 'Dashboard',
              backgroundColor: Colors.green),
          BottomNavigationBarItem(
              icon: Icon(Icons.add_circle_outline),
              label: 'Add Event',
              backgroundColor: Colors.blue),
          BottomNavigationBarItem(
              icon: Icon(Icons.event),
              label: 'Planner',
              backgroundColor: Colors.pink),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
              backgroundColor: Colors.grey),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        onTap: _onItemTapped,
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
  });

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
