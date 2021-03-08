import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'app_data.dart';
import 'package:flutter/material.dart';

final appData = AppData();

List receitasGlobal = [];

class RadioValue {
  String title;
  int index;
  bool isSelected = false;

  RadioValue({this.title, this.index, this.isSelected});
}

class CircleTabIndicator extends Decoration {
  final BoxPainter _painter;

  CircleTabIndicator({@required Color color, @required double radius})
      : _painter = _CirclePainter(color, radius);

  @override
  BoxPainter createBoxPainter([onChanged]) => _painter;
}

class _CirclePainter extends BoxPainter {
  final Paint _paint;
  final double radius;

  _CirclePainter(Color color, this.radius)
      : _paint = Paint()
          ..color = color
          ..isAntiAlias = true;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration cfg) {
    final Offset circleOffset =
        offset + Offset(cfg.size.width / 2, cfg.size.height - radius - 5);
    canvas.drawCircle(circleOffset, radius, _paint);
  }
}

class Debouncer {
  final int milliseconds;
  VoidCallback action;
  Timer _timer;

  Debouncer({this.milliseconds});

  run(VoidCallback action) {
    if (null != _timer) {
      _timer.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}

enum CorTabelaAlimento { verde, vermelho, amarelo }

class Receita {
  String id;
  String material;
  List<Etapa> etapas;
  List<dynamic> ingredientes;
  List<dynamic> modoPreparo;
  String nome;
  String porcao;
  String preparo;
  String validade;
  String imageUrl;
  String fase;
  String categoria;

  Receita(
    this.id,
    this.etapas,
    this.ingredientes,
    this.material,
    this.modoPreparo,
    this.nome,
    this.porcao,
    this.preparo,
    this.validade,
    this.imageUrl,
    this.fase,
    this.categoria,
  );

  factory Receita.fromStream(DocumentSnapshot document) {
    List<String> modoPreparo = [];
    List<dynamic> ingredientes = [];
    List<Etapa> etapas = [];
    String imageUrl = "";
    String fase = "";
    String categoria = "";

    if (document.data()["modoPreparo"] != null) {
      List<dynamic> modoPreparoRaw = document["modoPreparo"];
      modoPreparo = modoPreparoRaw.map((e) {
        return e.toString();
      }).toList();
    }

    if (document.data()["ingredientes"] != null) {
      List<dynamic> ingredientesRaw = document["ingredientes"];
      ingredientes = ingredientesRaw.map((e) {
        return e.toString();
      }).toList();
    }

    if (document.data()["etapas"] != null) {
      List<dynamic> etapasRaw = document["etapas"];
      etapas = etapasRaw.map((e) {
        Etapa etapa = Etapa(e["etapa"], e["ingredientes"], e["modoPreparo"]);
        return etapa;
      }).toList();
    }

    if (document.data()["imageUrl"] != null) {
      imageUrl = document.data()["imageUrl"];
    }
    if (document.data()["fase"] != null) {
      fase = document.data()["fase"];
    }
    if (document.data()["categoria"] != null) {
      categoria = document.data()["categoria"];
    }

    return Receita(
      document.data()["itemID"],
      etapas,
      ingredientes,
      document.data()["material"],
      modoPreparo,
      document.data()["nome"],
      document.data()["porcao"],
      document.data()["preparo"],
      document.data()["validade"],
      imageUrl,
      fase,
      categoria,
    );
  }
}

class Etapa {
  String nome;
  List<dynamic> ingredientes;
  List<dynamic> modoPreparo;

  Etapa(this.nome, this.ingredientes, this.modoPreparo);

  factory Etapa.fromJSON(DocumentSnapshot parsedJson) {
    List<String> modoPreparo = [];
    List<String> ingredientes = [];

    if (parsedJson["modoPreparo"] != null) {
      List<dynamic> modoPreparoRaw = parsedJson["modoPreparo"];
      modoPreparo = modoPreparoRaw.map((e) {
        return e.toString();
      }).toList();
    }

    if (parsedJson["ingredientes"] != null) {
      List<dynamic> ingredientesRaw = parsedJson["ingredientes"];
      ingredientes = ingredientesRaw.map((e) {
        return e.toString();
      }).toList();
    }

    return Etapa(parsedJson["etapa"], ingredientes, modoPreparo);
  }
}

enum FasesReceitas {
  fase1,
  fase2,
  pe,
}

List fases = [
  {"nome": groupingNameFor(FasesReceitas.fase1), "fase": FasesReceitas.fase1},
  {"nome": groupingNameFor(FasesReceitas.fase2), "fase": FasesReceitas.fase2},
  {"nome": groupingNameFor(FasesReceitas.pe), "fase": FasesReceitas.pe},
];

String groupingNameFor(FasesReceitas fase) {
  switch (fase) {
    case FasesReceitas.fase1:
      return "Low-carb";
      break;
    case FasesReceitas.fase2:
      return "Low-carb x laticínios";
      break;
    case FasesReceitas.pe:
      return "Proteína " + "| Energia";
      break;
    default:
      return "";
  }
}
