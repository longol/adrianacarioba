import 'dart:core';
import 'package:flutter/material.dart';
import 'package:adrianacarioba/helpers/objects.dart';

class ReceitaDetalheScreen extends StatefulWidget {
  static String screenId = "receitaDetalhe";
  final Receita receita;

  @override
  ReceitaDetalheScreenState createState() {
    return ReceitaDetalheScreenState();
  }

  ReceitaDetalheScreen({this.receita});
}

class ReceitaDetalheScreenState extends State<ReceitaDetalheScreen> {
  String downloadURL = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(this.widget.receita.nome),
      ),
      body: updateInterface(),
    );
  }

  Widget updateInterface() {
    List<Widget> widgets = [];

    widgets.add(_imageRow());
    widgets.add(_generalInfoRow("Preparo", this.widget.receita.preparo));
    widgets.add(_generalInfoRow("Porção", this.widget.receita.porcao));
    widgets.add(_generalInfoRow("Material", this.widget.receita.material));
    widgets.add(_generalInfoRow("Validade", this.widget.receita.validade));

    if (this.widget.receita.ingredientes.length > 0) {
      widgets.add(_headerRow("INGREDIENTES"));
      widgets.addAll(_bulletList(this.widget.receita.ingredientes));

      widgets.add(_headerRow("MODO DE PREPARO"));
      widgets.addAll(_bulletList(this.widget.receita.modoPreparo));
    } else if (this.widget.receita.etapas.length > 0) {
      widgets.addAll(_etapasReceita());
    }
    widgets.add(
      SizedBox(
        height: 100,
      ),
    );

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: widgets,
        ),
      ),
    );
  }

  Container _imageRow() {
    var imageUrl = "imagesReceitas/";
    imageUrl += this.widget.receita.imageUrl == ""
        ? this.widget.receita.nome + ".png"
        : this.widget.receita.imageUrl;

    return Container(
        child: FutureBuilder(
      future: appData.getImage(context, imageUrl, 200),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done)
          return Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.width * 0.4,
                child: Text(
                  snapshot.data.toString(),
                ),
              )
            ],
          );

        if (snapshot.connectionState == ConnectionState.waiting)
          return Column(
            children: [CircularProgressIndicator()],
          );

        if (snapshot.hasError) {
          return Column(
            children: [
              Text("Sorry an error occured"),
            ],
          );
        }
        return Column();
      },
    ));
  }

  Container _generalInfoRow(String title, String text) {
    final double _width = MediaQuery.of(context).size.width * 0.95;

    return Container(
      width: _width,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2.0),
            child: Text(
              title + ": ",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
                fontSize: 20,
              ),
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container _headerRow(String text) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
            fontSize: 20,
          ),
        ),
      ),
    );
  }

  List<Widget> _bulletList(List<dynamic> list) {
    List<Widget> widgets = [];

    for (String line in list) {
      widgets.add(_bulletRow(line));
    }
    return widgets;
  }

  Container _bulletRow(String text) {
    final _width = MediaQuery.of(context).size.width * 0.95;

    return Container(
      width: _width,
      child: Text(
        "• " + text,
        style: TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: 18,
        ),
      ),
    );
  }

  List<Widget> _etapasReceita() {
    List<Widget> widgets = [];

    int i = 1;
    for (Etapa etapa in this.widget.receita.etapas) {
      widgets.add(_etapaNameRow("Etapa $i: ${etapa.nome}"));
      i++;

      widgets.add(_headerRow("INGREDIENTES"));
      widgets.addAll(_bulletList(etapa.ingredientes));

      widgets.add(_headerRow("MODO DE PREPARO"));
      widgets.addAll(_bulletList(etapa.modoPreparo));
    }
    return widgets;
  }

  Container _etapaNameRow(String text) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Wrap(
          direction: Axis.vertical,
          children: [
            Text(
              text,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            )
          ],
        ),
      ),
    );
  }
}
