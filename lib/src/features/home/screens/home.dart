import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:fitgap/src/features/contract/contract_page/contract.dart';
import 'package:fitgap/src/features/home/screens/homepage.dart';
import 'package:fitgap/src/features/planner/screens/planner.dart';
import 'package:flutter/material.dart';
import 'package:fitgap/src/features/addevent/addevent.dart';
import 'package:fitgap/src/features/dashboard/screens/dashboard.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

//widget switching
class _HomeState extends State<Home> {
  final _pageController = PageController(initialPage: 0);
  final _controller = NotchBottomBarController(index: 0);

  //widget list
  final List<Widget> _pageOptions = <Widget>[
    const HomePage(), //choice 0 (most left button) 'HomePage'
    const DashBoard(),
    const AddNewEvent(), //choice 2 (middle button) 'addNewEvent'
    const Planner(),
    const ContractPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: _pageOptions,
        ),
        extendBody: true,

        //Navbar
        bottomNavigationBar: SizedBox(
          //height is here to prevent keyboard pushing
          height: 100,
          child: AnimatedNotchBottomBar(
            color: const Color(0xFF5936B4),
            notchBottomBarController: _controller,
            bottomBarItems: const [
              //home
              BottomBarItem(
                inActiveItem: Icon(
                  Icons.home_filled,
                  color: Colors.white,
                ),
                activeItem: Icon(
                  Icons.home_filled,
                  color: Colors.black,
                ),
              ),
        
              //dashboard
              BottomBarItem(
                inActiveItem: Icon(
                  Icons.dashboard_outlined,
                  color: Colors.white,
                ),
                activeItem: Icon(
                  Icons.dashboard_outlined,
                  color: Colors.black,
                ),
              ),
        
              //add event
              BottomBarItem(
                inActiveItem: Icon(
                  Icons.add_circle_outline,
                  color: Colors.white,
                ),
                activeItem: Icon(
                  Icons.add_circle_outline,
                  color: Colors.black,
                ),
              ),
        
              //planner
              BottomBarItem(
                inActiveItem: Icon(
                  Icons.calendar_month_outlined,
                  color: Colors.white,
                ),
                activeItem: Icon(
                  Icons.calendar_month_outlined,
                  color: Colors.black,
                ),
              ),
        
              //contacts
              BottomBarItem(
                inActiveItem: Icon(
                  Icons.contacts_outlined,
                  color: Colors.white,
                ),
                activeItem: Icon(
                  Icons.contacts_outlined,
                  color: Colors.black,
                ),
              ),
            ],
            onTap: (index) {
              _pageController.jumpToPage(index);
            },
            // onTap: (index) {
            //   _pageController.jumpToPage(index);
            // },
          ),
        ),
      ),
    );
  }
}