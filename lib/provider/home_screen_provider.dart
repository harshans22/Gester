import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gester/firebase_methods/firestore_methods.dart';
import 'package:gester/utils/utilities.dart';

class HomeScreenProvider with ChangeNotifier {
  DateTime? _dateTime;
  DateTime? get dateTime => _dateTime!;
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

  Future<void> updatemealOpt(int breakfast, int lunch, int dinner,
      String userId, String pgNumber, String username,Map<String,dynamic> morning,Map<String,dynamic> evening) async {
    setmealoptloader(true);
    try {
      await FireStoreMethods()
          .updateMealOpt(breakfast, lunch, dinner, _dateTime!,userId);
      await FireStoreMethods().updatekitchendata(
          userId, pgNumber, username, breakfast, lunch, dinner, _dateTime!,morning,evening);
      notifyListeners();
    } catch (e) {
      Utils.toastMessage("Failed to update meal", Colors.red);
      print(e.toString());
    }
    setmealoptloader(false);
  }

  Future<void> fetchTimeFromServer() async {
    try {
      await FireStoreMethods().fetchTime().then((value) {
        _dateTime = value;
        notifyListeners();
      });
    } catch (e) {
      Utils.toastMessage(e.toString(), Colors.red);
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
      if (_dateTime!.hour <17  && _dateTime!.hour >= 16) {
        _showEveningTimer = true;
      } else {
        _showEveningTimer = false;
      }
      notifyListeners();
    });
  }
}
