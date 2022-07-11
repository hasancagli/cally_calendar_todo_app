// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class TitleSettings extends StatelessWidget {
  final String title;

  const TitleSettings({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: 24,
      ),
      child: Align(
        alignment: Alignment.topLeft,
        child: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
