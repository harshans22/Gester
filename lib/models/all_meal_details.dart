
// ignore_for_file: public_member_api_docs, sort_constructors_first
class Menu {
  final Map<String, List<dynamic>> weeklyMenu;
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
   String dietaryPrefrence;
  MealCustomizationData({
    this.numberofRoti=3,
    this.riceQuantity=0.5,
    this.daal=false,
    this.salad=true,
    this.sukhiSabji=true,
    this.raita=false,
    this.dietaryPrefrence="",
  });



  MealCustomizationData copyWith({
    int? numberofRoti,
    double? riceQuantity,
    bool? daal,
    bool? sukhiSabji,
    bool? raita,
    bool? salad,
    String? dietaryPrefrence,
  }) {
    return MealCustomizationData(
      numberofRoti: numberofRoti ?? this.numberofRoti,
      riceQuantity: riceQuantity ?? this.riceQuantity,
      daal: daal ?? this.daal,
      sukhiSabji: sukhiSabji ?? this.sukhiSabji,
      raita: raita ?? this.raita,
      salad: salad ?? this.salad,
      dietaryPrefrence: dietaryPrefrence ?? this.dietaryPrefrence,
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
        other.salad == salad&&
        other.dietaryPrefrence==dietaryPrefrence;
  }

  @override
  int get hashCode {
    return numberofRoti.hashCode ^
        riceQuantity.hashCode ^
        daal.hashCode ^
        sukhiSabji.hashCode ^
        raita.hashCode ^
        salad.hashCode^
        dietaryPrefrence.hashCode;
  }


  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'numberofRoti': numberofRoti,
      'riceQuantity': riceQuantity,
      'daal': daal,
      'salad': salad,
      'sukhiSabji': sukhiSabji,
      'raita': raita,
      'Dietary_preference': dietaryPrefrence,
    };
  }



  factory MealCustomizationData.fromMap(Map<String, dynamic> map) {
    return MealCustomizationData(
      numberofRoti: map['numberofRoti']??3,
      riceQuantity: map['riceQuantity'] ?? 0.5,
      daal: map['daal']??true,
      salad: map['salad']??false,
      sukhiSabji: map['sukhiSabji']??true,
      raita: map['raita']??false,
      dietaryPrefrence: map['Dietary_preference']??"",
    );
  }


}
