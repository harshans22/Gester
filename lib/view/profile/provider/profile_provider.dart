import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:gester/resources/color.dart';
import 'package:gester/utils/utilities.dart';

class ProfileProvider with ChangeNotifier {
  bool _loading = false;
  bool get loading => _loading;

  setloading(bool loading) {
    _loading = loading;
    notifyListeners();
  }

  final FirebaseStorage _storage = FirebaseStorage.instance;
  Future<String> uploadImageToStorage(
      String childName, Uint8List file, String userId) async {
    Reference ref = _storage.ref().child("Profile Photo").child(userId);

//when we are going toPost

    UploadTask uploadTask = ref.putData(file);
    TaskSnapshot snap = await uploadTask; //  metadata data of uploaded file
    // to download link of our image which is stored in firestore
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> uploadChangedData(
      Uint8List? file,
      String userId,
      String userImageurl,
      String fname,
      String lname,
      String dob,
      String phoneNumber,
      String username,
      String email,
      String password,
      String gender) async {
    setloading(true);
    try {
      String photourl = "";
      if (file == null) {
        photourl = userImageurl;
      } else {
        photourl = await uploadImageToStorage("Profile Photo", file, userId);
      }
      await _firestore.collection("User").doc(userId).set({
        "photourl": photourl,
        "fname": fname,
        "lname": lname,
        "DateOfBirth": dob,
        "phoneNumber": phoneNumber,
        "Username": username,
        "Email": email,
        "Gender": gender,
        "Password": password,
      }, SetOptions(merge: true));
      Utils.toastMessage(
          "Changes were made successfully", AppColor.GREEN_COLOR);
         
    } catch (err) {
     
      Utils.toastMessage("Some error occured", AppColor.RED_COLOR);
    }
     setloading(false);
  }
}
