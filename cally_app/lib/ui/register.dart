// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, unused_import, prefer_const_literals_to_create_immutables

import 'package:cally_app/login/footer.dart';
import 'package:cally_app/login/formDiv.dart';
import 'package:cally_app/login/header.dart';
import 'package:flutter/material.dart';
import 'package:cally_app/assets/AppColors.dart';

class Register extends StatelessWidget {
  const Register({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.symmetric(vertical: 100, horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Header(),
              FormDiv(type: "register"),
              Footer(
                type: 'register',
              )
            ],
          ),
        ),
      ),
    );
  }
}
