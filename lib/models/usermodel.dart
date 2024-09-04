// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:gester/models/all_meal_details.dart';

//TODO: seperate the meal customization data from user data
class UserData {
  final String userId;
  final String email;
  final String fname;
  final String lname;
  final String gender;
  final String photoUrl;
  final String username;
  final String dateOfbirth;
  final String dietaryPreference;
  final String password;
  final String phoneNumber;
  final Subscription subscription;
  final Accomodation accomodation;
  final String userType;
  int breakfast;
  int lunch;
  int dinner;
  String note;
  final String pgNumber;

  UserData({
    required this.note,
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
    required this.dietaryPreference,
    this.breakfast = 0,
    this.lunch = 0,
    this.dinner = 0,
  });

  factory UserData.fromjson(
          Map<String, dynamic> json,
          String docId,
          Map<String, dynamic> mealOptjson,
          Map<String, dynamic> kycdatajson,
         ) =>
      UserData(
        userId: docId,
        accomodation: Accomodation.fromjson(json["Accommodation"] ?? {}),
        userType: json['Usertype'] ?? "",
        fname: json['fname'] ?? "",
        lname: json['lname'] ?? "",
        gender: json['Gender'] ?? "Not Defined",
        email: json['Email'] ?? "",
        photoUrl: json['photourl'] ?? "",
        username: json['Username'] ?? "",
        dateOfbirth: json['DateOfBirth'] ?? "Not Available",
        password: json['Password'] ?? "Not Available",
        phoneNumber: json['phoneNumber'] ?? "Not Defined",
        dietaryPreference: json["Dietary_preference"] ?? "Veg",
        subscription: Subscription.fromjson(json['Subscription'] ??
            {}), //to-do what if the subscription if not present
        breakfast: mealOptjson['breakfast'] ?? 0,
        lunch: mealOptjson['lunch'] ?? 0,
        dinner: mealOptjson['dinner'] ?? 0,
        note: mealOptjson['note'] ?? "",
        pgNumber: kycdatajson.isEmpty
            ? ""
            : kycdatajson['Accommodation_details']['PG_number'],
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
  String status;
  final String subscriptionCode;
  Subscription({
    required this.subscriptionCode,
    required this.amount,
    required this.daysLeft,
    required this.numberOfMeals,
    required this.planName,
    this.status = "Away",
  });

  factory Subscription.fromjson(Map<String, dynamic> json) => Subscription(
        amount: json['amount'] ?? 0,
        daysLeft: json['daysLeft'] ?? 0,
        numberOfMeals: json['numberOfMeals'] ?? 0,
        planName: json['planName'] ?? "No Plan",
        status: json['status'] ?? "", //TODO: check if the status is not present
        subscriptionCode: json['subscriptionCode'] ?? "P004",
      );
  Map<String, dynamic> toJson() => {
        'amount': amount,
        'daysLeft': daysLeft,
        'numberOfMeals': numberOfMeals,
        'planName': planName,
        'status': status,
        'subscriptionCode': subscriptionCode,
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
        securityDeposit: json['Security Deposite'] ?? 0,
      );
  Map<String, dynamic> toJson() =>
      {'Rent': rent, 'Security Deposite': securityDeposit};
}

class KYCDocuments {
  final String adhaarFront;
  final String adhaarBack;
  final String workProof;
  final String collegeProof;
  final String photo;
  KYCDocuments({
    required this.adhaarFront,
    required this.adhaarBack,
    required this.workProof,
    required this.collegeProof,
    required this.photo,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'Aadhaar_front': adhaarFront,
      'Aadhaar_back': adhaarBack,
      'Work_proof': workProof,
      'College_proof': collegeProof,
      'Passport_photo': photo,
    };
  }

  factory KYCDocuments.fromMap(Map<String, dynamic> map) {
    return KYCDocuments(
      adhaarFront: map['Aadhaar_front'] ?? "",
      adhaarBack: map['Aadhaar_back'] ?? "",
      workProof: map['Work_proof'] ?? "",
      collegeProof: map['College_proof'] ?? "",
      photo: map['Passport_photo'] ?? "",
    );
  }
}
