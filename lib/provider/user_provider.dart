import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gester/firebase_methods/firestore_methods.dart';
import 'package:gester/models/all_meal_details.dart';
import 'package:gester/models/stay_model.dart';
import 'package:gester/models/usermodel.dart';
import 'package:gester/provider/home_screen_provider.dart';
import 'package:gester/provider/meal_customization_provider.dart';
import 'package:gester/utils/app_constants.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

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
  




  // setOldmealcustomization(
  //     MealCustomizationData morning, MealCustomizationData evening) {
  //   _oldmorningData = morning.copyWith(); //because dietary prefrence in users are not set intitally mtlab unke mealCustomization mein dietary prefrecne nhi tha ek baar sab mein add ho jaye tab bhale hi hta do ya phir mt htao by chance user ka dietart prefrecne na fetch ho mealCustomization to uske form fill krte waqt le lega
  //   _oldeveningData = evening.copyWith();
  //   morningdietaryPrefrenceIndex = Appconstants.dietaryPrefrence.indexOf(_oldmorningData.dietaryPrefrence);
  //   eveningdietaryPrefrenceIndex = Appconstants.dietaryPrefrence.indexOf(_oldeveningData.dietaryPrefrence);//to change the color and imageIcon in App constants
  //   notifyListeners();
  // }

  setoldMealtype(int breakfast, int lunch, int dinner) {
    _totalMealopt = breakfast + lunch + dinner;
    _oldbreakfast = breakfast;
    _oldlunch = lunch;
    _olddinner = dinner;
    notifyListeners();
  }

  notifylistner() {
    //to notifly listners
    notifyListeners();
  }

  Future<void> updateUser(BuildContext context) async {
    try {
      _user = await FireStoreMethods().getuserdata();
      if (_user!.userType == "PGUser") {
        await FireStoreMethods().checkMealOptexists(_user!.userId);
      }
      setoldMealtype(_user!.breakfast, _user!.lunch, _user!.dinner);
      if (!context.mounted) return;
      await context.read<MealCustomizationProvider>().fetchMealCustomizationData(_user!.userId, context);  
      if (!context.mounted) return;
      await context.read<HomeScreenProvider>().updateUserData(
          _user!); //update the user data in home screen provider
      notifyListeners();
    } catch (e) {
      throw Exception(e);
    }
  }

  //get PG Details
  Future<void> getPGDetails() async {
    try {
      if (_user!.userType == "PGUser") {
        _pgDetails = await FireStoreMethods().getPGDetails(_user!.pgNumber);
      } else {
        _pgDetails = PGDetails();
      }

      notifyListeners();
    } catch (e) {
      logger.e(e.toString());
      throw Exception(e);
    }
  }

  Future<void> getStayDetails() async {
    try {
      _stayDetails = await FireStoreMethods().getStayDetails(_user!.userId);
      notifyListeners();
    } catch (e) {
      logger.e(e.toString());
      throw Exception(e);
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

  void setsubscriptionstatus(String status) {
    _user!.subscription.status = status;
    notifyListeners();
  }
}
