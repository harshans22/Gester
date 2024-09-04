import 'package:flutter/material.dart';
import 'package:gester/firebase_methods/firestore_methods.dart';
import 'package:gester/models/all_meal_details.dart';
import 'package:gester/utils/utilities.dart';
import 'package:logger/logger.dart';

class MenuProvider with ChangeNotifier {
  var logger = Logger();
  Menu? _menu;//TODO: convert menu to a class of each day
  Menu? get menu => _menu;

  Future<void> getMenu() async {
    try {
      _menu = await FireStoreMethods().getdailymenu();
  

      notifyListeners();
    } catch (e) {
      logger.e(e.toString());
      throw Exception(e);
    }
  }

  List<dynamic> getTodaysMenu(DateTime dateTime) {
    int weekday = dateTime.weekday;
    String day = Utils.getDayName(weekday);
    return menu!.weeklyMenu[day]!;
  }
}
