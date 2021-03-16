import 'package:adrianacarioba/helpers/objects.dart';
import 'package:adrianacarioba/receitasScreens/receitaDetalhe.dart';
import 'package:flutter/material.dart';

class ReceitasCategoriaScreen extends StatefulWidget {
  static String screenId = "receitas";
  final List receitas;
  final String categoria;

  @override
  _ReceitasCategoriaScreenState createState() =>
      _ReceitasCategoriaScreenState();

  ReceitasCategoriaScreen({this.receitas, this.categoria});
}

class _ReceitasCategoriaScreenState extends State<ReceitasCategoriaScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(this.widget.categoria),
      ),
      body: updateInterface(),
    );
  }

  Widget updateInterface() {
    return Column(
      children: [
        _receitasListView(),
        _infoBar(),
      ],
    );
  }

  Widget _infoBar() {
    return Container(
      width: double.infinity,
      height: 50.0,
      color: Colors.grey.shade200,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          this.widget.receitas.length.toString() +
              " receitas \"" +
              this.widget.categoria +
              "\"",
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _receitasListView() {
    return Expanded(
      child: ListView(
        children: this.widget.receitas.map((document) {
          Receita receita = Receita.fromStream(document);
          return _receitasListCell(receita);
        }).toList(),
      ),
    );
  }

  Widget _receitasListCell(Receita receita) {
    var imageUrl = "imagesReceitas/";
    imageUrl +=
        receita.imageUrl == "" ? receita.nome + ".png" : receita.imageUrl;

    return FutureBuilder(
      future: appData.getImage(context, imageUrl, 50),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return ListTile(
            title: Text(receita.nome),
            leading: Container(
              width: 50.0,
              height: 50.0,
              child: Text(snapshot.data.toString()),
            ),
            // trailing: Text(receita.id),
            trailing: Icon(
              Icons.arrow_right_rounded,
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ReceitaDetalheScreen(
                    receita: receita,
                  ),
                ),
              );
            },
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting ||
            snapshot.connectionState == ConnectionState.active) {
          return ListTile(
            title: Text("Carregando..."),
            leading: Container(
              width: 20.0,
              height: 20.0,
              child: Container(
                height: 30,
                child: CircularProgressIndicator(),
              ),
            ),
          );
        }
        return Text("Sorry an error occured");
      },
    );
  }
}
