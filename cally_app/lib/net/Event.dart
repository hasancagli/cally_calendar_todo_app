import 'package:flutter/material.dart';

// TO CREATE EVENT OBJECTS

class Event {
  final String title;
  final List tags;
  final String startTime;
  final String endTime;
  final String emoji;
  final bool done;
  final Color color;
  final String date;

  Event(
      {required this.title,
      required this.tags,
      required this.startTime,
      required this.endTime,
      required this.emoji,
      required this.done,
      required this.color,
      required this.date});
}
