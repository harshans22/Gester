import 'package:flutter/material.dart';
import 'package:gester/firebase_methods/firestore_methods.dart';
import 'package:gester/models/all_meal_details.dart';
import 'package:gester/provider/menu_provider.dart';
import 'package:gester/provider/user_provider.dart';
import 'package:gester/utils/app_constants.dart';
import 'package:gester/utils/utilities.dart';
import 'package:logger/web.dart';
import 'package:provider/provider.dart';

class MealCustomizationProvider with ChangeNotifier {
  var logger = Logger();
  bool _loader = false;
  bool get loader => _loader;
  List<MealCustomizationData>? _morningData;
  List<MealCustomizationData> get morningData => _morningData!;
  List<MealCustomizationData>? _eveningData;
  List<MealCustomizationData> get eveningData => _eveningData!;
  List<MealCustomizationData>? _oldmorningData;
  List<MealCustomizationData> get oldmorningData => _oldmorningData!;
  List<MealCustomizationData>? _oldeveningData;
  List<MealCustomizationData> get oldeveningData => _oldeveningData!;

  setoldMealCustomization(List<MealCustomizationData> morning,
      List<MealCustomizationData> evening) {
    _oldmorningData = morning.map((e) => e.copyWith()).toList();//to create new instance of each element
    _oldeveningData = evening.map((e) => e.copyWith()).toList();
    notifyListeners();
  }

  setloader(bool value) {
    _loader = value;
    notifyListeners();
  }

  notifylistner() {
    notifyListeners();
  }

  //fetch meal customization data
  Future<void> fetchMealCustomizationData(
      String userId, BuildContext context) async {
    try {
      List<Map<String, MealCustomizationData>> mealCustomiation =
          await FireStoreMethods().fetchUserMealCustomization(userId);
      List<MealCustomizationData> tempmorningData = [];
      List<MealCustomizationData> tempeveningData = [];
      for (int i = 0; i < mealCustomiation.length; i++) {
        if (!context.mounted) return;
        //updating dietary prefrence according to available mealOpt
        mealCustomiation[i]["Morning"]!.dietaryPrefrence = getDietaryPrefrence(
            context
                .read<MenuProvider>()
                .menu!
                .weeklyMenu[Utils.getDayName(i + 1)]![4]["lunch"]
                .cast<String>(),
            context.read<UserDataProvider>().user.dietaryPreference);
        mealCustomiation[i]["Evening"]!.dietaryPrefrence = getDietaryPrefrence(
            context
                .read<MenuProvider>()
                .menu!
                .weeklyMenu[Utils.getDayName(i + 1)]![4]["dinner"]
                .cast<String>(),
            context.read<UserDataProvider>().user.dietaryPreference);
        tempmorningData.add(mealCustomiation[i]["Morning"]!.copyWith());
        tempeveningData.add(mealCustomiation[i]["Evening"]!.copyWith());
      }
      _morningData = tempmorningData.map((e) => e.copyWith()).toList();//to create new instance of each element
      _eveningData = tempeveningData.map((e) => e.copyWith()).toList();
      setoldMealCustomization(_morningData!, _eveningData!);
    } catch (e) {
      logger.i(e.toString());
    }
    notifyListeners();
  }

  //get user default dietaryprefernce according to available mealOpt
  String getDietaryPrefrence(
      List<String> availableMealOpt, String userdietaryPrefrence) {
    if (availableMealOpt.contains(Appconstants.nonveg)) {
      if (userdietaryPrefrence == Appconstants.nonveg ||
          userdietaryPrefrence == Appconstants.nonvegWithoutEgg || userdietaryPrefrence == Appconstants.vegandNonveg) {
        return Appconstants.nonveg;
      } else {
        return Appconstants.veg;
      }
    } else if (availableMealOpt.contains(Appconstants.egg)) {
      if (userdietaryPrefrence == Appconstants.nonveg ||
          userdietaryPrefrence == Appconstants.vegandEgg || userdietaryPrefrence == Appconstants.vegandNonveg) {
        return Appconstants.egg;
      } else {
        return Appconstants.veg;
      }
    } else {
      return Appconstants.veg;
    }
  }

  Future<void> updateMealCustomization(
      String userdocid,
      String pgNumber,
      String fname,
      Map<String, dynamic> morning,
      Map<String, dynamic> evening,
      bool sameforMorning,
      bool sameforEvening,
      int weekday,
      int currentbreakfast,
      int currentLunch,
      int currentDinner,
      DateTime dateTime) async {
    setloader(true);
    try {
      await FireStoreMethods().updateMealCustomization(
          userdocid,
          pgNumber,
          fname,
          morning,
          evening,
          sameforEvening,
          sameforMorning,
          weekday,
          currentbreakfast,
          currentLunch,
          currentDinner,
          dateTime);
    } catch (e) {
      logger.i(e.toString());
    }
    setloader(false);
  }
}
