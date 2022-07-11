import 'package:flutter/material.dart';

import '../assets/AppColors.dart';

class Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(children: [
      Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'Welcome to',
          style: TextStyle(
            color: AppColors.black,
            fontFamily: 'Inter',
            fontSize: 42,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'Cally',
          style: TextStyle(
            color: AppColors.dark_green,
            fontSize: 42,
            fontWeight: FontWeight.bold,
          ),
        ),
      )
    ]));
  }
}
