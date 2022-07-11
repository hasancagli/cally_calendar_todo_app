// ignore_for_file: prefer_const_constructors

import 'package:cally_app/assets/AppColors.dart';
import 'package:flutter/material.dart';

class TitleDialog extends StatelessWidget {
  final String title;

  const TitleDialog({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: 32,
      ),
      child: Row(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            width: 8,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '(Optional)',
              style: TextStyle(fontSize: 12, color: AppColors.grey),
            ),
          ),
        ],
      ),
    );
  }
}
