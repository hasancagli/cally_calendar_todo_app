// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class Footer extends StatelessWidget {
  final String type; // "register" or "login"

  const Footer({Key? key, required this.type}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        child: Row(
          children: [
            Container(
              margin: EdgeInsets.only(right: 16),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  type == "login"
                      ? "Don't you have an account?"
                      : "Do you have an account already?",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: TextButton(
                style: TextButton.styleFrom(
                  textStyle: const TextStyle(fontSize: 16),
                ),
                onPressed: () {
                  if (type == "login") {
                    Navigator.pushReplacementNamed(context, '/register');
                  } else {
                    Navigator.pushReplacementNamed(context, '/login');
                  }
                },
                child: Text(type == "login" ? "Register." : "Login."),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
