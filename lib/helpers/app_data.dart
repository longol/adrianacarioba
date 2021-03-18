import 'package:adrianacarioba/allTranslations.dart';
import 'package:flutter/material.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:adrianacarioba/helpers/objects.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AppData {
  static final AppData _appData = new AppData._internal();
  Map translations = {};

  AppData._internal();

  factory AppData() {
    return _appData;
  }

  final FirebaseAnalytics _analytics = FirebaseAnalytics();

  FirebaseAnalyticsObserver getAnalyticsObserver() =>
      FirebaseAnalyticsObserver(analytics: _analytics);
  Future setUserProperties({String userId}) async {
    await _analytics.setUserId(userId);
  }

  Future setTranslations() {
    String language = allTranslations.currentLanguage;

    FirebaseFirestore.instance.collection('translations').get().then((value) {
      TranslationMap translationMap = TranslationMap.fromStream(value.docs);
      if (language == "pt") {
        translations = translationMap.translationsPt;
      }
      if (language == "en") {
        translations = translationMap.translationsEn;
      }
      return true;
    });
  }

  Future<Widget> getImage(
      BuildContext context, String imageUrl, double imageHeight) async {
    final ref = firebase_storage.FirebaseStorage.instance.ref();
    final child = ref.child(imageUrl);
    imageHeight = imageHeight * 1.0;
    try {
      final link = await child.getDownloadURL();
      return CachedNetworkImage(
        imageUrl: link,
        placeholder: (context, url) => Container(
          height: 30,
          child: CircularProgressIndicator(),
        ),
        errorWidget: (context, url, error) => Icon(Icons.error),
        fit: BoxFit.scaleDown,
      );
    } catch (e) {
      return Image.asset(
        "images/logoFueSmall.png",
        fit: BoxFit.scaleDown,
      );
    }
  }

  void onError(error) {
    print("ERROR: IMAGE NOT FOUND " + error.toString());
  }

  // ignore: unused_element
  void _fixCategorias() {
    var collection = FirebaseFirestore.instance.collection('receitas');

    collection.where("categoria", isEqualTo: "Docess").get().then((value) {
      value.docs.forEach((element) {
        collection
            .doc(element.id)
            .update({"categoria": "Doces"}).then((_) => print("updated"));
      });
    });
  }

  // ignore: unused_element
  void _fixImageUrl(List itemIDs) {
    var collection = FirebaseFirestore.instance.collection('receitas');
    itemIDs.forEach((itemID) {
      collection.where("itemID", isEqualTo: itemID).get().then((value) {
        value.docs.forEach((element) {
          collection.doc(element.id).update({"imageUrl": itemID + ".png"}).then(
              (_) => print("updated"));
        });
      });
    });
  }

  // ignore: unused_element
  void _fixNamesWithExtraSpace() {
    receitasGlobal.forEach((element) {
      Receita receita = Receita.fromStream(element);
      int nomeLen = receita.nome.length;
      String lastChar = receita.nome.substring(nomeLen - 1, nomeLen);
      if (lastChar == " ") {
        String newName = receita.nome.substring(0, nomeLen - 1);
        String itemID = receita.id;
        var collection = FirebaseFirestore.instance.collection('receitas');
        collection.where("itemID", isEqualTo: itemID).get().then((value) {
          value.docs.forEach((element) {
            collection
                .doc(element.id)
                .update({"nome": newName}).then((_) => print("updated"));
          });
        });
      }
    });
  }

  // ignore: unused_element
  void _addFields() {
    receitasGlobal.forEach((element) {
      Receita receita = Receita.fromStream(element);
      String itemID = receita.id;
      var collection = FirebaseFirestore.instance.collection('receitas');
      collection.where("itemID", isEqualTo: itemID).get().then((value) {
        value.docs.forEach((element) {
          collection.doc(element.id).update({"descricao": "to do"}).then(
              (_) => print("_addFields: updated"));
        });
      });
    });
  }
}
