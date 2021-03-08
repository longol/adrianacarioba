import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';

import 'package:adrianacarioba/helpers/app_data.dart';
import 'package:adrianacarioba/helpers/objects.dart';
import 'package:adrianacarioba/loginScreens/login.dart';
import 'package:adrianacarioba/loginScreens/registration.dart';
import 'package:adrianacarioba/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(AdrianaCariobaApp());
}

class AdrianaCariobaApp extends StatelessWidget {
  static FirebaseAnalytics analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    AppData();

    return MaterialApp(
      title: "Adriana Carioba",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginScreen(),
      navigatorObservers: [
        appData.getAnalyticsObserver(),
      ],
      routes: {
        LoginScreen.screenId: (context) => LoginScreen(),
        RegistrationScreen.screenId: (context) => RegistrationScreen(),
        App.screenId: (context) => App(),
      },
    );
  }
}
