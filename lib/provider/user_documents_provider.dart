import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:gester/firebase_methods/firestore_methods.dart';
import 'package:gester/models/usermodel.dart';
import 'package:logger/logger.dart';

class UserKYCDocumentsProvider with ChangeNotifier {
  var logger =  Logger();
  KYCDocuments? _kycDocuments;
  KYCDocuments? get kycDocuments => _kycDocuments;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  setisLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> uploadKYCDocuments(
      Uint8List aadharCardFront,
      Uint8List aadharCardBack,
      Uint8List workProof,
      Uint8List collegeProof,
      Uint8List passportPhoto,
      String userId) 
      async {
    setisLoading(true);
    try {
      await FireStoreMethods().uploadKYCDocuments(
        userdocid: userId  ,adhaarFront:  aadharCardFront,adhaarBack:  aadharCardBack,workProof:  workProof,collegeProof:  collegeProof,photo:  passportPhoto);
      notifyListeners();
    } catch (e) {
       logger.e(e.toString());
    }
    setisLoading(false);
  }

  Future<void> getKYCDocuments(String userId) async {

    try {
      _kycDocuments = await FireStoreMethods().getKYCDocuments(userId);
      notifyListeners();
    } catch (e) {
      logger.e(e.toString());
    }
  
  }
}
