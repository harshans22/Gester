import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Menu {
  final Map<String, List<String>> weeklyMenu;
  final String weekPeriod;
  Menu({
    required this.weeklyMenu,
    required this.weekPeriod,
  });
}

class MealCustomizationData {
   int numberofRoti;
   double riceQuantity;
   bool daal;
   bool salad;
   bool sukhiSabji;
   bool raita;
  MealCustomizationData({
    this.numberofRoti=4,
    this.riceQuantity=0.2,
    this.daal=true,
    this.salad=true,
    this.sukhiSabji=true,
    this.raita=true,
  });


  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'numberofRoti': numberofRoti,
      'riceQuantity': riceQuantity,
      'daal': daal,
      'salad': salad,
      'sukhiSabji': sukhiSabji,
      'raita': raita,
    };
  }


  factory MealCustomizationData.fromMap(Map<String, dynamic> map) {
    return MealCustomizationData(
      numberofRoti: map['numberofRoti']??4,
      riceQuantity: map['riceQuantity']??0.2,
      daal: map['daal']??true,
      salad: map['salad']??true,
      sukhiSabji: map['sukhiSabji']??true,
      raita: map['raita']??true,
    );
  }


}
