// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last

import 'package:cally_app/assets/AppColors.dart';
import 'package:cally_app/net/Event.dart';
import 'package:cally_app/assets/show_message.dart';
import 'package:cally_app/dialogs/alert_dialog.dart';
import 'package:cally_app/dialogs/alert_dialog_edit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class HomeView extends StatefulWidget {
  HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final FirebaseAuth auth = FirebaseAuth.instance;

  Map<DateTime, List<Event>> selectedEvents = {};
  CalendarFormat format = CalendarFormat.month;
  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();

  var days = [
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday"
  ];

  List<Event> _getEventsFromDay(DateTime date) {
    return selectedEvents[date] ?? [];
  }

  TextEditingController _eventController = TextEditingController();
  TextEditingController _newTagController = TextEditingController();

  bool _isShow = false;

  List events = [];

  bool _isLoading = false;

  // Gets events of selected day on calendar.
  void getEvents(DateTime date) async {
    setState(() {
      events = [];
      _isLoading = true;
    });
    var dateString =
        "${date.day}_${date.month}_${date.year}_${days[date.weekday - 1]}";

    var eventDocs = [];
    var document = await FirebaseFirestore.instance
        .collection('users')
        .doc(auth.currentUser?.uid)
        .collection('dates')
        .doc(dateString)
        .collection('events');
    document.get().then((value) {
      print(value.docs.map((e) {
        var object = e.data();
        if (object['startTime'] != '') {
          object['tags'].add("${object['startTime']} - ${object['endTime']}");
        }
        object['id'] = e.id.toString();
        eventDocs.add(object);
      }));
    }).then((value) {
      setState(() {
        events = eventDocs;
        _isLoading = false;
      });
    });
  }

  @override
  void initState() {
    // When page shows up, run "getEvents" function.
    getEvents(selectedDay);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // APP BAR OF THE PAGE
      appBar: AppBar(
        title: Text('Cally'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          // SETTINGS BUTTON
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () =>
                Navigator.pushReplacementNamed(context, '/settings'),
            padding: EdgeInsets.symmetric(horizontal: 14),
            splashRadius: 15,
          ),

          // ADD EVENT BUTTON
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              var weekday = days[selectedDay.weekday - 1];
              var day = selectedDay.day;
              var month = selectedDay.month;
              var year = selectedDay.year;

              // SHOW ALERT DIALOG WHEN ADD BUTTON CLICKED.
              showDialog(
                context: context,
                builder: (context) => AlertDialogClass(
                    weekday: weekday,
                    day: day,
                    month: month,
                    year: year,
                    callback: getEvents,
                    date: selectedDay),
              );
            },
            padding: EdgeInsets.symmetric(horizontal: 14),
            splashRadius: 15,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // CALENDAR VIEW
            TableCalendar(
              focusedDay: selectedDay,
              firstDay: DateTime(1990),
              lastDay: DateTime(2100),
              calendarFormat: format,
              onFormatChanged: (CalendarFormat _format) {
                setState(() {
                  format = _format;
                });
              },
              startingDayOfWeek: StartingDayOfWeek.monday,
              daysOfWeekVisible: true,
              // Day changed
              onDaySelected: (DateTime selectDay, DateTime focusDay) {
                setState(() {
                  selectedDay = selectDay;
                  focusedDay = focusDay;
                });
                getEvents(selectedDay);
              },
              selectedDayPredicate: (DateTime date) {
                return isSameDay(selectedDay, date);
              },

              eventLoader: _getEventsFromDay,

              // To style the Calendar
              calendarStyle: CalendarStyle(
                  isTodayHighlighted: true,
                  defaultDecoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  weekendDecoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  selectedDecoration: BoxDecoration(
                    color: AppColors.dark_red,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  selectedTextStyle: TextStyle(
                    color: Colors.white,
                  ),
                  todayDecoration: BoxDecoration(
                    color: AppColors.dark_green,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  outsideDecoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(5),
                  )),
              headerStyle: HeaderStyle(
                  formatButtonVisible: true,
                  titleCentered: true,
                  formatButtonShowsNext: false,
                  formatButtonDecoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(5)),
                  formatButtonTextStyle: TextStyle(color: Colors.white)),
            ),
            Center(
              child: (_isLoading)
                  ? CircularProgressIndicator()
                  : SizedBox(
                      height: 1,
                    ),
            ),
            Column(
              children: events.map((e) {
                return GestureDetector(
                  onDoubleTap: () {
                    var weekday = days[selectedDay.weekday - 1];
                    var day = selectedDay.day;
                    var month = selectedDay.month;
                    var year = selectedDay.year;

                    // SHOW ALERT DIALOG WHEN ADD BUTTON CLICKED.
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialogEditClass(
                        weekday: weekday,
                        day: day,
                        month: month,
                        year: year,
                        callback: getEvents,
                        date: selectedDay,
                        title: e['title'],
                        emoji: e['emoji'],
                        id: e['id'],
                      ),
                    );
                  },
                  // TO DELETE THIS EVENT
                  onLongPress: () {
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              title: Text(
                                'Delete Event',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              content: Text(
                                'Are you sure you want to delete this event?',
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    var document = await FirebaseFirestore
                                        .instance
                                        .collection('users')
                                        .doc(auth.currentUser?.uid)
                                        .collection('dates')
                                        .doc(e['date'])
                                        .collection('events')
                                        .doc(e['id']);
                                    document.delete().then((value) {
                                      setState(() {
                                        events.remove(e);
                                      });
                                      Navigator.of(context).pop();
                                    });
                                  },
                                  child: Text(
                                    'Delete',
                                    style: TextStyle(color: AppColors.dark_red),
                                  ),
                                ),
                              ],
                            ));
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 16,
                    ),
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(e['color'][0], e['color'][1],
                          e['color'][2], e['color'][3]),
                      borderRadius: BorderRadius.circular(
                        12,
                      ),
                    ),
                    padding: EdgeInsets.all(
                      12,
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            child: Row(
                              children: [
                                // FIRST COLUMN OF CARD
                                Container(
                                  margin: EdgeInsets.only(
                                    right: 16,
                                  ),
                                  child: (e["emoji"] != "")
                                      ? Image(
                                          width: 45,
                                          height: 45,
                                          image: AssetImage(
                                              'assets/${e["emoji"]}'),
                                        )
                                      : SizedBox(
                                          width: 1,
                                        ),
                                ),

                                // SECOND COLUMN OF CARD
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.6,
                                      child: Text(
                                        e['title'],
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.6,
                                      child: Wrap(
                                        children: e['tags'].map<Widget>((tag) {
                                          return Container(
                                            margin: EdgeInsets.only(
                                              right: 6,
                                              top: 6,
                                            ),
                                            padding: EdgeInsets.symmetric(
                                              vertical: 4,
                                              horizontal: 8,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            child: Text(
                                              tag,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Color.fromRGBO(
                                                    e['color'][0],
                                                    e['color'][1],
                                                    e['color'][2],
                                                    e['color'][3]),
                                                fontSize: 12,
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),

                          // CHECKBOX
                          Checkbox(
                            value: e['done'],
                            onChanged: (value) async {
                              var valueOppo = !e['done'];
                              var document = await FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(auth.currentUser?.uid)
                                  .collection('dates')
                                  .doc(e['date'])
                                  .collection('events')
                                  .doc(e['id']);

                              setState(() {
                                e['done'] = valueOppo;
                              });

                              document
                                  .update({'done': valueOppo})
                                  .then((value) {})
                                  .onError((error, stackTrace) {
                                    showMessage(
                                        context: context,
                                        text:
                                            "An error happened. Please try again later.",
                                        type: "error");
                                  });
                            },
                            activeColor: Colors.blue, // background color
                            checkColor: Colors.white, // tick color
                            splashRadius: 0,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
