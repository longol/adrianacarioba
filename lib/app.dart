import 'package:adrianacarioba/createScreens/criarReceita.dart';
import 'package:adrianacarioba/createScreens/testingView.dart';
import 'package:adrianacarioba/receitasScreens/fasesReceitas.dart';
import 'package:flutter/material.dart';

class App extends StatefulWidget {
  static String screenId = "app";
  @override
  State<StatefulWidget> createState() => AppState();
}

class AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(icon: Icon(Icons.create)),
                Tab(icon: Icon(Icons.local_restaurant)),
                Tab(icon: Icon(Icons.local_hotel)),
              ],
            ),
            title: Text('Adriana Carioba'),
          ),
          body: TabBarView(
            children: [
              CriarReceitaScreen(),
              FasesReceitasScreen(),
              TestingScreen(),
            ],
          ),
        ),
      ),
    );
  }
}
