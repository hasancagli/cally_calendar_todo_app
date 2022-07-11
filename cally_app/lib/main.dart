// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors

import 'package:cally_app/ui/home_view.dart';
import 'package:cally_app/ui/register.dart';
import 'package:cally_app/ui/settings.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'ui/authentication.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cally',
      home: Authentication(),
      theme: ThemeData(fontFamily: 'Inter'),
      initialRoute: '/',
      routes: {
        '/login': (context) => Authentication(),
        '/register': (context) => Register(),
        '/home': (context) => HomeView(),
        '/settings': (context) => Settings()
      },
    );
  }
}
