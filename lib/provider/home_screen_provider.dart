import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gester/firebase_methods/firestore_methods.dart';
import 'package:gester/models/usermodel.dart';
import 'package:gester/utils/app_constants.dart';
import 'package:gester/utils/utilities.dart';

class HomeScreenProvider with ChangeNotifier {
  UserData? _userDataModel;
  UserData get userDataModel => _userDataModel!;
  DateTime? _dateTime;
  DateTime get dateTime => _dateTime!;
  bool _showMorningTimer = false;
  bool get showMorningTimer => _showMorningTimer;
  bool _showEveningTimer = false;
  bool get showEveningTimer => _showEveningTimer;
  int totalMealopt = 0;
  int get oldbreakfast => _userDataModel!.breakfast;
  int get oldlunch => _userDataModel!.lunch;
  int get olddinner => _userDataModel!.dinner;
  late Color counterBoxBorder;
  TextEditingController? noteController;//TODO assign value from user mealOpt
  bool _loader = false;
  bool get loader => _loader;
  

  updateUserData(UserData userdata) {
    _userDataModel = userdata;
    setcounterboxView();
    notifyListeners();
  }

  updateUserNote(String note) {
    _userDataModel!.note = note;
    notifyListeners();
  }

  setcounterboxView() {
    counterBoxBorder = _userDataModel!.subscription.subscriptionCode ==
            Appconstants.subsciptionCode4
        ? Colors.grey
        : Colors.red;
    notifyListeners();
  }

  setloader(bool value) {
    _loader = value;
    notifyListeners();
  }

  Future<void> updatemealOpt(
      int breakfast,
      int lunch,
      int dinner,
      String userId,
      String pgNumber,
      String username,
      Map<String, dynamic> morning,
      Map<String, dynamic> evening) async {
    setloader(true);
    try {
       logger.i("mealOpt updated");
      await FireStoreMethods()
          .updateMealOpt(breakfast, lunch, dinner, _dateTime!, userId);
      await FireStoreMethods().updatekitchendata(
          userId,
          pgNumber,
          username,
          breakfast,
          lunch,
          dinner,
          _dateTime!,
          morning,
          evening,
          );
         
      notifyListeners();
    } catch (e) {
      logger.e(e.toString());
    }
    setloader(false);
  }

  //update note in User data
  Future<void> updateNoteUserData(String note) async {//update user note in User Collection
    setloader(true);
    try {
      await FireStoreMethods().updateNoteUserData(
          _userDataModel!.userId, note, _dateTime!);
      notifyListeners();
    } catch (e) {
      logger.e(e.toString());
    }
    setloader(false);
  }


  //update note in kitchen data
  Future<void> updateNoteKitchenData(String note) async {//update note in kitchen Collection
    try {
      await FireStoreMethods().updateNoteInKitchenData(
          _userDataModel!.userId, note, _dateTime!);
      notifyListeners();
    } catch (e) {
      logger.e(e.toString());
    }
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
