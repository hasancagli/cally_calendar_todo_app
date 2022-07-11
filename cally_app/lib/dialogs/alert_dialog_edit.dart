// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables, sort_child_properties_last, avoid_print, prefer_final_fields, avoid_init_to_null, non_constant_identifier_names, unused_local_variable, unnecessary_null_comparison, unrelated_type_equality_checks

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

import 'dart:math';

class AlertDialogEditClass extends StatefulWidget {
  final String weekday;
  final int day;
  final int month;
  final int year;
  Function callback;
  final DateTime date;

  final String title;
  final String emoji;
  final String id;

  AlertDialogEditClass(
      {Key? key,
      required this.weekday,
      required this.day,
      required this.month,
      required this.year,
      required this.callback,
      required this.date,
      required this.title,
      required this.emoji,
      required this.id})
      : super(key: key);

  @override
  State<AlertDialogEditClass> createState() => _AlertDialogEditClassState();
}

class _AlertDialogEditClassState extends State<AlertDialogEditClass> {
  final FirebaseAuth auth = FirebaseAuth.instance;

  TextEditingController _eventController = TextEditingController();
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

  bool _isShow = false;
  bool _showTimePick = false;

  String _choosenEmoji = "";
  List<String> _choosenTags = [];

  var start_time = null;
  var end_time = null;

  Random random = Random();

  @override
  void initState() {
    // UPDATING EVERY FIELD ACCORDING TO EVENT VARIABLES

    // Set Title
    _eventController.text = widget.title;
    // Set Emoji
    _choosenEmoji = widget.emoji;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: AlertDialog(
        title: RichText(
          text: TextSpan(
            text: 'Edit Event',
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

              var updateElement = {
                'title': title_event,
                'emoji': emoji_event,
                'date': date
              };
              createEvent(event: updateElement);
            },
            child: Text('Update'),
          ),
        ],
      ),
    );
  }

  Future createEvent({required Map event}) async {
    final docUser = FirebaseFirestore.instance
        .collection('users')
        .doc(auth.currentUser?.uid)
        .collection('dates')
        .doc(event['date'])
        .collection('events')
        .doc(widget.id);

    final element = {
      'title': event['title'],
      'emoji': event['emoji'],
    };

    if (event['title'].length <= 1) {
      showMessage(
          context: context, text: "Please enter the title.", type: "error");
      return;
    } else {
      await docUser.update(element);
      showMessage(
          context: context, text: 'Updated successfully!', type: 'success');
      Navigator.of(context).pop();
      widget.callback(widget.date);
      return;
    }
  }
}
