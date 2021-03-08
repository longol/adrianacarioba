import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cached_network_image/cached_network_image.dart';

class AppData {
  static final AppData _appData = new AppData._internal();

  AppData._internal();
  factory AppData() {
    return _appData;
  }

  final FirebaseAnalytics _analytics = FirebaseAnalytics();
  FirebaseAnalyticsObserver getAnalyticsObserver() =>
      FirebaseAnalyticsObserver(analytics: _analytics);
  Future setUserProperties({@required String userId}) async {
    await _analytics.setUserId(userId);
  }

  Future<void> launchInBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
        headers: <String, String>{'my_header_key': 'my_header_value'},
      );
    } else {
      throw 'Could not launch $url';
    }
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
        // placeholder: (context, url) => Container(
        //   height: 30,
        //   child: CircularProgressIndicator(),
        // ),
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
}
