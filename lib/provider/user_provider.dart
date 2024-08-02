import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gester/firebase_methods/firestore_methods.dart';
import 'package:gester/models/stay_model.dart';
import 'package:gester/models/usermodel.dart';
import 'package:logger/logger.dart';

class UserDataProvider with ChangeNotifier {
  var logger = Logger();
  UserData? _user;
  UserData get user => _user!;
  StayModel? _stayDetails;
  StayModel get stayDetails => _stayDetails!;
  PGDetails? _pgDetails;
  PGDetails get pgDetails => _pgDetails!;
  int _oldbreakfast = 0;
  int _oldlunch = 0;
  int _olddinner = 0;
  int get oldbreakfast => _oldbreakfast;
  int get oldlunch => _oldlunch;
  int get olddinner => _olddinner;
  int _totalMealopt = 0;
  int get totalMealopt => _totalMealopt;



  setoldMealtype(int breakfast, int lunch, int dinner) {
    _totalMealopt = breakfast + lunch + dinner;
    _oldbreakfast = _user!.breakfast;
    _oldlunch = _user!.lunch;
    _olddinner = _user!.dinner;
    notifyListeners();
  }

  Future<void> updateUser() async {
    try {
      _user = await FireStoreMethods().getuserdata();
      if (_user!.userType == "PGUser") {
        await FireStoreMethods().checkMealOptexists(_user!.userId);
      }
      setoldMealtype(_user!.breakfast, _user!.lunch, _user!.dinner);
      notifyListeners();
    } catch (e) {
      logger.e(e);
    }
  }

  //get PG Details
  Future<void> getPGDetails() async {
    try {
      _pgDetails = await FireStoreMethods().getPGDetails(_user!.pgNumber);
      notifyListeners();
    } catch (e) {
      logger.e(e.toString());
    }
  }

  Future<void> getStayDetails() async {
    try {
      _stayDetails = await FireStoreMethods().getStayDetails(_user!.userId);
      notifyListeners();
    } catch (e) {
      logger.e(e);
    }
  }

  void updateMealOpt(int newvalue, bool isbreakfast, bool islunch,
      bool isdinner, String userType,
      [bool issubtracted = false]) {
    if (userType == "PGUser") {
      if (_totalMealopt >= 3 && !issubtracted) {
        return;
      }
    }
    if (newvalue < 0) {
      return;
    }
    if (isbreakfast) {
      if (_user!.breakfast > newvalue) {
        _totalMealopt--;
      } else {
        _totalMealopt++;
      }
      _user!.breakfast = newvalue;
    }
    if (islunch) {
      if (_user!.lunch > newvalue) {
        _totalMealopt--;
      } else {
        _totalMealopt++;
      }
      _user!.lunch = newvalue;
    }
    if (isdinner) {
      if (_user!.dinner > newvalue) {
        _totalMealopt--;
      } else {
        _totalMealopt++;
      }
      _user!.dinner = newvalue;
    }
    notifyListeners();
  }

  //reset to default if not opted within time
  void resetMealOpt() {
    _user!.breakfast = _oldbreakfast;
    _user!.lunch = _oldlunch;
    _user!.dinner = _olddinner;
    _totalMealopt = _oldbreakfast + _oldlunch + _olddinner;
    notifyListeners();
  }
}
