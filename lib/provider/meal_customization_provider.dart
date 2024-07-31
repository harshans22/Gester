import 'package:flutter/material.dart';
import 'package:gester/firebase_methods/firestore_methods.dart';
import 'package:logger/web.dart';

class MealCustomizationProvider with ChangeNotifier {
  var logger = Logger();
  bool _loader = false;
  bool get getLoader => _loader;

  setloader(bool value) {
    _loader = value;
    notifyListeners();
  }

  Future<void> updateMealCustomization(
      String userdocid,
      Map<String, dynamic> morning,
      Map<String, dynamic> evening,
      DateTime dateTime) async {
    setloader(true);
    try {
    await FireStoreMethods()
          .updateMealCustomization(userdocid, morning, evening, dateTime);
    } catch (e) {
      logger.i(e.toString());
    }
    setloader(false);
  }
}
