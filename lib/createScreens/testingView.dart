import 'package:adrianacarioba/helpers/objects.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TestingScreen extends StatefulWidget {
  static String screenId = "Testing";

  @override
  _TestingScreenState createState() => _TestingScreenState();
}

class _TestingScreenState extends State<TestingScreen> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Future<List> translations;
  TranslationMap translationMap;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
      switch (snapshot.connectionState) {
        case ConnectionState.waiting:
          return const CircularProgressIndicator();
        default:
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return Text('Here');
          }
      }
    });
  }

  Future<void> startSharedPreference() async {
    SharedPreferences prefs = await _prefs;
    String lang = prefs.getString('language');
    setState(() {
      if (lang == 'en') {
        translations = translationMap.translationsEn;
      }
      if (lang == 'pt') {
        translations = translationMap.translationsPt;
      }
    });
  }

  Widget updateInterface() {
    if (translations == null) {
      startSharedPreference();
      return Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('translations').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return Container(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          translationMap = TranslationMap.fromStream(snapshot.data.docs);
          return Column(
            children: [
              Text("here"),
            ],
          );
        }
      },
    );
  }
}
