import 'package:adrianacarioba/helpers/objects.dart';
import 'package:adrianacarioba/receitasScreens/categoriasReceitas.dart';
import 'package:flutter/material.dart';

class FasesReceitasScreen extends StatefulWidget {
  static String screenId = "fases";

  @override
  _FasesReceitasScreenState createState() => _FasesReceitasScreenState();
}

class _FasesReceitasScreenState extends State<FasesReceitasScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView(
        children: fases.map((fase) {
          return _fasesListCell(fase);
        }).toList(),
      ),
    );
  }

  Widget _fasesListCell(fase) {
    return ListTile(
      title: Text(fase["nome"]),
      leading: Container(
        width: 50.0,
        height: 50.0,
        child: Image.asset("images/logoFue.png"),
      ),
      trailing: Icon(
        Icons.arrow_right_rounded,
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CategoriasReceitasScreen(
              faseCurrent: fase["fase"],
            ),
          ),
        );
      },
    );
  }
}
