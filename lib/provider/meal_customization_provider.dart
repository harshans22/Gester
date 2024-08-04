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
      String pgNumber,
      String fname,
      String deitaryPrefrence,
      Map<String, dynamic> morning,
      Map<String, dynamic> evening,
      bool sameforMorning,
      bool sameforEvening,
      int weekday,
      int currentbreakfast,
      int currentLunch,
      int currentDinner,DateTime dateTime) async {
    setloader(true);
    try {
      await FireStoreMethods().updateMealCustomization(
          userdocid,
          pgNumber,
          fname,
          deitaryPrefrence,
          morning,
          evening,
          sameforEvening,
          sameforMorning,
          weekday,
          currentbreakfast,
          currentLunch,
          currentDinner,
          dateTime);
      await FireStoreMethods()
          .singleDaycustomizationMeal(morning, evening, userdocid, dateTime);
    } catch (e) {
      logger.i(e.toString());
    }
    setloader(false);
  }
}
