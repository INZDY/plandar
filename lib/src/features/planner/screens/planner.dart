import 'package:fitgap/src/utils/firestore/firestore.dart';
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
  late List<Map<String, dynamic>> _eventsData;

  List<Appointment> appointmentDetails = <Appointment>[];
  late _AppointmentDataSource dataSource;

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
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(25),
                child: Column(
                  children: [
                    //Calendar
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
                          navigationDirection:
                              MonthNavigationDirection.vertical,
                        ),
                        firstDayOfWeek: 1, //Monday
                        initialDisplayDate: DateTime.now(),
                        showCurrentTimeIndicator: true,
                        dataSource: _getCalendarDataSource(),
                        initialSelectedDate: DateTime.now(),
                        onSelectionChanged: selectionChanged,

                        //appearance
                        headerStyle: const CalendarHeaderStyle(
                          textAlign: TextAlign.center,
                        ),
                        viewHeaderHeight: 60,
                        selectionDecoration: BoxDecoration(
                            color: Colors.transparent,
                            border: Border.all(color: Colors.black, width: 2),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10))),
                        cellBorderColor: Colors.transparent,
                        backgroundColor: Colors.transparent,
                      ),
                    ),

                    const SizedBox(
                      height: 50,
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
                                  // Alignment: ListTileTitleAlignment.center,
                                  trailing: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        appointmentDetails[index].isAllDay
                                            ? 'All day'
                                            : DateFormat('hh:mm a').format(
                                                appointmentDetails[index]
                                                    .startTime),
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Text(
                                        appointmentDetails[index].isAllDay
                                            ? ''
                                            : DateFormat('hh:mm a').format(
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
                                  title: Container(
                                      child: Text(
                                          '${appointmentDetails[index].title}',
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white))),
                                ));
                          },
                          separatorBuilder: (BuildContext context, int index) =>
                              const Divider(
                            height: 5,
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

  void selectionChanged(CalendarSelectionDetails calendarSelectionDetails) {
    getSelectedDateAppointments(calendarSelectionDetails.date);
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
        if ((DateTime(appointment.startTime.year, appointment.startTime.month,
                    appointment.startTime.day) ==
                DateTime(
                    selectedDate.year, selectedDate.month, selectedDate.day)) ||
            occurrenceAppointment != null) {
          setState(() {
            appointmentDetails.add(appointment);
          });
        }
      }
    });
  }

  _AppointmentDataSource _getCalendarDataSource() {
    List<Appointment> appointments = <Appointment>[];

    for (var event in _eventsData) {
      //color from value to color
      int colorValue = int.parse(event['tag']);
      Color color = Color(colorValue).withOpacity(1);

      appointments.add(Appointment(
          title: event['title'],
          startTime: event['start_date'].toDate(),
          endTime: event['end_date'].toDate(),
          color: color,
          isAllDay: event['allday'],
          location: event['location']));
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
    this.isAllDay = false,
    this.color = Colors.transparent,
    this.location = '',
    this.people = const [],
  });

  DateTime startTime;
  DateTime endTime;
  String title;
  Color color;
  bool isAllDay;
  String location;
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
}
