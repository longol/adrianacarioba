import 'package:adrianacarioba/helpers/objects.dart';
import 'package:flutter/material.dart';

class TestingScreen extends StatefulWidget {
  static String screenId = "Testing";

  @override
  _TestingScreenState createState() => _TestingScreenState();
}

class _TestingScreenState extends State<TestingScreen> {
  @override
  Widget build(BuildContext context) {
    return updateInterface();
  }

  Widget updateInterface() {
    print(appData.translations);
    return Column(
      children: [
        Text("here"),
      ],
    );
  }
}
