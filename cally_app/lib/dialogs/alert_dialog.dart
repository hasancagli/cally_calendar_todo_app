// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables, sort_child_properties_last, avoid_print, prefer_final_fields, avoid_init_to_null, non_constant_identifier_names, unused_local_variable, unnecessary_null_comparison

import 'package:cally_app/assets/AppColors.dart';
import 'package:cally_app/net/Event.dart';
import 'package:cally_app/assets/show_message.dart';
import 'package:cally_app/ui/home_view.dart';
import 'package:cally_app/texts/title_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';

import 'dart:math';

class AlertDialogClass extends StatefulWidget {
  final String weekday;
  final int day;
  final int month;
  final int year;
  Function callback;
  final DateTime date;

  AlertDialogClass(
      {Key? key,
      required this.weekday,
      required this.day,
      required this.month,
      required this.year,
      required this.callback,
      required this.date})
      : super(key: key);

  @override
  State<AlertDialogClass> createState() => _AlertDialogClassState();
}

class _AlertDialogClassState extends State<AlertDialogClass> {
  final FirebaseAuth auth = FirebaseAuth.instance;

  TextEditingController _eventController =
      TextEditingController(); // to control title of event input field
  TextEditingController _newTagController =
      TextEditingController(text: "#"); // to control add new tag input field

  List<String> tags = [];

  List<String> emojis = [
    "emoji_1.png",
    "emoji_2.png",
    "emoji_3.png",
    "emoji_4.png",
    "emoji_5.png",
    "emoji_6.png",
    "emoji_7.png",
    "emoji_8.png",
    "emoji_9.png",
    "emoji_10.png",
    "emoji_11.png",
    "emoji_12.png",
  ];

  var months = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December"
  ];

  bool _isShow = false; // show add new tag container or not.
  bool _showTimePick = false; // show time interval pick container or not.

  String _choosenEmoji = "";
  List<String> _choosenTags = [];

  // Set start and end time as null at the beginning.
  var start_time = null;
  var end_time = null;

  Random random = Random();

  // When dialog shows up, get tags from database and show them
  void getTagsFromDatabase() async {
    var document = await FirebaseFirestore.instance
        .collection('users')
        .doc(auth.currentUser?.uid)
        .collection('tags')
        .doc('all_tags');
    document.get().then((value) {
      if (value.data() != null) {
        setState(() {
          tags = value.data()?['tags'].cast<String>();
        });
      }
    });
  }

  // Trigger this function to Add New Tag to Database
  Future addNewTag(String newTag) async {
    var document = await FirebaseFirestore.instance
        .collection('users')
        .doc(auth.currentUser?.uid)
        .collection('tags')
        .doc('all_tags');

    var prev_tags = document.get().then((value) {
      if (value.data() == null) {
        List array = [newTag];
        document.set({'tags': array});
        return;
      } else {
        List data = value.data()?['tags'];
        data.add(newTag);
        document.update({'tags': data});
        return;
      }
    });
  }

  // Delete tag from users database.
  Future deleteTag(String tag) async {
    var document = await FirebaseFirestore.instance
        .collection('users')
        .doc(auth.currentUser?.uid)
        .collection('tags')
        .doc('all_tags');

    var prev_tags = document.get().then((value) {
      if (value.data() == null) {
        return;
      } else {
        List data = value.data()?['tags'];
        data.remove(tag);
        document.update({'tags': data});
        setState(() {
          tags = data.cast<String>();
        });
        return;
      }
    });
  }

  // When dialog shows up, run getTagsFromDatabase()
  @override
  void initState() {
    getTagsFromDatabase();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: AlertDialog(
        title: RichText(
          text: TextSpan(
            text: 'Create New To Do',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              height: 1.5,
              color: Colors.black,
            ),
            children: <TextSpan>[
              TextSpan(
                text:
                    '\n${widget.day} ${months[widget.month - 1]} ${widget.year} - ${widget.weekday}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: AppColors.blue,
                ),
              ),
            ],
          ),
        ),
        content: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 1,
            ),

            // ENTER TITLE OF THE EVENT
            TextFormField(
              controller: _eventController,
              decoration: InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Title (*)',
              ),
            ),

            // CHOOSE TAGS TITLE
            TitleDialog(title: 'Choose Tags'),

            // LIST OF PREVIOUS TAGS
            Align(
              alignment: Alignment.topLeft,
              child: Wrap(
                  children: tags.map((String tag) {
                return GestureDetector(
                  onLongPress: () {
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              title: Text(
                                'Delete Tag',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              content: Text(
                                'Are you sure you want to delete this tag?',
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
                                    if (_choosenTags.contains(tag)) {
                                      setState(() {
                                        _choosenTags.remove(tag);
                                      });
                                      Navigator.pop(context);
                                      return;
                                    }
                                    await deleteTag(tag);
                                    setState(() {
                                      tags.remove(tag);
                                    });
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    'Delete',
                                    style: TextStyle(color: AppColors.dark_red),
                                  ),
                                ),
                              ],
                            ));
                  },
                  onTap: () {
                    if (_choosenTags.contains(tag)) {
                      setState(() {
                        _choosenTags.remove(tag);
                      });
                      return;
                    }

                    if (_choosenTags.length < 3) {
                      setState(() {
                        _choosenTags.add(tag);
                      });
                      return;
                    }
                    showMessage(
                        context: context,
                        text: "You can't choose more than 3 tags.",
                        type: 'error');
                  },
                  child: Container(
                    margin: EdgeInsets.only(right: 8, top: 8),
                    child: Text(
                      tag,
                      style: TextStyle(
                        color: (_choosenTags.contains(tag))
                            ? Colors.white
                            : Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    padding: EdgeInsets.symmetric(
                      vertical: 6,
                      horizontal: 12,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.black),
                      color: (_choosenTags.contains(tag))
                          ? Colors.black
                          : Colors.white,
                    ),
                  ),
                );
              }).toList()),
            ),

            // ADD TAG
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                margin: EdgeInsets.only(top: 12),
                child: OutlinedButton.icon(
                  // <-- OutlinedButton
                  onPressed: () {
                    setState(() {
                      _isShow = !_isShow;
                    });
                    print(_isShow);
                  },
                  label: Text(
                    'New Tag',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  icon: Icon(
                    Icons.add,
                    size: 24.0,
                  ),
                ),
              ),
            ),

            // ADD NEW TAG INPUT FIELD
            (_isShow)
                ? Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.5,
                            child: TextFormField(
                              inputFormatters: [
                                new LengthLimitingTextInputFormatter(26),
                              ],
                              controller: _newTagController,
                              decoration: InputDecoration(
                                border: UnderlineInputBorder(),
                                labelText: 'Tag',
                                labelStyle: TextStyle(fontSize: 14),
                                hintStyle: TextStyle(fontSize: 14),
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.add,
                            ),
                            iconSize: 30,
                            color: Colors.black,
                            splashRadius: 15,
                            onPressed: () {
                              String inputText = _newTagController.text;
                              setState(() {
                                if (_newTagController.text[0] != '#') {
                                  inputText = "#$inputText";
                                }
                                tags.add(inputText);
                                _newTagController.text = "#";

                                addNewTag(inputText);
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  )
                : SizedBox(
                    height: 1,
                  ),

            // TIME INTERVAL PICKER
            TitleDialog(title: 'Add Time Interval'),

            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                margin: EdgeInsets.only(
                  top: 12,
                ),
                child: OutlinedButton.icon(
                  // <-- OutlinedButton
                  onPressed: () {
                    setState(() {
                      _showTimePick = !_showTimePick;
                      if (!_showTimePick) {
                        start_time = null;
                        end_time = null;
                      }
                    });
                  },
                  label: Text(
                    'Add Time Interval',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  icon: Icon(
                    Icons.add,
                    size: 24.0,
                  ),
                ),
              ),
            ),

            // ADD TIME INTERVAL
            Container(
              margin: EdgeInsets.only(
                top: 12,
              ),
              child: (_showTimePick)
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          flex: 2,
                          fit: FlexFit.tight,
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Start',
                                  style: TextStyle(
                                    color: AppColors.orange,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: OutlinedButton.icon(
                                  // <-- OutlinedButton
                                  onPressed: () async {
                                    TimeOfDay? newStartTime =
                                        await showTimePicker(
                                      context: context,
                                      initialTime:
                                          TimeOfDay(hour: 0, minute: 0),
                                    );

                                    if (newStartTime == null) return;
                                    setState(() {
                                      start_time = newStartTime;
                                    });
                                  },
                                  label: Text(
                                    'Start Time',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                  icon: Icon(
                                    Icons.add,
                                    size: 24.0,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 12,
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  (start_time != null)
                                      ? '${start_time.format(context)}'
                                      : '',
                                  style: TextStyle(
                                    color: AppColors.dark_red,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Flexible(
                          flex: 2,
                          fit: FlexFit.tight,
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Finish',
                                  style: TextStyle(
                                    color: AppColors.orange,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: OutlinedButton.icon(
                                  // <-- OutlinedButton
                                  onPressed: () async {
                                    TimeOfDay? newEndTime =
                                        await showTimePicker(
                                            context: context,
                                            initialTime:
                                                TimeOfDay(hour: 0, minute: 0));

                                    if (newEndTime == null) return;
                                    setState(() {
                                      end_time = newEndTime;
                                    });
                                  },
                                  label: Text(
                                    'End Time',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                  icon: Icon(
                                    Icons.add,
                                    size: 24.0,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 12,
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  (end_time != null)
                                      ? '${end_time.format(context)}'
                                      : '',
                                  style: TextStyle(
                                    color: AppColors.dark_red,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  : SizedBox(
                      height: 1,
                    ),
            ),

            // CHOOSE EMOJI
            TitleDialog(title: 'Choose Emoji'),

            Align(
              alignment: Alignment.topLeft,
              child: Wrap(
                children: emojis.map((String emoji) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _choosenEmoji = emoji;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.all(2),
                      margin: EdgeInsets.only(
                        right: 18,
                        bottom: 8,
                        top: 8,
                      ),
                      decoration: (emoji == _choosenEmoji)
                          ? BoxDecoration(
                              border: Border.all(
                                color: AppColors.blue,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(5),
                            )
                          : BoxDecoration(),
                      child: Image(
                        width: 45,
                        height: 45,
                        image: AssetImage('assets/${emoji}'),
                      ),
                    ),
                  );
                }).toList(),
              ),
            )
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              var title_event = _eventController.text;
              var tags_event = _choosenTags;
              var startTime_event =
                  (start_time != null) ? start_time.format(context) : '';
              var endTime_event =
                  (end_time != null) ? end_time.format(context) : '';
              var emoji_event = _choosenEmoji;

              var date =
                  "${widget.day}_${widget.month}_${widget.year}_${widget.weekday}";

              var randomNum = random.nextInt(AppColors.eventColors.length);
              var color = AppColors.eventColors[randomNum];

              Event event = Event(
                title: title_event,
                tags: tags_event,
                startTime: startTime_event,
                endTime: endTime_event,
                emoji: emoji_event,
                done: false,
                color: color,
                date: date,
              );

              createEvent(event: event);
            },
            child: Text('Add'),
          ),
        ],
      ),
    );
  }

  // Create event with given inputs from the user.
  Future createEvent({required Event event}) async {
    final docUser = FirebaseFirestore.instance
        .collection('users')
        .doc(auth.currentUser?.uid.toString())
        .collection('dates')
        .doc(event.date)
        .collection('events');

    final element = {
      'title': event.title,
      'tags': event.tags,
      'startTime': event.startTime,
      'endTime': event.endTime,
      'emoji': event.emoji,
      'done': event.done,
      'color': [
        event.color.red,
        event.color.green,
        event.color.blue,
        event.color.opacity
      ],
      'date': event.date
    };

    if (event.title.length <= 1) {
      showMessage(
          context: context, text: "Please enter the title.", type: "error");
      return;
    } else {
      await docUser.add(element);
      Navigator.of(context).pop();
      widget.callback(widget.date);
      return;
    }
  }
}
