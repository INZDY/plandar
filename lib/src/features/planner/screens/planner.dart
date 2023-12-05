import 'dart:async';

import 'package:fitgap/src/features/planner/models/modify_event.dart';
import 'package:fitgap/src/utils/firestore/firestore.dart';
import 'package:fitgap/src/utils/utility/month_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:intl/intl.dart';

class Planner extends StatefulWidget {
  const Planner({super.key});

  @override
  State<Planner> createState() => _PlannerState();
}

class _PlannerState extends State<Planner> {
  late List<EventDetails> _eventsData;

  List<Appointment> appointmentDetails = <Appointment>[];
  late _AppointmentDataSource dataSource;

  DateTime selectedDate = DateTime.now();

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadEvents();
  }

  Future loadEvents() async {
    final eventsData = await FirestoreService().getEvents();
    Future.delayed(const Duration(milliseconds: 700), () {
      setState(() {
        isLoading = false;
      });
    });

    setState(() {
      _eventsData = eventsData;
      dataSource = _getCalendarDataSource();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        toolbarHeight: 90,
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
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  children: [
                    //Calendar
                    Container(
                      height: 400,
                      padding: const EdgeInsets.only(
                          top: 20, bottom: 30, left: 30, right: 30),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: const Color(0xFF99AFFF),
                      ),
                      child: SfCalendar(
                        //settings
                        view: CalendarView.month,
                        todayTextStyle: const TextStyle(fontSize: 16),
                        monthViewSettings: const MonthViewSettings(
                            navigationDirection:
                                MonthNavigationDirection.vertical,
                            dayFormat: 'EEE',
                            monthCellStyle: MonthCellStyle(
                              textStyle: TextStyle(fontSize: 14),
                            )),
                        firstDayOfWeek: 1, //Monday
                        showCurrentTimeIndicator: true,
                        showDatePickerButton: true,
                        dataSource: _getCalendarDataSource(),
                        initialSelectedDate: DateTime.now(),
                        onSelectionChanged: selectionChanged,

                        //appearance
                        headerStyle: const CalendarHeaderStyle(
                          textAlign: TextAlign.center,
                        ),
                        viewHeaderHeight: 50,
                        selectionDecoration: BoxDecoration(
                            color: Colors.transparent,
                            border: Border.all(color: Colors.black, width: 1),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10))),
                        cellBorderColor: Colors.transparent,
                        backgroundColor: Colors.transparent,
                      ),
                    ),

                    const SizedBox(
                      height: 15,
                    ),

                    Container(
                      alignment: Alignment.centerLeft,
                      height: 50,
                      child: Text(
                        '${selectedDate.day} '
                        '${NumberToMonthMap.monthsInYear[selectedDate.month]} '
                        '${selectedDate.year}',
                      ),
                    ),

                    //Appointments
                    Expanded(
                      child: Container(
                        color: Colors.transparent,
                        child: ListView.separated(
                          itemCount: appointmentDetails.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              alignment: Alignment.center,
                              height: 55,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: appointmentDetails[index].color,
                              ),
                              child: ListTile(
                                  trailing: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: appointmentDetails[index].isAllDay
                                        ? [
                                            const Text(
                                              'All day',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.white,
                                              ),
                                            )
                                          ]
                                        : [
                                            Text(
                                              DateFormat('hh:mm a').format(
                                                  appointmentDetails[index]
                                                      .startTime),
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.white,
                                              ),
                                            ),
                                            Text(
                                              DateFormat('hh:mm a').format(
                                                  appointmentDetails[index]
                                                      .endTime),
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                  ),
                                  title: Text(
                                    appointmentDetails[index].title,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white),
                                  ),
                                  onTap: () async {
                                    bool isChanged = await eventPopup(
                                        context, appointmentDetails[index]);

                                    isChanged ? await loadEvents() : null;
                                  }),
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) =>
                              const SizedBox(
                            height: 15,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
      ),
    );
  }

  Future<bool> eventPopup(BuildContext context, Appointment appointment) {
    Completer<bool> completer = Completer<bool>();

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Container(
            width: double.infinity,
            height: double.infinity,
            alignment: Alignment.center,
            color: const Color.fromARGB(0, 45, 45, 45),
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
            child: ModifyEvent(
              eventDetail: appointment,
            ),
          );
        }).then((value) => completer.complete(value));

    return completer.future;
  }

  void selectionChanged(CalendarSelectionDetails calendarSelectionDetails) {
    getSelectedDateAppointments(calendarSelectionDetails.date);
    selectedDate = calendarSelectionDetails.date!;
  }

  void getSelectedDateAppointments(DateTime? selectedDate) {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      setState(() {
        appointmentDetails.clear();
      });

      if (dataSource.appointments!.isEmpty) {
        return;
      }

      for (int i = 0; i < dataSource.appointments!.length; i++) {
        Appointment appointment = dataSource.appointments![i] as Appointment;

        /// It return the occurrence appointment for the given pattern appointment at the selected date.
        final Appointment? occurrenceAppointment =
            dataSource.getOccurrenceAppointment(appointment, selectedDate!, '')
                as Appointment?;

        DateTime appointmentStart = toDateTime(appointment.startTime.day,
            appointment.startTime.month, appointment.startTime.year);

        DateTime appointmentEnd = toDateTime(appointment.endTime.day,
            appointment.endTime.month, appointment.endTime.year);

        DateTime selected =
            toDateTime(selectedDate.day, selectedDate.month, selectedDate.year);

        //Check if event is in that day
        //Conditions:
        //1. Date at start date
        //2. Date at end date
        //3. Date in between
        if (selected == appointmentStart ||
            selected == appointmentEnd ||
            (selected.isAfter(appointmentStart) &&
                selected.isBefore(appointmentEnd)) ||
            occurrenceAppointment != null) {
          setState(() {
            appointmentDetails.add(appointment);
          });
        }
      }
      // print(appointmentDetails);
    });
  }

  //int day month year to DateTime
  DateTime toDateTime(int day, int month, int year) {
    return DateTime(year, month, day);
  }

  _AppointmentDataSource _getCalendarDataSource() {
    List<Appointment> appointments = <Appointment>[];

    for (var event in _eventsData) {
      //color from value to color
      int colorValue = int.parse(event.tag);
      Color color = Color(colorValue).withOpacity(1);

      appointments.add(Appointment(
        id: event.id,
        title: event.title,
        startTime: event.start_date.toDate(),
        endTime: event.end_date.toDate(),
        color: color,
        isAllDay: event.allday,
        location: event.location,
        people: event.people,
      ));
    }
    return _AppointmentDataSource(appointments);
  }
}

//Class & Overrides for calendar
class Appointment {
  Appointment({
    required this.startTime,
    required this.endTime,
    required this.title,
    required this.id,
    this.isAllDay = false,
    this.color = Colors.transparent,
    this.location = '',
    this.people = const [],
  });

  String id;
  String title;
  String location;
  DateTime startTime;
  DateTime endTime;
  bool isAllDay;
  Color color;
  List<String> people;
}

class _AppointmentDataSource extends CalendarDataSource {
  _AppointmentDataSource(List<Appointment> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].startTime;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].endTime;
  }

  @override
  String getSubject(int index) {
    return appointments![index].title;
  }

  @override
  bool isAllDay(int index) {
    return appointments![index].isAllDay;
  }

  @override
  Color getColor(int index) {
    return appointments![index].color;
  }

  @override
  String getLocation(int index) {
    return appointments![index].location;
  }

  List<String> getPeople(int index) {
    return appointments![index].people;
  }

  @override
  String getId(int index) {
    return appointments![index].id;
  }
}
