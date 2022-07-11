// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'package:cally_app/assets/AppColors.dart';
import 'package:cally_app/assets/show_message.dart';
import 'package:cally_app/texts/title_dialog.dart';
import 'package:cally_app/texts/title_settings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: 42,
            horizontal: 22,
          ),
          child: Column(
            children: [
              // BACK TO HOME BUTTON
              GestureDetector(
                onTap: () => Navigator.pushReplacementNamed(context, '/home'),
                child: Container(
                  child: Row(
                    children: [
                      Icon(
                        Icons.chevron_left,
                        size: 28,
                      ),
                      Text(
                        'Back to Home',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),

              // ACCOUNT EMAIL
              TitleSettings(title: 'Account Email'),
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'usercalendar@gmail.com',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.grey,
                  ),
                ),
              ),

              // SIGN OUT
              TitleSettings(title: 'Sign Out'),
              Align(
                alignment: Alignment.topLeft,
                child: RichText(
                  text: TextSpan(
                    text: 'Click Here ',
                    recognizer: new TapGestureRecognizer()
                      ..onTap = () async {
                        await FirebaseAuth.instance.signOut();
                        Navigator.pushReplacementNamed(context, '/login');
                      },
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.5,
                      fontWeight: FontWeight.bold,
                      color: AppColors.blue,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'to sign out from this device.',
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 16,
                          color: AppColors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // DELETE USER'S ACCOUNT
              TitleSettings(title: 'Delete Account'),
              Align(
                alignment: Alignment.topLeft,
                child: RichText(
                  text: TextSpan(
                    text: 'Click Here ',
                    recognizer: new TapGestureRecognizer()
                      ..onTap = () async {
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                  title: Text(
                                    'Delete Account',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  content: Text(
                                    'Are you sure you want to delete your account?',
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
                                        await FirebaseAuth.instance.currentUser
                                            ?.delete()
                                            .then((value) {
                                          Navigator.pushReplacementNamed(
                                              context, '/login');
                                          showMessage(
                                              context: context,
                                              text:
                                                  "Account deleted successfully.",
                                              type: 'success');
                                        }).onError((error, stackTrace) {
                                          print(error);
                                        });
                                      },
                                      child: Text(
                                        'Delete',
                                        style: TextStyle(
                                            color: AppColors.dark_red),
                                      ),
                                    ),
                                  ],
                                ));
                      },
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.5,
                      fontWeight: FontWeight.bold,
                      color: AppColors.blue,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text:
                            'to verify that you want to delete your account and all existing data.',
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 16,
                          color: AppColors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Container(
                margin: EdgeInsets.symmetric(
                  vertical: 24,
                ),
                decoration: BoxDecoration(color: AppColors.grey),
                height: 0.5,
              ),

              TitleSettings(title: 'Developer'),
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Hasan Cagli',
                  style: TextStyle(
                    color: AppColors.grey,
                    fontSize: 16,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
