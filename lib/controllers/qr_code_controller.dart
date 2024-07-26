import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class QrCodeController extends ChangeNotifier {
// url_launcherni ishlatish
  Future<void> launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
    notifyListeners();
  }
}
