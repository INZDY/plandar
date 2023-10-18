import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class Planner extends StatefulWidget {
  const Planner({super.key});

  @override
  State<Planner> createState() => _PlannerState();
}

class _PlannerState extends State<Planner> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        // shadowColor: Colors.transparent,
        title: const Text(
          'Calendar',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Container(
        //background
        width: double.maxFinite,
        height: double.maxFinite,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF000000), Color(0xFF07023A)],
          ),
        ),

        //Widget Render
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            children: [
              Container(
                height: 400,
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: const Color(0xFF99AFFF),
                ),
                child: SfCalendar(
                  //settings
                  view: CalendarView.month,
                  monthViewSettings: const MonthViewSettings(
                    navigationDirection: MonthNavigationDirection.vertical,
                    dayFormat: 'EEE',
                  ),
                  headerStyle: const CalendarHeaderStyle(
                    textAlign: TextAlign.center,
                  ),
                  viewHeaderHeight: 60,
                  firstDayOfWeek: 1, //Monday
                  initialDisplayDate: DateTime.now(),
                  showCurrentTimeIndicator: true,
                  // showNavigationArrow: true,

                  //appearance
                  selectionDecoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(color: Colors.black, width: 2),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(10))),
                  cellBorderColor: Colors.transparent,
                  backgroundColor: Colors.transparent,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
