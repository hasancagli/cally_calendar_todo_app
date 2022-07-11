import 'package:cally_app/assets/AppColors.dart';
import 'package:flutter/material.dart';

void showMessage(
    {required BuildContext context,
    required String text,
    required String type}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(
      text,
      textAlign: TextAlign.center,
    ),
    behavior: SnackBarBehavior.floating,
    backgroundColor:
        type == 'error' ? AppColors.dark_red : AppColors.dark_green,
  ));
}
