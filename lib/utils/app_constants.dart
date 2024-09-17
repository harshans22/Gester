import 'package:flutter/material.dart';
import 'package:gester/resources/color.dart';

class Appconstants {
  static const statusActive = "Active";
  static const statusInactive = "Inactive";
  static const statusAway = "Away";

  static const eveningMealOptTimerstart = 4;
  static const morningMealOptTimerstart = 4;
  static const eveningMealOptTimerend = 5;
  static const morningMealOptTimerend = 5;
  static const mealOptReset = 9;

  static const Map<String, Color> subscriptionStatusColor = {
    "Active": AppColor.GREEN_COLOR,
    "Inactive": AppColor.RED_COLOR,
    "Away": AppColor.ORANGE_COLOR,
  };

  static const pguser = "PGUser";
  static const appuser = "AppUser";

  static const subsciptionCode0 = "P000";
  static const subsciptionCode1 = "P001";
  static const subsciptionCode2 = "P002";
  static const subsciptionCode3 = "P003";
  static const subsciptionCode4 = "P004";

  static const vegandEgg = "Veg + Egg";
  static const egg = "Egg";
  static const nonvegWithoutEgg = "Non Veg without egg";
  static const veg = "Veg";
  static const nonveg = "Non Veg";
  static const vegandNonveg = "Veg + Non Veg";

  static const Map<String, dynamic> dietaryPrefrenceImageIcon = {
    "Non Veg": "assets/images/homepage/non_veg_icon.svg",
    "Veg": "assets/images/homepage/veg_icon.svg",
    "Egg": "assets/images/homepage/veg+egg.svg",
  };

  static Map<String, Color> dietaryPrefrenceColor = {
    "Veg": AppColor.GREEN_COLOR.withOpacity(0.5),
    "Non Veg": AppColor.RED_COLOR.withOpacity(0.5),
    "Egg": Colors.yellow.withOpacity(0.5),
  };

  static List<String> carosuelSliderImage = [
    "assets/images/homepage/SliderImage1.png",
    "assets/images/homepage/SliderImage2.png",
    "assets/images/homepage/SliderImage3.png",
    "assets/images/homepage/SliderImage4.png"
  ];
}
