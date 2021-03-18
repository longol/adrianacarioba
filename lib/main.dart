import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:adrianacarioba/allTranslations.dart';

import 'package:adrianacarioba/helpers/app_data.dart';
import 'package:adrianacarioba/helpers/objects.dart';
import 'package:adrianacarioba/loginScreens/login.dart';
import 'package:adrianacarioba/loginScreens/registration.dart';
import 'package:adrianacarioba/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await allTranslations.init();
  await appData.setTranslations();

  runApp(AdrianaCariobaApp());
}

class AdrianaCariobaApp extends StatefulWidget {
  @override
  _AdrianaCariobaAppState createState() => _AdrianaCariobaAppState();
}

class _AdrianaCariobaAppState extends State<AdrianaCariobaApp> {
  static FirebaseAnalytics analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);

  @override
  void initState() {
    super.initState();

    AppData();
    allTranslations.onLocaleChangedCallback = _onLocaleChanged;
  }

  _onLocaleChanged() async {
    // do anything you need to do if the language changes
    print('Language has been changed to: ${allTranslations.currentLanguage}');
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
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
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      // Tells the system which are the supported languages
      supportedLocales: allTranslations.supportedLocales(),
    );
  }
}
