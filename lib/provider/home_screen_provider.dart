import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gester/firebase_methods/firestore_methods.dart';
import 'package:gester/models/stay_model.dart';
import 'package:gester/utils/utilities.dart';

class HomeScreenProvider with ChangeNotifier {
  DateTime? _dateTime;
  DateTime get dateTime => _dateTime!;
  bool _mealoptloader = false;
  bool get mealoptloader => _mealoptloader;
  bool _showMorningTimer = false;
  bool get showMorningTimer => _showMorningTimer;
  bool _showEveningTimer = false;
  bool get showEveningTimer => _showEveningTimer;

  setmealoptloader(bool value) {
    _mealoptloader = value;
    notifyListeners();
  }

  Future<void> updatemealOpt(
      int breakfast,
      int lunch,
      int dinner,
      String userId,
      String pgNumber,
      String username,
      String dietaryPrefrence,
      Map<String, dynamic> morning,
      Map<String, dynamic> evening) async {
    setmealoptloader(true);
    try {
      await FireStoreMethods()
          .updateMealOpt(breakfast, lunch, dinner, _dateTime!, userId);
      await FireStoreMethods().updatekitchendata(
          userId,
          pgNumber,
          username,
          dietaryPrefrence,
          breakfast,
          lunch,
          dinner,
          _dateTime!,
          morning,
          evening);
      notifyListeners();
    } catch (e) {
      logger.e(e.toString());
    }
    setmealoptloader(false);
  }

  Future<void> fetchTimeFromServer() async {
    try {
      _dateTime = await FireStoreMethods().fetchTime();
      notifyListeners();
    } catch (e) {
      throw Exception(e);
    }
  }

  void startLocalClock() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      _dateTime = _dateTime!.add(const Duration(seconds: 1));
      if (_dateTime!.hour < 5 && _dateTime!.hour >= 4) {
        _showMorningTimer = true;
      } else {
        _showMorningTimer = false;
      }
      if (_dateTime!.hour < 17 && _dateTime!.hour >= 16) {
        _showEveningTimer = true;
      } else {
        _showEveningTimer = false;
      }
      notifyListeners();
    });
  }
}
