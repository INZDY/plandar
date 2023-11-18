import 'package:fitgap/src/features/contract/contract_page/contract.dart';
import 'package:fitgap/src/features/planner/screens/planner.dart';
import 'package:flutter/material.dart';
import 'package:fitgap/src/features/addevent/addevent.dart';
import 'package:fitgap/src/features/home/homepage.dart';

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

    Text('Index 1: Dashboard'),

    AddNewEvent(), //choice 2 (middle button) 'addNewEvent'

    Planner(),

    ContractPage(),
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
              icon: Icon(Icons.contacts),
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
