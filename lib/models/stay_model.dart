// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:logger/logger.dart';

import 'package:gester/utils/utilities.dart';

var logger = Logger();

class StayModel {
  final int rent;
  final int securityDeposit;
  final int bed;
  final String pgNumber;
  final String room;
  final DateTime startDate;
  StayModel({
    required this.rent,
    required this.securityDeposit,
    required this.bed,
    required this.pgNumber,
    required this.room,
    required this.startDate,
  });

  factory StayModel.fromJson(
          Map<String, dynamic> kycData, Map<String, dynamic> accomodation) =>
      StayModel(
        rent: accomodation.isEmpty ? 0 : accomodation['Rent'],
        securityDeposit:
            accomodation.isEmpty ? 0 : accomodation['Security Deposite'],
        bed: kycData.isEmpty ? 0 : kycData['Accommodation_details']['Bed'],
        pgNumber: kycData.isEmpty
            ? "not valid"
            : kycData['Accommodation_details']['PG_number'],
        room: kycData.isEmpty
            ? "not valid"
            : kycData['Accommodation_details']['Room'],
        startDate: kycData.isEmpty
            ? DateTime.now()
            : Utils.getDateFromFirebase(
                (kycData['Accommodation_details']['StartDate'])),
      );
}

class PGDetails {
  final String pgAddress;
  final String coverPhoto;
  PGDetails({
    required this.pgAddress,
    required this.coverPhoto,
  });
  

  factory PGDetails.fromMap(Map<String, dynamic> map) {
    return PGDetails(
      pgAddress: map['address']??'',
      coverPhoto: map['Photos']['Cover_photo']??'',
    );
  }

}
