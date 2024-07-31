// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:gester/models/all_meal_details.dart';

class UserData {
  final String userId;
  final String email;
  final String fname;
  final String lname;
  final String gender;
  final String photoUrl;
  final String username;
  final String dateOfbirth;
  final String password;
  final String phoneNumber;
  final Subscription subscription;
  final Accomodation accomodation;
  final String userType;
  int breakfast;
  int lunch;
  int dinner;
  final String pgNumber;
  final MealCustomizationData morning;
  final MealCustomizationData evening;

  UserData({
    required this.accomodation,
    required this.subscription,
    required this.userType,
    required this.pgNumber,
    required this.userId,
    required this.fname,
    required this.lname,
    required this.gender,
    required this.email,
    required this.photoUrl,
    required this.username,
    required this.dateOfbirth,
    required this.password,
    required this.phoneNumber,
    this.breakfast = 0,
    this.lunch = 0,
    this.dinner = 0,
    MealCustomizationData? morning,
    MealCustomizationData? evening,
  })  : morning = morning ?? MealCustomizationData(
          numberofRoti: 4,
          riceQuantity: 0.2,
          daal: true,
          salad: true,
          sukhiSabji: true,
          raita: true,
        ),
        evening = evening ?? MealCustomizationData(
          numberofRoti: 4,
          riceQuantity: 0.2,
          daal: true,
          salad: true,
          sukhiSabji: true,
          raita: true,
        );


  factory UserData.fromjson(Map<String, dynamic> json, String docId,
          Map<String, dynamic> mealOptjson, Map<String, dynamic> kycdatajson) =>
      UserData(
        userId: docId,
        accomodation:
            Accomodation.fromjson(json.isEmpty ? {} : json["Accommodation"]),
        userType: json['Usertype'] ?? "",
        fname: json['fname'] ?? "",
        lname: json['lname'] ?? "",
        gender: json['Gender'] ?? "",
        email: json['Email'] ?? "",
        photoUrl: json['photourl'] ?? "",
        username: json['Username'] ?? "",
        dateOfbirth: json['DateOfBirth'] ?? "",
        password: json['Password'] ?? "",
        phoneNumber: json['phoneNumber'] ?? "",
        subscription: Subscription.fromjson(json.isEmpty
            ? {}
            : json[
                'Subscription']), //to-do what if the subscription if not present
        breakfast: mealOptjson['breakfast'] ?? 0,
        lunch: mealOptjson['lunch'] ?? 0,
        dinner: mealOptjson['dinner'] ?? 0,
        pgNumber: kycdatajson.isEmpty
            ? ""
            : kycdatajson['Accommodation_details']['PG_number'],
            morning: MealCustomizationData.fromMap(mealOptjson["Morning"]??{}),
            evening:  MealCustomizationData.fromMap(mealOptjson["Evening"]??{}),
      );

  Map<String, dynamic> toJson() => {
        'fname': fname,
        'lname': lname,
        'Gender': gender,
        'Email': email,
        'photourl': photoUrl,
        'Username': username,
        'DateOfBirth': dateOfbirth,
        'Password': password,
        'phoneNumber': phoneNumber,
        'Subscription': subscription.toJson(),
        'Accommodation': accomodation.toJson(),
        'Usertype': userType,
        'pgNumber': pgNumber,
      };
}

class Subscription {
  final int amount;
  final int daysLeft;
  final int numberOfMeals;
  final String planName;
  final String status;
  final String subscriptionCode;
  Subscription({
    required this.subscriptionCode,
    required this.amount,
    required this.daysLeft,
    required this.numberOfMeals,
    required this.planName,
    required this.status,
  });

  factory Subscription.fromjson(Map<String, dynamic> json) => Subscription(
        amount: json['amount'] ?? 0,
        daysLeft: json['daysLeft'] ?? 0,
        numberOfMeals: json['numberOfMeals'] ?? 0,
        planName: json['planName'] ?? "",
        status: json['status'] ?? "",
        subscriptionCode: json['subscriptionCode'] ?? "",
      );
  Map<String, dynamic> toJson() => {
        'amount': amount,
        'daysLeft': daysLeft,
        'numberOfMeals': numberOfMeals,
        'planName': planName,
        'status': status
      };
}

class Accomodation {
  final int rent;
  final int securityDeposit;
  Accomodation({
    required this.rent,
    required this.securityDeposit,
  });

  factory Accomodation.fromjson(Map<String, dynamic> json) => Accomodation(
        rent: json['Rent'] ?? 0,
        securityDeposit: json['Security Deposite'] ?? "",
      );
  Map<String, dynamic> toJson() =>
      {'Rent': rent, 'Security Deposite': securityDeposit};
}
