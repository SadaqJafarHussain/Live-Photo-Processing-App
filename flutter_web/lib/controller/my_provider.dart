import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/usermodel.dart';
import '../views/json_data.dart';

// Your provider class
class MyProvider extends ChangeNotifier {
  String data = "Hello, Provider!";
  String newBirthDay='';
  String newProvince='';
  String newJudiciary='';
  String newArea='';
  String newBloodGroup='';
  String selectedProvince='';
  String selectedJudiciary='';
  String selectedArea='';
  String selectedBloodGroup='';
  String firstPhoneValue='';
  String secondPhoneValue='';
  List<Map<String, dynamic>> provinces = jsonData['provinces']!;
  List<Map<String, dynamic>> judiciaries = [];
  List<Map<String, dynamic>> areas =[];

  changeFirstPhoneValue(String  value){
    firstPhoneValue=value;
    notifyListeners();
  }

  changeSecondPhoneValue(String value){
    secondPhoneValue=value;
    notifyListeners();
  }

  getSharedPreferencesData()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString('user_data');

    if (jsonString != null) {
     var userModel = UserModel.fromJson(jsonDecode(jsonString));
     if(userModel.ldProviance!=0){
       onProvinceChanged(userModel.ldProviance.toString());
     }
     if(userModel.ldCity!=0){
       onJudiciaryChanged(userModel.ldCity.toString());
     }
     if(userModel.ldDistrict!=0){
       setSelectedArea(userModel.ldDistrict.toString());
     }
    }
  }

  void onProvinceChanged(String? provinceId) {
    setSelectedDistrict("");
    setSelectedArea("");

    judiciaries = jsonData['judiciaries']!
        .where((j) => j['province_id'].toString() == provinceId)
        .toList();

    if (judiciaries.isEmpty) {
      print("⚠ No judiciaries found for province ID: $provinceId");
    }
    areas = []; // Reset areas

    notifyListeners();
  }

  void onJudiciaryChanged(String? judiciaryId) {
    setSelectedDistrict(judiciaryId!);
    setSelectedArea("");

    // ✅ SAFETY CHECK: Ensure we don't get an empty list
    areas = jsonData['areas']!
        .where((a) => a['district_ID'].toString() == judiciaryId)
        .toList();

    if (areas.isEmpty) {
      print("⚠ No areas found for judiciary ID: $judiciaryId");
    }
    notifyListeners();
  }



  setNewBirthDay(String birthday){
    newBirthDay=birthday;
    notifyListeners();
  }
  setNewBloodGroup(String bloodGroup){
    newBloodGroup=bloodGroup;
    notifyListeners();
  }
  setNewProvince(String province){
    newProvince=province;
    notifyListeners();
  }
  setNewJudiciary(String judiciary){
    newJudiciary=judiciary;
    notifyListeners();
  }
  setNewArea(String area){
    newArea=area;
    notifyListeners();
  }
  setSelectedProvince(String provinceID){
    selectedProvince=provinceID;
  }
  setSelectedDistrict(String districtID){
    selectedJudiciary=districtID;
    notifyListeners();
  }
  setSelectedArea(String areaID){
    selectedArea=areaID;
    notifyListeners();
  }
  setSelectedBloodGroup(String bloodGroup){
    selectedBloodGroup=bloodGroup;
    notifyListeners();
  }

  void updateData(String newData) {
    data = newData;
    notifyListeners();
  }
  List<DropdownMenuItem<String>> getJudiciaryDropdownItems() {
    return judiciaries.map((judiciary) {
      return DropdownMenuItem(
        value: judiciary['district_ID'].toString(),
        child: Text(judiciary['المدينة او القضاء']),
      );
    }).toList();
  }
  List<DropdownMenuItem<String>> getAreaDropdownItems() {
    return areas.map((area) {
      return DropdownMenuItem(
        value: area['Neighbor_ID'].toString(),
        child: Text(area['المنطقة او الحي']),
      );
    }).toList();
  }
  List<DropdownMenuItem<String>> getProvinceDropdownItems() {
    return provinces.map((province) {
      return DropdownMenuItem(
        value:
        province['province_id'].toString(),
        child: Text(province['المحافظة']),
      );
    }).toList();
  }


  String getProvince(String provinceId) {
    var filteredProvinces = provinces
        .where((v) => v['province_id'].toString() == provinceId)
        .toList();
    return filteredProvinces.first['المحافظة'].toString();
  }


  String getDistrict(String districtId, String provinceID) {
    var filteredJudiciaries = jsonData['judiciaries']!
        .where((j) => j['province_id'].toString() == provinceID)
        .toList();

    var result = filteredJudiciaries.firstWhere(
            (v) => v['district_ID'].toString() == districtId,
        orElse: () => {});

    return result.isNotEmpty ? result['المدينة او القضاء'] : "Unknown";
  }

  String getArea(String areaID, String districtID) {
    var filteredAreas = jsonData['areas']!
        .where((a) => a['district_ID'].toString() == districtID)
        .toList();

    var result = filteredAreas.firstWhere(
            (v) => v['Neighbor_ID'].toString() == areaID,
        orElse: () => {});

    return result.isNotEmpty ? result['المنطقة او الحي'] : "Unknown";
  }



}