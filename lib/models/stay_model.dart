// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:logger/logger.dart';

import 'package:gester/utils/utilities.dart';

var logger = Logger();

class StayModel {
  int rent=0;
  int securityDeposit=0;
  int bed=0;
  String pgNumber="N.A";
  String room="N.A";
  DateTime startDate=DateTime.now();
  StayModel({
    this.rent=0,
    this.securityDeposit=0,
    this.bed=0,
    this.pgNumber="N.A",
    this.room="N.A",
    DateTime? startdate,
  }):startDate=startdate??DateTime.now();

  factory StayModel.fromJson(
          Map<String, dynamic> kycData, Map<String, dynamic> accomodation) =>
      StayModel(
        rent: accomodation['Rent']??0,
        securityDeposit:
           accomodation['Security Deposite']??0,
        bed: kycData.isEmpty?0: kycData['Accommodation_details']['Bed'],
        pgNumber:kycData.isNotEmpty? kycData['Accommodation_details']['PG_number']:"N.A",
        room: kycData.isNotEmpty? kycData['Accommodation_details']['Room']:"N.A",
        startdate:kycData.isNotEmpty? Utils.getDateFromFirebase(
              kycData['Accommodation_details']['StartDate']):DateTime.now()
      );
}

class PGDetails {
  String pgAddress="";
  String coverPhoto="";
  PGDetails({
    this.pgAddress="",
    this.coverPhoto="",
  });
  

  factory PGDetails.fromMap(Map<String, dynamic> map) {
    return PGDetails(
      pgAddress: map['address']??'',
      coverPhoto: map['Photos']['Cover_photo']??'',
    );
  }

}
