import 'package:flutter/material.dart';
import 'package:adrianacarioba/helpers/objects.dart';
import 'package:adrianacarioba/receitasScreens/receitaDetalhe.dart';

final _debouncer = Debouncer(milliseconds: 500);
final TextEditingController _searchTextFieldController =
    TextEditingController();
String searchString = "";
final ScrollController _scrollController = ScrollController();

class ReceitasBuscasScreen extends StatefulWidget {
  static String screenId = "receitasBusca";
  final int fase;

  ReceitasBuscasScreen({@required this.fase});

  @override
  ReceitasBuscasScreenState createState() {
    return ReceitasBuscasScreenState();
  }
}

class ReceitasBuscasScreenState extends State<ReceitasBuscasScreen>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Busca de Receitas',
        ),
      ),
      body: _receitasBuscasScreen(),
    );
  }

  Widget _receitasBuscasScreen() {
    List<Receita> receitas = [];

    for (Receita receita in receitasGlobal) {
      bool foundSomething = false;
      if (receita.nome.toLowerCase().contains(searchString.toLowerCase())) {
        foundSomething = true;
      }
      for (String ingrediente in receita.ingredientes) {
        if (ingrediente.toLowerCase().contains(searchString.toLowerCase())) {
          foundSomething = true;
        }
      }
      if (receita.etapas != null) {
        for (Etapa etapa in receita.etapas) {
          if (etapa.ingredientes != null) {
            for (String ingrediente in etapa.ingredientes) {
              if (ingrediente
                  .toLowerCase()
                  .contains(searchString.toLowerCase())) {
                foundSomething = true;
              }
            }
          }
        }
      }
      if (foundSomething) {
        receitas.add(receita);
      }
    }

    return Column(
      children: [
        _searchBar(),
        Expanded(
          child: ListView.builder(
              controller: _scrollController,
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: receitas.length,
              itemBuilder: (context, index) {
                Receita receita = receitas[index];
                return ListTile(
                  title: Text(receita.nome),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) {
                            return ReceitaDetalheScreen(receita: receita);
                          },
                          settings:
                              RouteSettings(name: 'Receita > ${receita.nome}'),
                        ));
                  },
                );
              }),
        )
      ],
    );
  }

  Widget _searchBar() {
    return Container(
      child: TextField(
        controller: _searchTextFieldController,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.all(15.0),
            hintText: 'Buscar receitas',
            suffixIcon: IconButton(
              icon: Icon(Icons.highlight_off),
              onPressed: () {
                setState(() {
                  searchString = "";
                });
                _searchTextFieldController.clear();
              },
            )),
        onChanged: (string) {
          _debouncer.run(() {
            setState(() {
              searchString = string;
            });
          });
        },
      ),
    );
  }
}
