// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import 'package:gester/firebase_methods/firestore_methods.dart';
import 'package:gester/models/usermodel.dart';

class UserKYCDocumentsProvider with ChangeNotifier {
  var logger = Logger();
  KYCDocuments? _kycDocuments;
  KYCDocuments? get kycDocuments => _kycDocuments;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  UserDocumentsInFile? _documentsInFile;
  UserDocumentsInFile? get documentsInFile => _documentsInFile;

  bool checkDocumentsChanged() {
    if (_documentsInFile!.adhaarback != null &&
        _documentsInFile!.adhaarfront != null &&
        _documentsInFile!.collegeProof != null &&
        _documentsInFile!.workProof != null &&
        _documentsInFile!.photo != null) return true;
    return false;
  }

  setisLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> uploadKYCDocuments(
      Uint8List? aadharCardFront,
      Uint8List? aadharCardBack,
      Uint8List? workProof,
      Uint8List? collegeProof,
      Uint8List? passportPhoto,
      String userId) async {
    setisLoading(true);
    try {
    
      await FireStoreMethods().uploadKYCDocuments(
          userdocid: userId,
          adhaarFront: aadharCardFront,
          adhaarBack: aadharCardBack,
          workProof: workProof,
          collegeProof: collegeProof,
          photo: passportPhoto);
           await getKYCDocuments(userId);
    } catch (e) {
      logger.e(e.toString());
    }
    setisLoading(false);
    notifyListeners();
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

//creating user documents in file or Uint8list  format to check save and continue button
class UserDocumentsInFile {
  final Uint8List? adhaarfront;
  final Uint8List? adhaarback;
  final Uint8List? workProof;
  final Uint8List? collegeProof;
  final Uint8List? photo;
  UserDocumentsInFile({
    required this.adhaarfront,
    required this.adhaarback,
    required this.workProof,
    required this.collegeProof,
    required this.photo,
  });

  @override
  bool operator ==(Object other) {
    //to compare two classes are  equal or not because they may have diffrent hash code
    if (identical(this, other)) return true;

    return other is UserDocumentsInFile &&
        other.adhaarfront == adhaarfront &&
        other.adhaarback == adhaarback &&
        other.workProof == workProof &&
        other.collegeProof == collegeProof &&
        other.photo == photo;
  }

  @override
  int get hashCode {
    return adhaarfront.hashCode ^
        adhaarback.hashCode ^
        workProof.hashCode ^
        collegeProof.hashCode ^
        photo.hashCode;
  }
}
