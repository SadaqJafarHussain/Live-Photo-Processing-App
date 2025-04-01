import 'dart:convert';

import 'package:nust_students/views/json_data.dart';

class UserModel {
  final String ldUserID;
  final String ldOtherCode;
  final int ldAccountType;
  final String? ldAccountTypeName;
  final int ldStatus;
  final String? ldStatusName;
  final String ldUserName;
  final String? ldUserPassword;
  final String ldFirstName;
  final String ldSecondName;
  final String ldEmailPassword;
  final String ldThirdName;
  final String ldFourthName;
  final String ldLastName;
  final String ldEnFirstName;
  final String ldEnSecondName;
  final String ldEnThirdName;
  final String ldEnFourthName;
  final String ldEnLastName;
  final String ldEmail;
  final List<String> ldPhoneNo;
  final String ldDateOfBirth;
  final String ldNationalId;
  final int ldNationality;
  final String? ldNationalityName;
  final String? ldOtherNationality;
  final String? ldCountry;
  final String? ldCountryName;
  final int ldCity;
  final String? ldCityName;
  final String ldAddress;
  final String ldFullArName;
  final String ldFullEnName;
  final String? ldLanguage;
  final int ldIsDelete;
  final String ldExamNo;
  final int ldProviance;
  final int ldDistrict;
  final int ldGender;
  final String ldBloodGroup;
  final String? ldFaceImage;
  final String ldCollage;
  final String ldPosition;
  final String ldDepartment;
  final String ldChecking;
  final int ldImageUploaded;

  UserModel({
    required this.ldUserID,
    required this.ldOtherCode,
    required this.ldAccountType,
    this.ldAccountTypeName,
    required this.ldStatus,
    this.ldStatusName,
    required this.ldUserName,
    this.ldUserPassword,
    required this.ldFirstName,
    required this.ldSecondName,
    required this.ldEmailPassword,
    required this.ldThirdName,
    required this.ldFourthName,
    required this.ldLastName,
    required this.ldEnFirstName,
    required this.ldEnSecondName,
    required this.ldEnThirdName,
    required this.ldEnFourthName,
    required this.ldEnLastName,
    required this.ldEmail,
    required this.ldPhoneNo,
    required this.ldDateOfBirth,
    required this.ldNationalId,
    required this.ldNationality,
    this.ldNationalityName,
    this.ldOtherNationality,
    this.ldCountry,
    this.ldCountryName,
    required this.ldCity,
    this.ldCityName,
    required this.ldAddress,
    required this.ldFullArName,
    required this.ldFullEnName,
    this.ldLanguage,
    required this.ldIsDelete,
    required this.ldExamNo,
    required this.ldProviance,
    required this.ldDistrict,
    required this.ldGender,
    required this.ldBloodGroup,
    this.ldFaceImage,
    required this.ldCollage,
    required this.ldPosition,
    required this.ldDepartment,
    required this.ldChecking,
    required this.ldImageUploaded,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      ldUserID: json['ldUserID'] ?? '',
      ldOtherCode: json['ldOtherCode'] ?? '',
      ldAccountType: json['ldAccountType'] ?? 0, // Assuming default is 0 if null
      ldAccountTypeName: json['ldAccountTypeName'] ?? '',
      ldStatus: json['ldStatus'] ?? 0, // Assuming default is 0 if null
      ldStatusName: json['ldStatusName'] ?? '',
      ldUserName: json['ldUserName'] ?? '',
      ldUserPassword: json['ldUserPassword'] ?? '',
      ldFirstName: utf8.decode(json['ldFirstName']?.codeUnits ?? []),
      ldSecondName: utf8.decode(json['ldSecondName']?.codeUnits ?? []),
      ldEmailPassword: json['ldEmailPassword'] ?? '',
      ldThirdName: utf8.decode(json['ldThirdName']?.codeUnits ?? []),
      ldFourthName: utf8.decode(json['ldFourthName']?.codeUnits ?? []),
      ldLastName: utf8.decode(json['ldLastName']?.codeUnits ?? []),
      ldEnFirstName: json['ldEnFirstName'] ?? '',
      ldEnSecondName: json['ldEnSecondName'] ?? '',
      ldEnThirdName: json['ldEnThirdName'] ?? '',
      ldEnFourthName: json['ldEnFourthName'] ?? '',
      ldEnLastName: json['ldEnLastName'] ?? '',
      ldEmail: json['ldEmail'] ?? '',
      ldPhoneNo: List<String>.from(json['ldPhoneNo'] ?? []),
      ldDateOfBirth: json['ldDateOfBirth'] ?? '',
      ldNationalId: json['ldNationalId'] ?? '',
      ldNationality: json['ldNationality'] ?? 0, // Assuming default is 0 if null
      ldNationalityName: json['ldNationalityName'] ?? '',
      ldOtherNationality: json['ldOtherNationality'] ?? '',
      ldCountry: json['ldCountry'] ?? '',
      ldCountryName: json['ldCountryName'] ?? '',
      ldCity: json['ldCity'] ?? 0, // Assuming default is 0 if null
      ldCityName: json['ldCityName'] ?? '',
      ldAddress: utf8.decode(json['ldAddress']?.codeUnits ?? []),
      ldFullArName: utf8.decode(json['ldFullArName']?.codeUnits ?? []),
      ldFullEnName: json['ldFullEnName'] ?? '',
      ldLanguage: json['ldLanguage'] ?? '',
      ldIsDelete: json['ldIsDelete'] ?? 0, // Assuming default is 0 if null
      ldExamNo: json['ldExamNo'] ?? '',
      ldProviance: json['ldProviance'] ?? 0, // Assuming default is 0 if null
      ldDistrict: json['ldDistrict'] ?? 0, // Assuming default is 0 if null
      ldGender: json['ldGender'] ?? 0, // Assuming default is 0 if null
      ldBloodGroup: json['ldBloodGroup'] ?? '',
      ldFaceImage: json['ldFaceImage'] ?? '',
      ldCollage: json['ldCollage'] ?? '',
      ldPosition: json['ldPosition'] ?? '',
      ldDepartment: json['ldDepartment'] ?? '',
      ldChecking: json['ldChecking'] ?? '',
      ldImageUploaded: json['ldImageUploaded'] ?? 0, // Assuming default is 0 if null
    );
  }

  String getProvinceFromId() {
   try {
     final result = jsonData["provinces"]!.firstWhere(
           (element) => element['province_id'].toString() == ldProviance.toString(),
     );
     return result['المحافظة'];
   } catch (e) {
     return "لايوجد";
   }
 }
  String getDistrictFromId() {
    try {
      final result = jsonData["judiciaries"]!.firstWhere(
            (element) => element['district_ID'].toString() == ldDistrict.toString(),
      );
      return result['المدينة او القضاء'];
    } catch (e) {
      return "لايوجد";
    }
  }

  String getCityFromId() {
    try {
      final result = jsonData["areas"]!.firstWhere(
            (element) => element['Neighbor_ID'].toString() == ldCity.toString(),
      );
      return result['المنطقة او الحي'];
    } catch (e) {
      return "لايوجد";
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'ldUserID': ldUserID,
      'ldOtherCode': ldOtherCode,
      'ldAccountType': ldAccountType,
      'ldAccountTypeName': ldAccountTypeName,
      'ldStatus': ldStatus,
      'ldStatusName': ldStatusName,
      'ldUserName': ldUserName,
      'ldUserPassword': ldUserPassword,
      'ldFirstName': ldFirstName,
      'ldSecondName': ldSecondName,
      'ldEmailPassword': ldEmailPassword,
      'ldThirdName': ldThirdName,
      'ldFourthName': ldFourthName,
      'ldLastName': ldLastName,
      'ldEnFirstName': ldEnFirstName,
      'ldEnSecondName': ldEnSecondName,
      'ldEnThirdName': ldEnThirdName,
      'ldEnFourthName': ldEnFourthName,
      'ldEnLastName': ldEnLastName,
      'ldEmail': ldEmail,
      'ldPhoneNo': ldPhoneNo,
      'ldDateOfBirth': ldDateOfBirth,
      'ldNationalId': ldNationalId,
      'ldNationality': ldNationality,
      'ldNationalityName': ldNationalityName,
      'ldOtherNationality': ldOtherNationality,
      'ldCountry': ldCountry,
      'ldCountryName': ldCountryName,
      'ldCity': ldCity,
      'ldCityName': ldCityName,
      'ldAddress': ldAddress,
      'ldFullArName': ldFullArName,
      'ldFullEnName': ldFullEnName,
      'ldLanguage': ldLanguage,
      'ldIsDelete': ldIsDelete,
      'ldExamNo': ldExamNo,
      'ldProviance': ldProviance,
      'ldDistrict': ldDistrict,
      'ldGender': ldGender,
      'ldBloodGroup': ldBloodGroup,
      'ldFaceImage': ldFaceImage,
      'ldCollage': ldCollage,
      'ldPosition': ldPosition,
      'ldDepartment': ldDepartment,
      'ldChecking': ldChecking,
      'ldImageUploaded': ldImageUploaded,
    };
  }
}
