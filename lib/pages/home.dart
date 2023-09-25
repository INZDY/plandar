import 'package:flutter/material.dart';
import 'package:fitgap/pages/settings.dart';

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
    Text(
      'Index 0: Contact',
    ),
    Text(
      'Index 1: Dashboard',
    ),
    Text(
      'Index 2: Add Event',
    ),
    Text(
      'Index 3: Planner',
    ),
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
      //widget show
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),

      //Navbar
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.contacts),
              label: 'Contacts',
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
