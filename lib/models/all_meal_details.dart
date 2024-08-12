
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



  MealCustomizationData copyWith({
    int? numberofRoti,
    double? riceQuantity,
    bool? daal,
    bool? sukhiSabji,
    bool? raita,
    bool? salad,
  }) {
    return MealCustomizationData(
      numberofRoti: numberofRoti ?? this.numberofRoti,
      riceQuantity: riceQuantity ?? this.riceQuantity,
      daal: daal ?? this.daal,
      sukhiSabji: sukhiSabji ?? this.sukhiSabji,
      raita: raita ?? this.raita,
      salad: salad ?? this.salad,
    );
  }

  
   @override
  bool operator ==(Object other) {//to compare two classes are  equal or not because they may have diffrent hash code
    if (identical(this, other)) return true;

    return other is MealCustomizationData &&
        other.numberofRoti == numberofRoti &&
        other.riceQuantity == riceQuantity &&
        other.daal == daal &&
        other.sukhiSabji == sukhiSabji &&
        other.raita == raita &&
        other.salad == salad;
  }

  @override
  int get hashCode {
    return numberofRoti.hashCode ^
        riceQuantity.hashCode ^
        daal.hashCode ^
        sukhiSabji.hashCode ^
        raita.hashCode ^
        salad.hashCode;
  }


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
