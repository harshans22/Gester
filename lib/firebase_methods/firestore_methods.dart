import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gester/models/all_meal_details.dart';
import 'package:gester/models/stay_model.dart';
import 'package:gester/models/usermodel.dart';
import 'package:gester/utils/utilities.dart';
import 'package:logger/logger.dart';
import 'package:http/http.dart' as http;

class FireStoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var logger = Logger();

//updating user gooogle photourl
  Future<void> updateUserDataFirebase(String? photourl, String? email) async {
    try {
      // Query the user document by email
      QuerySnapshot querySnapshot = await _firestore
          .collection("User")
          .where("Email", isEqualTo: email)
          .get();

      // Check if a document exists
      if (querySnapshot.docs.isNotEmpty) {
        // Get the document ID
        String docId = querySnapshot.docs.first.id;

        // Update the desired fields
        await _firestore.collection("User").doc(docId).set({
          "photourl": photourl,
        }, SetOptions(merge: true));
        //  Utils.toastMessage("User Logged In",Colors.red);
      } else {
        await _firestore.collection("User").doc().set(UserData(
              accomodation: Accomodation(rent: 0, securityDeposit: 0),
              subscription: Subscription(
                  amount: 0,
                  daysLeft: 30,
                  numberOfMeals: 90,
                  planName: "No Plan",
                  status: "InActive",
                  subscriptionCode: "0000"),
              userType: "AppUser",
              dietaryPreference: "",
              pgNumber: "",
              userId: "",
              fname: "",
              lname: "",
              gender: "",
              email: email!,
              photoUrl: photourl!,
              username: "",
              dateOfbirth: "",
              password: "",
              phoneNumber: "",
            ).toJson());
      }
    } catch (e) {
      logger.e(e.toString());
      //  Utils.toastMessage(e.toString(),Colors.red);
      throw Exception(e);
    }
  }

//chec if documents exists for mail
  Future<bool> checkIfDocumentExists(String userEmail) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("User")
        .where("Email", isEqualTo: userEmail)
        .get();

    return querySnapshot.docs.isNotEmpty;
  }

  //create Pg User MealCustomization
  Future<void> createMealCustomization() async {
    //TODO: handle it in such a way that if user is logging for the first time so there might be some meal customization present so don't create it on login
    String userdocid = await getUserDocId();
    try {
      final batch = _firestore.batch();

      // Create a reference to the collection
      final collectionRef = _firestore
          .collection("User")
          .doc(userdocid)
          .collection("MealCustomization");

      // Prepare the meal customization data
      final mealCustomizationData = MealCustomizationData(
          numberofRoti: 4,
          riceQuantity: 0.2,
          salad: true,
          raita: true,
          sukhiSabji: true,
          daal: true);

      final data = {
        "Morning": mealCustomizationData.toJson(),
        "Evening": mealCustomizationData.toJson(),
      };

      // Loop through the days of the week
      for (int i = 1; i <= 7; i++) {
        final dayName = Utils.getDayName(i);
        final docRef = collectionRef.doc(dayName);

        // Check if the document exists

        // Add the set operation to the batch only if the document does not exist
        batch.set(docRef, data);
      }
      await batch.commit();
    } catch (e) {
      logger.e("Meal customization error ${e.toString()}");
    }
  }

//get current userdocid

  Future<String> getUserDocId() async {
    User? firebaseUser = FirebaseAuth.instance.currentUser;
    QuerySnapshot querySnapshot = await _firestore
        .collection("User")
        .where("Email", isEqualTo: firebaseUser!.email)
        .get();
    return querySnapshot.docs.first.id;
  }

  //get PG id
  Future<PGDetails> getPGDetails(String pgNumber) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection("PG")
          .where("pgNumber", isEqualTo: pgNumber)
          .get();
      DocumentSnapshot snapshot = querySnapshot.docs.first;
      Map<String, dynamic> snapshotdata =
          snapshot.data() as Map<String, dynamic>;
      return PGDetails.fromMap(snapshotdata);
    } catch (e) {
      throw Exception("Error while fetching PgDetails$e");
    }
  }

  Future<void> checkMealOptexists(String userdocid) async {
    try {
      DateTime dateTime = await fetchTime();
      int hour = dateTime.hour;

      if (hour >= 21) {
        dateTime =
            dateTime.add(const Duration(days: 1)); //adding date after 9 PM
      }
      String date =
          "${dateTime.day < 10 ? '0${dateTime.day}' : dateTime.day}-${dateTime.month < 10 ? '0${dateTime.month}' : dateTime.month}-${dateTime.year}";

      DocumentSnapshot snapshot = await _firestore
          .collection("User")
          .doc(userdocid)
          .collection("MealOpt")
          .doc(dateTime.year.toString())
          .collection(Utils.getMonthName(dateTime.month))
          .doc(date)
          .get();
      if (snapshot.exists) {
        //To-do check whether breakfast,lunch and dinner exists
        return;
      } else {
        await _firestore
            .collection("User")
            .doc(userdocid)
            .collection("MealOpt")
            .doc(dateTime.year.toString())
            .collection(Utils.getMonthName(dateTime.month))
            .doc(date)
            .set({
          "breakfast": 0,
          "lunch": 0,
          "dinner": 0,
        });
      }
    } catch (e) {
      // ignore: prefer_interpolation_to_compose_strings
      throw Exception("Error while checking mealOpt exists$e");
    }
  }

  // Future<void>  generateMealOpt() async{

  // }

  //updating user meal
  Future<void> updateMealOpt(int breakfast, int lunch, int dinner,
      DateTime dateTime, String userdocid) async {
    int hour = dateTime.hour;

    if (hour >= 21) {
      dateTime = dateTime.add(const Duration(days: 1)); //adding date after 9 PM
    }
    String date =
        "${dateTime.day < 10 ? '0${dateTime.day}' : dateTime.day}-${dateTime.month < 10 ? '0${dateTime.month}' : dateTime.month}-${dateTime.year}";

    try {
      await _firestore
          .collection("User")
          .doc(userdocid)
          .collection("MealOpt")
          .doc(dateTime.year.toString())
          .collection(Utils.getMonthName(dateTime.month))
          .doc(date)
          .set({
        "breakfast": breakfast,
        "lunch": lunch,
        "dinner": dinner,
      }, SetOptions(merge: true));
    } catch (e) {
      // Utils.toastMessage(e.toString() +"from update subscription",Colors.red);
      throw Exception("Errow while Uploading Mealopt$e");
    }
  }

  Future<UserData> getuserdata() async {
    String docId = await getUserDocId();
    try {
      DateTime dateTime = await fetchTime(); //to-do make it fetch from api
      int hour = dateTime.hour;

      if (hour >= 21) {
        dateTime =
            dateTime.add(const Duration(days: 1)); //adding date after 9 PM
      }
      String date =
          "${dateTime.day < 10 ? '0${dateTime.day}' : dateTime.day}-${dateTime.month < 10 ? '0${dateTime.month}' : dateTime.month}-${dateTime.year}";
      DocumentSnapshot snapshot =
          await _firestore.collection("User").doc(docId).get();
      DocumentSnapshot mealcustomization = await _firestore
          .collection("User")
          .doc(docId)
          .collection("MealCustomization")
          .doc(Utils.getDayName(dateTime.weekday))
          .get();
      DocumentSnapshot mealoptSnapshot = await _firestore
          .collection("User")
          .doc(docId)
          .collection("MealOpt")
          .doc(dateTime.year.toString())
          .collection(Utils.getMonthName(dateTime.month))
          .doc(date)
          .get();
      DocumentSnapshot kycdata = await _firestore
          .collection("User")
          .doc(docId)
          .collection("KYCData")
          .doc("main")
          .get();
      UserData user = UserData.fromjson(
          snapshot.data() as Map<String, dynamic>,
          docId,
          (mealoptSnapshot.data() == null)
              ? {
                  "breakfast": 0,
                  "lunch": 0,
                  "dinner": 0,
                }
              : mealoptSnapshot.data() as Map<String, dynamic>,
          (kycdata.data() == null)
              ? {}
              : kycdata.data() as Map<String, dynamic>,
          mealcustomization.data() as Map<String, dynamic>);
      return user;
    } catch (e) {
      throw Exception("Error while getting user data $e");
    }
  }

  //updating kitchen data
  Future<void> updatekitchendata(
      String userid,
      String pgNumber,
      String fname,
      String dietaryPrefrence,
      int newbreakfast,
      int newlunch,
      int newdinner,
      DateTime dateTime,
      Map<String, dynamic> morning,
      Map<String, dynamic> evening) async {
    try {
      int hour = dateTime.hour;
      if (hour >= 21) {
        dateTime =
            dateTime.add(const Duration(days: 1)); //adding date after 9 PM
      }
      String date =
          "${dateTime.day < 10 ? '0${dateTime.day}' : dateTime.day}-${dateTime.month < 10 ? '0${dateTime.month}' : dateTime.month}-${dateTime.year}";
      DocumentSnapshot snapshot = await _firestore
          .collection("Kitchen")
          .doc(date)
          .collection("MealOpt")
          .doc(userid)
          .get();
      if (snapshot.exists) {
        Map<String, dynamic> mealoptData =
            snapshot.data() as Map<String, dynamic>;
        int oldBreakfast = 0;
        int oldLunch = 0;
        int oldDinner = 0;
        bool oldMorningdaal = mealoptData['Morning']['daal'];
        bool oldMorningsalad = mealoptData['Morning']['salad'];
        bool oldMorningraita = mealoptData['Morning']['raita'];
        bool oldMorningsukhiSabji = mealoptData['Morning']['sukhiSabji'];
        bool oldEveningdaal = mealoptData['Evening']['daal'];
        bool oldEveningsalad = mealoptData['Evening']['salad'];
        bool oldEveningraita = mealoptData['Evening']['raita'];
        bool oldEveningsukhiSabji = mealoptData['Evening']['sukhiSabji'];
        int oldmorningRoti = mealoptData['Morning']['numberofRoti'];
        double oldmorningRice = mealoptData['Morning']['riceQuantity'];
        int oldeveningRoti = mealoptData['Evening']['numberofRoti'];
        double oldeveningRice = mealoptData['Evening']['riceQuantity'];
        oldBreakfast = mealoptData["breakfast"];
        oldLunch = mealoptData["lunch"];
        oldDinner = mealoptData["dinner"];
        await _firestore
            .collection("Kitchen")
            .doc(date)
            .collection("MealOpt")
            .doc(userid)
            .set({
          "breakfast": newbreakfast,
          "lunch": newlunch,
          "dinner": newdinner,
          "Morning": morning,
          "Evening": evening
        }, SetOptions(merge: true));
        DocumentSnapshot totalmealOptsnapshot =
            await _firestore.collection("Kitchen").doc(date).get();
        Map<String, dynamic> totalmealOpt =
            totalmealOptsnapshot.data() as Map<String, dynamic>;
        int totalbreakfast = totalmealOpt["allBreakfast"];
        int totallunch = totalmealOpt["allLunch"];
        int totaldinner = totalmealOpt["allDinner"];
        int totalsukhiSabjiMorning =
            totalmealOpt["Morning"]["total_sukhiSabji"];
        int totalraitaMorning = totalmealOpt["Morning"]["total_raita"];
        int totalsaladMorning = totalmealOpt["Morning"]["total_salad"];
        int totalDaalMorning = totalmealOpt["Morning"]["total_daal"];
        int numberOfRotiMorning = totalmealOpt["Morning"]["total_roties"];
        double riceQuantityMorning = totalmealOpt["Morning"]["total_rice"];
        int totalsukhiSabjiEvening =
            totalmealOpt["Evening"]["total_sukhiSabji"];
        int totalraitaEvening = totalmealOpt["Evening"]["total_raita"];
        int totalsaladEvening = totalmealOpt["Evening"]["total_salad"];
        int totalDaalEvening = totalmealOpt["Evening"]["total_daal"];
        int numberOfRotiEvening = totalmealOpt["Evening"]["total_roties"];
        double riceQuantityEvening = totalmealOpt["Evening"]["total_rice"];

        if (oldBreakfast < newbreakfast) {
          totalbreakfast += (newbreakfast - oldBreakfast);
        } else {
          totalbreakfast -= (oldBreakfast - newbreakfast);
        }
        if (oldLunch < newlunch) {
          totallunch += (newlunch - oldLunch);
        } else {
          totallunch -= (oldLunch - newlunch);
        }
        if (oldDinner < newdinner) {
          totaldinner += (newdinner - oldDinner);
        } else {
          totaldinner -= (oldDinner - newdinner);
        }
        totalsukhiSabjiMorning += (newlunch) * (morning['sukhiSabji'] ? 1 : 0) -
            (oldLunch) * (oldMorningsukhiSabji ? 1 : 0);
        totalraitaMorning += (newlunch) * (morning['raita'] ? 1 : 0) -
            (oldLunch) * (oldMorningraita ? 1 : 0);
        totalDaalMorning += (newlunch) * (morning['daal'] ? 1 : 0) -
            (oldLunch) * (oldMorningdaal ? 1 : 0);
        totalsaladMorning += (newlunch) * (morning['salad'] ? 1 : 0) -
            (oldLunch) * (oldMorningsalad ? 1 : 0);
        totalsukhiSabjiEvening +=
            (newdinner) * (evening['sukhiSabji'] ? 1 : 0) -
                (oldDinner) * (oldEveningsukhiSabji ? 1 : 0);
        totalraitaEvening += (newdinner) * (evening['raita'] ? 1 : 0) -
            (oldDinner) * (oldEveningraita ? 1 : 0);
        totalDaalEvening += (newdinner) * (evening['daal'] ? 1 : 0) -
            (oldDinner) * (oldEveningdaal ? 1 : 0);
        totalsaladEvening += (newdinner) * (evening['salad'] ? 1 : 0) -
            (oldDinner) * (oldEveningsalad ? 1 : 0);

        if (numberOfRotiMorning < morning['numberofRoti']) {
          numberOfRotiMorning +=
              ((newlunch) * (morning['numberofRoti'] as int) -
                  (oldLunch) * oldmorningRoti);
        } else {
          numberOfRotiMorning -= ((oldLunch) * oldmorningRoti -
              (newlunch) * (morning['numberofRoti'] as int));
        }
        if (riceQuantityMorning < morning['riceQuantity']) {
          riceQuantityMorning +=
              ((newlunch) * (morning['riceQuantity'] as double) -
                  (oldLunch) * oldmorningRice);
        } else {
          riceQuantityMorning -= ((oldLunch) * oldmorningRice -
              (newlunch) * (morning['riceQuantity'] as double));
        }
        if (numberOfRotiEvening < evening['numberofRoti']) {
          numberOfRotiEvening +=
              ((newdinner) * (evening['numberofRoti'] as int) -
                  (oldDinner) * oldeveningRoti);
        } else {
          numberOfRotiEvening -= ((oldDinner) * oldeveningRoti -
              (newdinner) * (evening['numberofRoti'] as int));
        }
        if (riceQuantityEvening < evening['riceQuantity']) {
          riceQuantityEvening +=
              ((newdinner) * (evening['riceQuantity'] as double) -
                  (oldDinner) * oldeveningRice);
        } else {
          riceQuantityEvening -= ((oldDinner) * oldeveningRice -
              (newdinner) * (evening['riceQuantity'] as double));
        }
        await _firestore.collection("Kitchen").doc(date).set(
          {
            "allBreakfast": totalbreakfast,
            "allLunch": totallunch,
            "allDinner": totaldinner,
            "Morning": {
              "total_sukhiSabji": totalsukhiSabjiMorning,
              "total_raita": totalraitaMorning,
              "total_daal": totalDaalMorning,
              "total_salad": totalsaladMorning,
              "total_roties": numberOfRotiMorning,
              "total_rice": riceQuantityMorning,
            },
            "Evening": {
              "total_sukhiSabji": totalsukhiSabjiEvening,
              "total_raita": totalraitaEvening,
              "total_daal": totalDaalEvening,
              "total_salad": totalsaladEvening,
              "total_roties": numberOfRotiEvening,
              "total_rice": riceQuantityEvening,
            },
          },
        );
      } else {
        await _firestore
            .collection("Kitchen")
            .doc(date)
            .collection("MealOpt")
            .doc(userid)
            .set({
          "breakfast": newbreakfast,
          "lunch": newlunch,
          "dinner": newdinner,
          "fname": fname,
          "dropname": pgNumber,
          "Morning": morning,
          "Evening": evening,
          "Dietary_preference":
              dietaryPrefrence, //TODO-change the hard core data
          "morningStatus": "Meal opted",
          "eveningStatus": "Meal opted",
        });
        DocumentSnapshot totalmealOptsnapshot =
            await _firestore.collection("Kitchen").doc(date).get();
        int totalbreakfast = 0;
        int totallunch = 0;
        int totaldinner = 0;
        int totalsukhiSabjiMorning = 0;
        int totalraitaMorning = 0;
        int totalsaladMorning = 0;
        int totalDaalMorning = 0;
        int numberOfRotiMorning = 0;
        double riceQuantityMorning = 0;
        int totalsukhiSabjiEvening = 0;
        int totalraitaEvening = 0;
        int totalsaladEvening = 0;
        int totalDaalEvening = 0;
        int numberOfRotiEvening = 0;
        double riceQuantityEvening = 0;

        if (totalmealOptsnapshot.exists) {
          Map<String, dynamic> totalmealOpt =
              totalmealOptsnapshot.data() as Map<String, dynamic>;
          totalbreakfast = totalmealOpt["allBreakfast"];
          totallunch = totalmealOpt["allLunch"];
          totaldinner = totalmealOpt["allDinner"];
          totalsukhiSabjiMorning = totalmealOpt["Morning"]["total_sukhiSabji"];
          totalraitaMorning = totalmealOpt["Morning"]["total_raita"];
          totalDaalMorning = totalmealOpt["Morning"]["total_daal"];
          totalsaladMorning = totalmealOpt["Morning"]["total_salad"];
          numberOfRotiMorning = totalmealOpt["Morning"]["total_roties"];
          riceQuantityMorning = totalmealOpt["Morning"]["total_rice"];
          totalsukhiSabjiEvening = totalmealOpt["Evening"]["total_sukhiSabji"];
          totalDaalEvening = totalmealOpt["Evening"]["total_daal"];
          totalsaladEvening = totalmealOpt["Evening"]["total_salad"];
          totalraitaEvening = totalmealOpt["Evening"]["total_raita"];
          numberOfRotiEvening = totalmealOpt["Evening"]["numberofRoti"];
          riceQuantityEvening = totalmealOpt["Evening"]["riceQuantity"];
        }
        await _firestore.collection("Kitchen").doc(date).set(
          {
            "allBreakfast": (totalbreakfast + newbreakfast),
            "allLunch": (totallunch + newlunch),
            "allDinner": (totaldinner + newdinner),
            "Morning": {
              "total_sukhiSabji": totalsukhiSabjiMorning +
                  (newlunch) * (morning['sukhiSabji'] ? 1 : 0),
              "total_raita":
                  totalraitaMorning + (newlunch) * (morning['raita'] ? 1 : 0),
              "total_daal":
                  totalDaalMorning + (newlunch) * (morning['daal'] ? 1 : 0),
              "total_salad":
                  totalsaladMorning + (newlunch) * (morning['salad'] ? 1 : 0),
              "total_roties":
                  numberOfRotiMorning + (newlunch) * morning['numberofRoti'],
              "total_rice":
                  riceQuantityMorning + (newlunch) * morning['riceQuantity'],
            },
            "Evening": {
              "total_sukhiSabji": totalsukhiSabjiEvening +
                  (newdinner) * (evening['sukhiSabji'] ? 1 : 0),
              "total_raita":
                  totalraitaEvening + (newdinner) * (evening['raita'] ? 1 : 0),
              "total_daal":
                  totalDaalEvening + (newdinner) * (evening['daal'] ? 1 : 0),
              "total_salad":
                  totalsaladEvening + (newdinner) * (evening['salad'] ? 1 : 0),
              "total_roties":
                  numberOfRotiEvening + (newdinner) * evening['numberofRoti'],
              "total_rice":
                  riceQuantityEvening + (newdinner) * evening['riceQuantity'],
            },
          },
        );
      }
    } catch (e) {
      throw Exception("Error while updating kitchen data :$e");
    }
  }

  //fetching date from current date

  Future<Menu> getdailymenu() async {
    try {
      Map<String, List<String>> weeklymenu = {};
      for (int i = 1; i <= 7; i++) {
        String day = Utils.getDayName(i);
        DocumentSnapshot snapshot =
            await _firestore.collection("Menu").doc(day).get();
        Map<String, dynamic> dailyMenusnapshot =
            snapshot.data() as Map<String, dynamic>;
        List<String> dailyMenu = [];
        dailyMenu.add(dailyMenusnapshot["breakfast"]);
        dailyMenu.add(dailyMenusnapshot["lunch"]);
        dailyMenu.add(dailyMenusnapshot["dinner"]);
        weeklymenu[day] = dailyMenu;
      }
      DocumentSnapshot weekperiodsnapshot =
          await _firestore.collection("Menu").doc("Data").get();
      Map<String, dynamic> weekperiod =
          weekperiodsnapshot.data() as Map<String, dynamic>;
      return Menu(weeklyMenu: weeklymenu, weekPeriod: weekperiod["weekPeriod"]);
    } catch (e) {
      throw Exception("Error while fetching daily menu :$e");
    }
  }

  //get stay details

  Future<StayModel> getStayDetails(String userId) async {
    try {
      DocumentSnapshot kycsnapshot = await _firestore
          .collection("User")
          .doc(userId)
          .collection("KYCData")
          .doc("main")
          .get();
      DocumentSnapshot accomodationSnapshot =
          await _firestore.collection("User").doc(userId).get();
      return StayModel.fromJson(
          !kycsnapshot.exists ? {} : kycsnapshot.data() as Map<String, dynamic>,
          !accomodationSnapshot.exists
              ? {}
              : (accomodationSnapshot.data()
                  as Map<String, dynamic>)["Accommodation"]);
    } catch (e) {
      throw Exception("Error while fetching stay details :$e");
    }
  }

//fetching real time
  Future<DateTime> fetchTime() async {
    const url = 'https://worldtimeapi.org/api/timezone/Asia/Kolkata';
    try {
      // final response = await http.get(Uri.parse(url));
      return DateTime.now();
      // if (response.statusCode == 200) {
      //   final data = jsonDecode(response.body);
      //   final DateTime dateTime = DateTime.parse(data['datetime']).toLocal();
      //   return dateTime;
      // } else {
      //   logger.e(response);
      //   throw Exception(response);
      // }
    } catch (e) {
      throw Exception("Error while getting time $e");
    }
  }

  //get all mealopt from collection of mealopt by monthly basis
  Future<Map<String, Map<String, Map<String, dynamic>>>> getMonthlyMealOpt(
      String userId) async {
    try {
      DocumentReference yearDocRef = _firestore
          .collection("User")
          .doc(userId)
          .collection("MealOpt")
          .doc("2024");

      List<String> possibleSubcollectionNames = [
        'January',
        'February',
        'March',
        'April',
        'May',
        'June',
        'July',
        'August',
        'September',
        'October',
        'November',
        'December'
      ];

      Map<String, Map<String, Map<String, dynamic>>> monthlyData = {};

      for (String monthsubcollection in possibleSubcollectionNames) {
        CollectionReference monthsubcollectionRef =
            yearDocRef.collection(monthsubcollection);
        try {
          QuerySnapshot monthsubcollectionSnapshot =
              await monthsubcollectionRef.get();
          Map<String, Map<String, dynamic>> dailyDataList = {};
          for (QueryDocumentSnapshot doc in monthsubcollectionSnapshot.docs) {
            dailyDataList[doc.id] = doc.data() as Map<String, dynamic>;
          }
          if (dailyDataList.isNotEmpty) {
            monthlyData[monthsubcollection] = dailyDataList;
          }
        } catch (e) {
          logger.e(e.toString());
        }
      }

      return monthlyData;
    } catch (e) {
      throw Exception("Error while getting user monthly meap opt :$e");
    }
   // return {};
  }

  //update meal customization
  Future<void> singleDaycustomizationMeal(Map<String, dynamic> morning,
      Map<String, dynamic> evening, String userdocid, DateTime dateTime) async {
    int hour = dateTime.hour;

    if (hour >= 21) {
      dateTime = dateTime.add(const Duration(days: 1)); //adding date after 9 PM
    }
    String date =
        "${dateTime.day < 10 ? '0${dateTime.day}' : dateTime.day}-${dateTime.month < 10 ? '0${dateTime.month}' : dateTime.month}-${dateTime.year}";
    try {
      await _firestore
          .collection("User")
          .doc(userdocid)
          .collection("MealOpt")
          .doc(dateTime.year.toString())
          .collection(Utils.getMonthName(dateTime.month))
          .doc(date)
          .set({
        "Morning": morning,
        "Evening": evening,
      }, SetOptions(merge: true));
    } catch (e) {
      logger.e(e.toString());
    }
  }

  //get meal customization data
  Future<MealCustomizationData> updateMealCustomization(
      String userdocid,
      String pgNumber,
      String fname,
      String dietaryPrefrence,
      Map<String, dynamic> morning,
      Map<String, dynamic> evening,
      bool sameforEvening,
      bool sameforMorning,
      int weekday,
      int currentbreakfast,
      int currentLunch,
      int currrentDinner,
      DateTime dateTime) async {
    try {
      if (currentbreakfast > 0 || currentLunch > 0 || currrentDinner > 0) {
        updatekitchendata(
            userdocid,
            pgNumber,
            fname,
            dietaryPrefrence,
            currentbreakfast,
            currentLunch,
            currrentDinner,
            dateTime,
            morning,
            evening);
      }

      if (sameforMorning && !sameforEvening) {
        await _firestore
            .collection("User")
            .doc(userdocid)
            .collection("MealCustomization")
            .doc(Utils.getDayName(weekday))
            .set({
          "Evening": evening,
        }, SetOptions(merge: true));
        final collectionRef = _firestore
            .collection("User")
            .doc(userdocid)
            .collection("MealCustomization");

        final data = {
          "Morning": morning,
        };
        final batch = _firestore.batch();

        // Loop through the days of the week
        for (int i = 1; i <= 7; i++) {
          final dayName = Utils.getDayName(i);
          final docRef = collectionRef.doc(dayName);

          // Add the set operation to the batch only if the document does not exist
          batch.set(docRef, data, SetOptions(merge: true));
        }
        await batch.commit();
      } else if (!sameforMorning && sameforEvening) {
        final collectionRef = _firestore
            .collection("User")
            .doc(userdocid)
            .collection("MealCustomization");

        final data = {
          "Evening": evening,
        };
        final batch = _firestore.batch();

        // Loop through the days of the week
        for (int i = 1; i <= 7; i++) {
          await _firestore
              .collection("User")
              .doc(userdocid)
              .collection("MealCustomization")
              .doc(Utils.getDayName(weekday))
              .set({
            "Morning": morning,
          }, SetOptions(merge: true));
          final dayName = Utils.getDayName(i);
          final docRef = collectionRef.doc(dayName);

          // Add the set operation to the batch only if the document does not exist
          batch.set(docRef, data, SetOptions(merge: true));
        }
        await batch.commit();
      } else if (sameforMorning && sameforEvening) {
        final collectionRef = _firestore
            .collection("User")
            .doc(userdocid)
            .collection("MealCustomization");

        final data = {
          "Morning": morning,
          "Evening": evening,
        };
        final batch = _firestore.batch();
        // Loop through the days of the week
        for (int i = 1; i <= 7; i++) {
          final dayName = Utils.getDayName(i);
          final docRef = collectionRef.doc(dayName);

          // Add the set operation to the batch only if the document does not exist
          batch.set(docRef, data, SetOptions(merge: true));
        }
        await batch.commit();
      } else {
        await _firestore
            .collection("User")
            .doc(userdocid)
            .collection("MealCustomization")
            .doc(Utils.getDayName(weekday))
            .set({
          "Morning": morning,
          "Evening": evening,
        }, SetOptions(merge: true));
      }
    } catch (e) {
      throw Exception("Error while Meal optimization : $e");
    }
    return MealCustomizationData();
  }
}
