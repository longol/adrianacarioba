import 'package:adrianacarioba/helpers/objects.dart';
import 'package:adrianacarioba/receitasScreens/receitasCategoria.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

List categorias = [];
List receitas = [];

class CategoriasReceitasScreen extends StatefulWidget {
  static String screenId = "categorias";
  final FasesReceitas faseCurrent;

  @override
  _CategoriasReceitasScreenState createState() =>
      _CategoriasReceitasScreenState();

  CategoriasReceitasScreen({this.faseCurrent});
}

class _CategoriasReceitasScreenState extends State<CategoriasReceitasScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(groupingNameFor(this.widget.faseCurrent)),
      ),
      body: updateInterface(),
    );
  }

  Widget updateInterface() {
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection('receitas').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else {
            receitasGlobal = snapshot.data.docs;
            switch (this.widget.faseCurrent) {
              case FasesReceitas.fase1:
                receitas = _receitasFilterByFase("1");
                break;
              case FasesReceitas.fase2:
                receitas = _receitasFilterByFase("2");
                break;
              default:
                receitas = _receitasSortedByName(receitas);
            }

            categorias = _receitasGetCategories(receitas);

            // _fixCategorias();
            // _fixImageUrl(["191", "188", "185", "187"]);
            // _fixNamesWithExtraSpace();
            // _addFields();

            return Column(
              children: [
                _categoriasListView(),
                _infoBar(),
              ],
            );
          }
        });
  }

  Widget _categoriasListView() {
    return Expanded(
      child: ListView(
        children: categorias.map((categoria) {
          return _categoriaListCell(categoria);
        }).toList(),
      ),
    );
  }

  Widget _categoriaListCell(categoria) {
    List receitasCategoria = _filteredReceitasByCategoria(categoria, receitas);
    receitasCategoria = _receitasSortedByName(receitasCategoria);

    return ListTile(
      title: Text(categoria),
      leading: Container(
        width: 50.0,
        height: 50.0,
        child: Image.asset("images/logoFue.png"),
      ),
      trailing: Icon(
        Icons.arrow_right_alt_rounded,
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ReceitasCategoriaScreen(
              receitas: receitasCategoria,
              categoria: categoria,
            ),
          ),
        );
      },
    );
  }

  List _receitasGetCategories(List receitas) {
    List categorias = [];
    receitas.forEach((element) {
      Receita receita = Receita.fromStream(element);
      if (categorias.contains(receita.categoria) == false) {
        categorias.add(receita.categoria);
      }
    });
    categorias.sort((a, b) => a.compareTo(b));
    return categorias;
  }

  Widget _infoBar() {
    return Container(
      width: double.infinity,
      height: 50.0,
      color: Colors.grey.shade200,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          receitasGlobal.length.toString() +
              " receitas \"" +
              groupingNameFor(this.widget.faseCurrent) +
              "\"",
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  List _receitasFilterByFase(String fase) {
    List receitasFiltered = receitasGlobal.where((a) {
      Receita receita = Receita.fromStream(a);
      return fase == receita.fase;
    }).toList();
    return receitasFiltered;
  }

  List _filteredReceitasByCategoria(String categoria, List receitas) {
    List receitasFiltered = receitas.where((a) {
      Receita receita = Receita.fromStream(a);
      return categoria == receita.categoria;
    }).toList();
    receitasFiltered = _receitasSortedByName(receitasFiltered);

    return receitasFiltered;
  }

  List _receitasSortedByName(List receitas) {
    receitas.sort((a, b) {
      Receita receitaA = Receita.fromStream(a);
      Receita receitaB = Receita.fromStream(b);
      return receitaA.nome.compareTo(receitaB.nome);
    });

    return receitas;
  }
}
