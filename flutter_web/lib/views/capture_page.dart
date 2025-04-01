import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:html' as html;
import 'package:image/image.dart' as img;
import 'package:intl/intl.dart' as intl;
import 'package:nust_students/controller/my_provider.dart';
import 'package:nust_students/utls/show_top_snackbar.dart';
import 'package:nust_students/widgets/custom_edit_button.dart';
import 'package:nust_students/widgets/date_picker.dart';
import 'package:nust_students/widgets/read_only_text_field.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import '../models/usermodel.dart';
import '../utls/drop_down_button_dialog.dart';
import '../widgets/custom_drop_down_widget.dart';

class ImageScreen extends StatefulWidget {
  const ImageScreen({super.key});

  @override
  _ImageScreenState createState() => _ImageScreenState();
}

class _ImageScreenState extends State<ImageScreen> {
  bool isLoading = true;
  img.Image? _image;
  bool loading = false;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstPhoneNumber = TextEditingController();
  final TextEditingController _secondPhoneNumber = TextEditingController();
  final _firstPhoneKey = GlobalKey<FormState>();
  final _secondPhoneKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    Provider.of<MyProvider>(context, listen: false).getSharedPreferencesData();
    fetchImage();
  }

  Future<UserModel> getUser() async {
    UserModel userModel = UserModel(
      ldFirstName: "",
      ldSecondName: "",
      ldThirdName: "",
      ldFourthName: "",
      ldUserID: '',
      ldOtherCode: '',
      ldAccountType: 1,
      ldStatus: 2,
      ldUserName: '',
      ldEmailPassword: '',
      ldLastName: '',
      ldEnFirstName: '',
      ldEnSecondName: '',
      ldEnThirdName: '',
      ldEnFourthName: '',
      ldEnLastName: '',
      ldEmail: '',
      ldPhoneNo: [],
      ldDateOfBirth: '',
      ldNationalId: '',
      ldNationality: 3,
      ldCity: 0,
      ldAddress: '',
      ldFullArName: '',
      ldFullEnName: '',
      ldIsDelete: 5,
      ldExamNo: '',
      ldProviance: 0,
      ldDistrict: 0,
      ldGender: 2,
      ldBloodGroup: '',
      ldPosition: '',
      ldCollage: '',
      ldDepartment: '',
      ldChecking: '',
      ldImageUploaded: 8,
    );

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString('user_data');

    if (jsonString != null) {
      userModel = UserModel.fromJson(jsonDecode(jsonString));
    }

    return userModel;
  }

  Future<void> fetchImage() async {
    try {
      final fullUrl = html.window.location.href;
      final uri = Uri.parse(fullUrl);
      final fragment = uri.fragment;
      final Map<String, String> params = {};
      if (fragment.contains('?')) {
        final queryString = fragment.split('?')[1];
        final pairs = queryString.split('&');
        for (var pair in pairs) {
          final keyValue = pair.split('=');
          if (keyValue.length == 2) {
            params[keyValue[0]] = keyValue[1];
          }
        }
      }
      final imageId = params['imageId'];
      if (imageId != null) {
        final response = await http.get(
            Uri.parse('https://nustsys.info/get_image.php?image_id=$imageId'));
        if (response.statusCode == 200) {
          Uint8List bytes = response.bodyBytes;
          img.Image originalImage = img.decodeImage(bytes)!;
          // Removed resizing and cropping logic
          setState(() {
            _image = originalImage;
          });
        } else {
          setState(() {
            isLoading = false;
          });
          print('Failed to load image');
        }
      } else {
        setState(() {
          isLoading = false;
        });
        print('No imageId found in URL');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching image: $e');
    }
  }

  String getTimestamp() {
    // Get current time
    DateTime now = DateTime.now();
    // Format the time using the DateFormat class from the intl package
    String timeStamp = intl.DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
    return timeStamp;
  }

  Future<String> updateStudentPhoto(UserModel userModel) async {
    String base64String = convertImageToBase64(_image!);
    String timestamp = getTimestamp(); // Get timestamp
    String encodedTimestamp =
        Uri.encodeComponent(timestamp); // Encode timestamp for URL
    print("base46 string :::::::: $base64String");
    final url =
        "https://lcgat.nust.edu.iq/egisapi/login/applyImageUpload?timeStamp=$timestamp";

    var response = await http.post(
      Uri.parse(url),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        'amiID': userModel.ldUserID.toString(),
        'amiFaceImage': 'data:image/png;base64,$base64String',
        'amiChecking': userModel.ldChecking.toString()
      }),
    );

    if (response.statusCode == 200) {
      print("Success: ${response.body}");
      return "success";
    } else {
      print("Error: ${response.statusCode} - ${response.body}");
      return response.body;
    }
  }

  Future<String> updateStudentInformation(
      UserModel userModel,
      String newProvinceName,
      String newDistrictName,
      String newAreaName,
      String bloodGroup,
      String newBirthDay,
      String firstPhone,
      String secondPhone) async {
    var provider = Provider.of<MyProvider>(context, listen: false);
    final url = "https://nustsys.info/std_info.php";

    var response = await http.post(Uri.parse(url), body: {
      'register_number': userModel.ldOtherCode.toString(),
      'name':
          "${userModel.ldFirstName} ${userModel.ldSecondName} ${userModel.ldThirdName} ${userModel.ldFourthName}",
      'gover': provider.getProvince(userModel.ldProviance.toString()),
      'town': provider.getDistrict(
          userModel.ldCity.toString(), userModel.ldProviance.toString()),
      'address': provider.getArea(
          userModel.ldDistrict.toString(), userModel.ldCity.toString()),
      "phone1": userModel.ldPhoneNo[0],
      'phone2': userModel.ldPhoneNo[1],
      'blood': userModel.ldBloodGroup,
      'bday': userModel.ldDateOfBirth,
      'new_register_number': userModel.ldOtherCode.toString(),
      'new_name':
          "${userModel.ldFirstName} ${userModel.ldSecondName} ${userModel.ldThirdName} ${userModel.ldFourthName}",
      'new_gover': newProvinceName,
      'new_town': newDistrictName,
      'new_address': newAreaName,
      "new_phone1": _firstPhoneNumber.text.trim(),
      'new_phone2': _secondPhoneNumber.text.trim(),
      'new_blood': bloodGroup,
      'new_bday': newBirthDay,
    });

    if (response.statusCode == 200) {
      print("Success: ${response.body}");
       return updateStudentPhoto(userModel);
    } else {
      print("Error: ${response.statusCode} - ${response.body}");
      return response.body;
    }
  }

  String convertImageToBase64(img.Image image) {
    // Encode the img.Image to PNG instead of JPEG
    List<int> pngBytes = img.encodePng(image);

    // Convert the PNG bytes to a Base64 string
    String base64String = base64Encode(Uint8List.fromList(pngBytes));

    return base64String;
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var provider = Provider.of<MyProvider>(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: FutureBuilder<UserModel>(
            future: getUser(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                    child: CircularProgressIndicator(
                  color: Colors.amber,
                )); // Show a loading indicator while fetching
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                var userModel = snapshot.data!;
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _image != null
                                ? Container(
                                    width: size.width *
                                        0.2, // Responsive width (80% of screen width)
                                    height: size.height *
                                        0.2, // Responsive height (40% of screen height)
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: MemoryImage(Uint8List.fromList(
                                            img.encodeJpg(_image!))),
                                        fit: BoxFit.contain,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  )
                                : Container(
                                    width: size.width *
                                        0.2, // Responsive width (80% of screen width)
                                    height: size.height *
                                        0.2, // Responsive height (40% of screen height)
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage("assets/place.jpeg"),
                                        fit: BoxFit.contain,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        color: Color(0xffAF9512),
                                      ),
                                    ),
                                  ),
                            SizedBox(
                              width: 30,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        "${userModel.ldFirstName} ${userModel.ldSecondName} ${userModel.ldThirdName} ${userModel.ldFourthName}",
                                        style: GoogleFonts.cairo(
                                            color: Colors.black,
                                            fontSize: 15.sp),
                                      ),
                                      Text(
                                        " ، مرحبا ",
                                        style: GoogleFonts.cairo(
                                            color: Color(0xffAF9512),
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        "Welcome , ",
                                        style: GoogleFonts.cairo(
                                            color: Color(0xffAF9512),
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        "${userModel.ldEnFirstName} ${userModel.ldEnSecondName} ${userModel.ldEnThirdName} ${userModel.ldEnFourthName}",
                                        style: GoogleFonts.cairo(
                                            color: Colors.black,
                                            fontSize: 15.sp),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ), // Build your widget with the data
                            ),
                          ],
                        ),
                      ),
                      Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            SizedBox(
                              height: 1.h,
                            ),
                            CustomDatePicker(
                              userModel: userModel,
                              isReadOnly: userModel.ldDateOfBirth != '',
                            ),
                            userModel.ldBloodGroup == ''
                                ? CustomDropdownField(
                                    label: "فصيلة الدم",
                                    value: provider.newBloodGroup,
                                    items: [
                                      'A+',
                                      'A-',
                                      'B+',
                                      'B-',
                                      'AB+',
                                      'AB-',
                                      'O+',
                                      'O-'
                                    ].map((bloodType) {
                                      return DropdownMenuItem<String>(
                                        value: bloodType,
                                        child: Text(bloodType),
                                      );
                                    }).toList(),
                                    onChanged: (String? newValue) {
                                      provider.setNewBloodGroup(newValue!);
                                    },
                                  )
                                : Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Directionality(
                                      textDirection: TextDirection.rtl,
                                      child: Row(
                                        children: [
                                          Expanded(
                                              child: ReadOnlyTextField(
                                                  label: "فصيلة الدم",
                                                  value:
                                                      userModel.ldBloodGroup)),
                                          provider.newBloodGroup.isNotEmpty
                                              ? SizedBox(
                                                  width: 10,
                                                )
                                              : SizedBox(
                                                  width: 0,
                                                ),
                                          provider.newBloodGroup.isNotEmpty
                                              ? Expanded(
                                                  child: Row(
                                                  children: [
                                                    Expanded(
                                                      child: ReadOnlyTextField(
                                                          label:
                                                              "فصيلة الدم بعد التعديل ",
                                                          value: provider
                                                              .newBloodGroup),
                                                    ),
                                                    IconButton(
                                                        onPressed: () {
                                                          AwesomeDialog(
                                                            context: context,
                                                            dialogType:
                                                                DialogType
                                                                    .warning,
                                                            animType: AnimType
                                                                .rightSlide,
                                                            title:
                                                                "حذف فصيلة الدم المعدله",
                                                            titleTextStyle:
                                                                GoogleFonts.cairo(
                                                                    fontSize:
                                                                        15.sp,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                            descTextStyle:
                                                                GoogleFonts
                                                                    .cairo(
                                                              fontSize: 15.sp,
                                                            ),
                                                            desc:
                                                                "هل انت متاكد من حذف هذا التعديل ؟",
                                                            btnOk: submitButton(
                                                                () {
                                                              print(
                                                                  'Form Submitted');
                                                              provider
                                                                  .setNewBloodGroup(
                                                                      '');
                                                              Navigator.of(
                                                                      context,
                                                                      rootNavigator:
                                                                          true)
                                                                  .pop();
                                                            },
                                                                Text("نعم",
                                                                    style: GoogleFonts.cairo(
                                                                        fontSize:
                                                                            18,
                                                                        color: Colors
                                                                            .white)),
                                                                Color(
                                                                    0xff1d284c)),
                                                            btnCancel: submitButton(
                                                                () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                                Text("الغاء",
                                                                    style: GoogleFonts.cairo(
                                                                        fontSize:
                                                                            18,
                                                                        color: Colors
                                                                            .white)),
                                                                Color(
                                                                    0xffAF9512)),
                                                            btnCancelOnPress:
                                                                () {
                                                              Navigator.of(
                                                                      context,
                                                                      rootNavigator:
                                                                          true)
                                                                  .pop();
                                                            },
                                                          ).show();
                                                        },
                                                        icon: Icon(
                                                          Icons.delete_outline,
                                                          color:
                                                              Colors.deepOrange,
                                                        )),
                                                  ],
                                                ))
                                              : Container(),
                                          CustomEditButton(
                                            onTap: () {
                                              showDropdownDialog(context,
                                                  label: "فصيلة الدم",
                                                  value: provider
                                                      .selectedBloodGroup,
                                                  items: [
                                                    'A+',
                                                    'A-',
                                                    'B+',
                                                    'B-',
                                                    'AB+',
                                                    'AB-',
                                                    'O+',
                                                    'O-'
                                                  ].map((bloodType) {
                                                    return DropdownMenuItem<
                                                        String>(
                                                      value: bloodType,
                                                      child: Text(bloodType),
                                                    );
                                                  }).toList(), onChanged:
                                                      (String? newValue) {
                                                provider.setSelectedBloodGroup(
                                                    newValue!);
                                              }, onConfirm: () {
                                                provider.setNewBloodGroup(
                                                    provider
                                                        .selectedBloodGroup);
                                                Navigator.pop(context);
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                            userModel.ldProviance == 0
                                ? CustomDropdownField(
                                    label: 'المحافظة',
                                    value: provider.selectedProvince,
                                    items: provider.getProvinceDropdownItems(),
                                    onChanged: (value) {
                                      provider.setSelectedProvince(value!);
                                      provider.setNewProvince(
                                          provider.getProvince(value));
                                      provider.onProvinceChanged(value);
                                    },
                                  )
                                : Directionality(
                                    textDirection: TextDirection.rtl,
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Row(
                                        children: [
                                          Expanded(
                                              child: ReadOnlyTextField(
                                                  label: 'المحافظة',
                                                  value: provider.getProvince(
                                                      userModel.ldProviance
                                                          .toString()))),
                                          provider.newProvince.isNotEmpty
                                              ? SizedBox(
                                                  width: 10,
                                                )
                                              : SizedBox(
                                                  width: 0,
                                                ),
                                          provider.newProvince.isNotEmpty
                                              ? Expanded(
                                                  child: Row(
                                                  children: [
                                                    Expanded(
                                                      child: ReadOnlyTextField(
                                                          label:
                                                              "المحافظه بعد التعديل ",
                                                          value: provider
                                                              .newProvince),
                                                    ),
                                                    IconButton(
                                                        onPressed: () {
                                                          AwesomeDialog(
                                                            context: context,
                                                            dialogType:
                                                                DialogType
                                                                    .warning,
                                                            animType: AnimType
                                                                .rightSlide,
                                                            title:
                                                                "حذف المحافظة المعدل",
                                                            titleTextStyle:
                                                                GoogleFonts.cairo(
                                                                    fontSize:
                                                                        15.sp,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                            descTextStyle:
                                                                GoogleFonts
                                                                    .cairo(
                                                              fontSize: 15.sp,
                                                            ),
                                                            desc:
                                                                "هل انت متاكد من حذف هذا التعديل ؟",
                                                            btnOk: submitButton(
                                                                () {
                                                              print(
                                                                  'Form Submitted');
                                                              provider
                                                                  .setNewProvince(
                                                                      '');
                                                              Navigator.of(
                                                                      context,
                                                                      rootNavigator:
                                                                          true)
                                                                  .pop();
                                                            },
                                                                Text("نعم",
                                                                    style: GoogleFonts.cairo(
                                                                        fontSize:
                                                                            18,
                                                                        color: Colors
                                                                            .white)),
                                                                Color(
                                                                    0xff1d284c)),
                                                            btnCancel: submitButton(
                                                                () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                                Text("الغاء",
                                                                    style: GoogleFonts.cairo(
                                                                        fontSize:
                                                                            18,
                                                                        color: Colors
                                                                            .white)),
                                                                Color(
                                                                    0xffAF9512)),
                                                            btnCancelOnPress:
                                                                () {
                                                              Navigator.of(
                                                                      context,
                                                                      rootNavigator:
                                                                          true)
                                                                  .pop();
                                                            },
                                                          ).show();
                                                        },
                                                        icon: Icon(
                                                          Icons.delete_outline,
                                                          color:
                                                              Colors.deepOrange,
                                                        )),
                                                  ],
                                                ))
                                              : SizedBox(
                                                  width: 0,
                                                ),
                                          CustomEditButton(
                                            onTap: () {
                                              showDropdownDialog(context,
                                                  label: 'المحافظة',
                                                  value:
                                                      provider.selectedProvince,
                                                  items: provider.provinces
                                                      .map((province) {
                                                    return DropdownMenuItem(
                                                      value: province[
                                                              'province_id']
                                                          .toString(),
                                                      child: Text(
                                                          province['المحافظة']),
                                                    );
                                                  }).toList(),
                                                  onChanged: (value) {
                                                provider.setSelectedProvince(
                                                    value!);
                                                print(
                                                    'selected province changed');
                                                provider
                                                    .onProvinceChanged(value);
                                                print(provider.judiciaries);
                                              }, onConfirm: () {
                                                provider.setNewProvince(provider
                                                    .getProvince(provider
                                                        .selectedProvince));
                                                Navigator.pop(context);
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                            userModel.ldCity == 0
                                ? CustomDropdownField(
                                    label: 'القضاء',
                                    value: provider.selectedJudiciary,
                                    items:
                                        provider.judiciaries.map((judiciary) {
                                      return DropdownMenuItem(
                                        value:
                                            judiciary['district_ID'].toString(),
                                        child: Text(
                                            judiciary['المدينة او القضاء']),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      provider.setSelectedDistrict(value!);
                                      provider.setNewJudiciary(
                                          provider.getDistrict(value,
                                              provider.selectedProvince));
                                      provider.onJudiciaryChanged(value);
                                    },
                                  )
                                : Directionality(
                                    textDirection: TextDirection.rtl,
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Row(
                                        children: [
                                          Expanded(
                                              child: ReadOnlyTextField(
                                                  label: 'القضاء',
                                                  value: provider.getDistrict(
                                                      userModel.ldCity
                                                          .toString(),
                                                      userModel.ldProviance
                                                          .toString()))),
                                          provider.newJudiciary.isNotEmpty
                                              ? SizedBox(
                                                  width: 10,
                                                )
                                              : SizedBox(
                                                  width: 0,
                                                ),
                                          provider.newJudiciary.isNotEmpty
                                              ? Expanded(
                                                  child: Row(
                                                  children: [
                                                    Expanded(
                                                      child: ReadOnlyTextField(
                                                          label:
                                                              "القضاء بعد التعديل ",
                                                          value: provider
                                                              .newJudiciary),
                                                    ),
                                                    IconButton(
                                                        onPressed: () {
                                                          AwesomeDialog(
                                                            context: context,
                                                            dialogType:
                                                                DialogType
                                                                    .warning,
                                                            animType: AnimType
                                                                .rightSlide,
                                                            title:
                                                                "حذف القضاء المعدل",
                                                            titleTextStyle:
                                                                GoogleFonts.cairo(
                                                                    fontSize:
                                                                        15.sp,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                            descTextStyle:
                                                                GoogleFonts
                                                                    .cairo(
                                                              fontSize: 15.sp,
                                                            ),
                                                            desc:
                                                                "هل انت متاكد من حذف هذا التعديل ؟",
                                                            btnOk: submitButton(
                                                                () {
                                                              print(
                                                                  'Form Submitted');
                                                              provider
                                                                  .setNewJudiciary(
                                                                      '');
                                                              Navigator.of(
                                                                      context,
                                                                      rootNavigator:
                                                                          true)
                                                                  .pop();
                                                            },
                                                                Text("نعم",
                                                                    style: GoogleFonts.cairo(
                                                                        fontSize:
                                                                            18,
                                                                        color: Colors
                                                                            .white)),
                                                                Color(
                                                                    0xff1d284c)),
                                                            btnCancel: submitButton(
                                                                () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                                Text("الغاء",
                                                                    style: GoogleFonts.cairo(
                                                                        fontSize:
                                                                            18,
                                                                        color: Colors
                                                                            .white)),
                                                                Color(
                                                                    0xffAF9512)),
                                                            btnCancelOnPress:
                                                                () {
                                                              Navigator.of(
                                                                      context,
                                                                      rootNavigator:
                                                                          true)
                                                                  .pop();
                                                            },
                                                          ).show();
                                                        },
                                                        icon: Icon(
                                                          Icons.delete_outline,
                                                          color:
                                                              Colors.deepOrange,
                                                        )),
                                                  ],
                                                ))
                                              : SizedBox(
                                                  width: 0,
                                                ),
                                          CustomEditButton(
                                            onTap: () {
                                              print(
                                                  'province id : ${provider.selectedProvince}');
                                              print(
                                                  "districts : ${provider.judiciaries}");
                                              showDropdownDialog(context,
                                                  label: 'القضاء',
                                                  value: provider
                                                      .selectedJudiciary,
                                                  items: provider
                                                      .getJudiciaryDropdownItems(),
                                                  onChanged: (value) {
                                                provider.setSelectedDistrict(
                                                    value!);
                                                provider
                                                    .onJudiciaryChanged(value);
                                              }, onConfirm: () {
                                                provider.setNewJudiciary(
                                                    provider.getDistrict(
                                                        provider
                                                            .selectedJudiciary,
                                                        provider
                                                            .selectedProvince));
                                                Navigator.pop(context);
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                            userModel.ldDistrict == 0
                                ? CustomDropdownField(
                                    label: 'المنطقة',
                                    value: provider.selectedArea,
                                    items: provider.areas.map((area) {
                                      return DropdownMenuItem(
                                        value: area['Neighbor_ID'].toString(),
                                        child: Text(area['المنطقة او الحي']),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      provider.setSelectedArea(value!);
                                      provider.setNewArea(provider.getArea(
                                          value, provider.selectedJudiciary));
                                    },
                                  )
                                : Directionality(
                                    textDirection: TextDirection.rtl,
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Row(
                                        children: [
                                          Expanded(
                                              child: ReadOnlyTextField(
                                                  label: 'المنطقه',
                                                  value: provider.getArea(
                                                      userModel.ldDistrict
                                                          .toString(),
                                                      userModel.ldCity
                                                          .toString()))),
                                          provider.newArea.isNotEmpty
                                              ? Expanded(
                                                  child: Row(
                                                  children: [
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Expanded(
                                                      child: ReadOnlyTextField(
                                                          label:
                                                              "المنطقه بعد التعديل ",
                                                          value:
                                                              provider.newArea),
                                                    ),
                                                    IconButton(
                                                        onPressed: () {
                                                          AwesomeDialog(
                                                            context: context,
                                                            dialogType:
                                                                DialogType
                                                                    .warning,
                                                            animType: AnimType
                                                                .rightSlide,
                                                            title:
                                                                "حذف المنطقة المعدله",
                                                            titleTextStyle:
                                                                GoogleFonts.cairo(
                                                                    fontSize:
                                                                        15.sp,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                            descTextStyle:
                                                                GoogleFonts
                                                                    .cairo(
                                                              fontSize: 15.sp,
                                                            ),
                                                            desc:
                                                                "هل انت متاكد من حذف هذا التعديل ؟",
                                                            btnOk: submitButton(
                                                                () {
                                                              print(
                                                                  'Form Submitted');
                                                              provider
                                                                  .setNewArea(
                                                                      '');
                                                              Navigator.of(
                                                                      context,
                                                                      rootNavigator:
                                                                          true)
                                                                  .pop();
                                                            },
                                                                Text("نعم",
                                                                    style: GoogleFonts.cairo(
                                                                        fontSize:
                                                                            18,
                                                                        color: Colors
                                                                            .white)),
                                                                Color(
                                                                    0xff1d284c)),
                                                            btnCancel: submitButton(
                                                                () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                                Text("الغاء",
                                                                    style: GoogleFonts.cairo(
                                                                        fontSize:
                                                                            18,
                                                                        color: Colors
                                                                            .white)),
                                                                Color(
                                                                    0xffAF9512)),
                                                            btnCancelOnPress:
                                                                () {
                                                              Navigator.of(
                                                                      context,
                                                                      rootNavigator:
                                                                          true)
                                                                  .pop();
                                                            },
                                                          ).show();
                                                        },
                                                        icon: Icon(
                                                          Icons.delete_outline,
                                                          color:
                                                              Colors.deepOrange,
                                                        )),
                                                  ],
                                                ))
                                              : SizedBox(
                                                  width: 0,
                                                ),
                                          CustomEditButton(
                                            onTap: () {
                                              showDropdownDialog(context,
                                                  label: 'المنطقة',
                                                  value: provider.selectedArea,
                                                  items: provider
                                                      .getAreaDropdownItems(),
                                                  onChanged: (value) {
                                                provider
                                                    .setSelectedArea(value!);
                                              }, onConfirm: () {
                                                provider.setNewArea(
                                                    provider.getArea(
                                                        provider.selectedArea,
                                                        provider
                                                            .selectedJudiciary));
                                                Navigator.pop(context);
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Row(
                                children: [
                                  userModel.ldPhoneNo.isNotEmpty
                                      ? CustomEditButton(onTap: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                content: Directionality(
                                                  textDirection:
                                                      TextDirection.rtl,
                                                  child: SizedBox(
                                                    width: 50.w,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 18.0),
                                                      child: Form(
                                                        key: _firstPhoneKey,
                                                        child: TextFormField(
                                                          style:
                                                              GoogleFonts.cairo(
                                                                  fontSize:
                                                                      13.sp),
                                                          controller:
                                                              _firstPhoneNumber,
                                                          keyboardType:
                                                              TextInputType
                                                                  .phone,
                                                          decoration:
                                                              InputDecoration(
                                                            labelStyle:
                                                                GoogleFonts.cairo(
                                                                    fontSize:
                                                                        13.sp),
                                                            prefixIcon:
                                                                const Icon(Icons
                                                                    .phone),
                                                            labelText:
                                                                "رقم هاتف الطالب",
                                                            border:
                                                                OutlineInputBorder(),
                                                          ),
                                                          validator: (value) {
                                                            if (value == null ||
                                                                value.isEmpty) {
                                                              return 'الرجاء إدخال رقم الهاتف';
                                                            }
                                                            if (!RegExp(
                                                                    r'^07[3-9][0-9]{8}$')
                                                                .hasMatch(
                                                                    value)) {
                                                              return 'يرجى إدخال رقم هاتف عراقي صالح';
                                                            }
                                                            return null;
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop(); // Close the dialog
                                                    },
                                                    child: Text('إغلاق'),
                                                  ),
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      var validate =
                                                          _firstPhoneKey
                                                              .currentState!
                                                              .validate();
                                                      if (validate) {
                                                        provider.changeFirstPhoneValue(_firstPhoneNumber.text.trim());
                                                        Navigator.of(context)
                                                            .pop();
                                                      }
                                                      // Close the dialog after confirmation
                                                    },
                                                    child: Text('تأكيد'),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        })
                                      : Container(),
                                  ( userModel.ldPhoneNo.isNotEmpty && _firstPhoneNumber.text!='')
                                      ? Expanded(
                                          child: Row(
                                          children: [
                                            IconButton(
                                                onPressed: () {
                                                  AwesomeDialog(
                                                    context: context,
                                                    dialogType:
                                                        DialogType.warning,
                                                    animType:
                                                        AnimType.rightSlide,
                                                    title:
                                                        "حذف هاتف الطالب المعدل",
                                                    titleTextStyle:
                                                        GoogleFonts.cairo(
                                                            fontSize: 15.sp,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                    descTextStyle:
                                                        GoogleFonts.cairo(
                                                      fontSize: 15.sp,
                                                    ),
                                                    desc:
                                                        "هل انت متاكد من حذف هذا التعديل ؟",
                                                    btnOk: submitButton(() {
                                                      print('Form Submitted');
                                                        setState(() {
                                                          _firstPhoneNumber.clear();
                                                        });
                                                      Navigator.of(context,
                                                              rootNavigator:
                                                                  true)
                                                          .pop();
                                                    },
                                                        Text("نعم",
                                                            style: GoogleFonts
                                                                .cairo(
                                                                    fontSize:
                                                                        18,
                                                                    color: Colors
                                                                        .white)),
                                                        Color(0xff1d284c)),
                                                    btnCancel: submitButton(() {
                                                      Navigator.pop(context);
                                                    },
                                                        Text("الغاء",
                                                            style: GoogleFonts
                                                                .cairo(
                                                                    fontSize:
                                                                        18,
                                                                    color: Colors
                                                                        .white)),
                                                        Color(0xffAF9512)),
                                                    btnCancelOnPress: () {
                                                      Navigator.of(context,
                                                              rootNavigator:
                                                                  true)
                                                          .pop();
                                                    },
                                                  ).show();
                                                },
                                                icon: Icon(
                                                  Icons.delete_outline,
                                                  color: Colors.deepOrange,
                                                )),
                                            Expanded(
                                                child: ReadOnlyTextField(
                                                    label:
                                                        "رقم الهاتف  بعد التعديل",
                                                    value: _firstPhoneNumber.text)),
                                            SizedBox(
                                              width: 10,
                                            ),
                                          ],
                                        )): Container(),
                                  Expanded(
                                    child: Directionality(
                                      textDirection: TextDirection.rtl,
                                      child: TextFormField(
                                        readOnly:
                                            userModel.ldPhoneNo.isNotEmpty,
                                        style:
                                            GoogleFonts.cairo(fontSize: 13.sp),
                                        controller: userModel.ldPhoneNo.isEmpty
                                            ? _firstPhoneNumber
                                            : TextEditingController(
                                                text: userModel.ldPhoneNo[0]
                                                    .toString()),
                                        keyboardType: TextInputType.phone,
                                        decoration: InputDecoration(
                                          labelStyle: GoogleFonts.cairo(
                                              fontSize: 13.sp),
                                          prefixIcon: const Icon(Icons.phone),
                                          labelText: "رقم هاتف الطالب",
                                          border: OutlineInputBorder(),
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'الرجاء إدخال رقم الهاتف';
                                          }
                                          if (!RegExp(r'^07[3-9][0-9]{8}$')
                                              .hasMatch(value)) {
                                            return 'يرجى إدخال رقم هاتف عراقي صالح';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Row(
                                children: [
                                  userModel.ldPhoneNo.length > 1
                                      ? Row(
                                          children: [
                                            CustomEditButton(onTap: () {
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    content: Directionality(
                                                      textDirection:
                                                          TextDirection.rtl,
                                                      child: SizedBox(
                                                        width: 50.w,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  top: 18.0),
                                                          child: Form(
                                                            key:
                                                                _secondPhoneKey,
                                                            child:
                                                                TextFormField(
                                                              style: GoogleFonts
                                                                  .cairo(
                                                                      fontSize:
                                                                          14.sp),
                                                              controller:
                                                                  _secondPhoneNumber,
                                                              keyboardType:
                                                                  TextInputType
                                                                      .phone,
                                                              decoration:
                                                                  InputDecoration(
                                                                labelStyle:
                                                                    GoogleFonts.cairo(
                                                                        fontSize:
                                                                            14.sp),
                                                                prefixIcon:
                                                                    const Icon(Icons
                                                                        .phone),
                                                                labelText:
                                                                    "رقم هاتف ولي الامر",
                                                                border:
                                                                    OutlineInputBorder(),
                                                              ),
                                                              validator:
                                                                  (value) {
                                                                if (value ==
                                                                        null ||
                                                                    value
                                                                        .isEmpty) {
                                                                  return 'الرجاء إدخال رقم الهاتف';
                                                                }
                                                                if (!RegExp(
                                                                        r'^07[3-9][0-9]{8}$')
                                                                    .hasMatch(
                                                                        value)) {
                                                                  return 'يرجى إدخال رقم هاتف عراقي صالح';
                                                                }
                                                                return null;
                                                              },
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop(); // Close the dialog
                                                        },
                                                        child: Text('إغلاق'),
                                                      ),
                                                      ElevatedButton(
                                                        onPressed: () {
                                                          var validate =
                                                              _secondPhoneKey
                                                                  .currentState!
                                                                  .validate();
                                                          if (validate) {
                                                            provider.changeSecondPhoneValue(_secondPhoneNumber.text);
                                                            Navigator.of(
                                                                    context)
                                                                .pop(); // Close the dialog after confirmation
                                                          }
                                                        },
                                                        child: Text('تأكيد'),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            }),
                                          ],
                                        )
                                      : Container(),
                                  ( userModel.ldPhoneNo.length>1 && _secondPhoneNumber.text!='')
                                      ? Expanded(
                                          child: Row(
                                          children: [
                                            IconButton(
                                                onPressed: () {
                                                  AwesomeDialog(
                                                    context: context,
                                                    dialogType:
                                                        DialogType.warning,
                                                    animType:
                                                        AnimType.rightSlide,
                                                    title:
                                                        "حذف هاتف ولي الامر المعدل",
                                                    titleTextStyle:
                                                        GoogleFonts.cairo(
                                                            fontSize: 15.sp,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                    descTextStyle:
                                                        GoogleFonts.cairo(
                                                      fontSize: 15.sp,
                                                    ),
                                                    desc:
                                                        "هل انت متاكد من حذف هذا التعديل ؟",
                                                    btnOk: submitButton(() {
                                                      print('Form Submitted');
                                                     setState(() {
                                                       _secondPhoneNumber.clear();
                                                     });
                                                      Navigator.of(context,
                                                              rootNavigator:
                                                                  true)
                                                          .pop();
                                                    },
                                                        Text("نعم",
                                                            style: GoogleFonts
                                                                .cairo(
                                                                    fontSize:
                                                                        18,
                                                                    color: Colors
                                                                        .white)),
                                                        Color(0xff1d284c)),
                                                    btnCancel: submitButton(() {
                                                      Navigator.pop(context);
                                                    },
                                                        Text("الغاء",
                                                            style: GoogleFonts
                                                                .cairo(
                                                                    fontSize:
                                                                        18,
                                                                    color: Colors
                                                                        .white)),
                                                        Color(0xffAF9512)),
                                                    btnCancelOnPress: () {
                                                      Navigator.of(context,
                                                              rootNavigator:
                                                                  true)
                                                          .pop();
                                                    },
                                                  ).show();
                                                },
                                                icon: Icon(
                                                  Icons.delete_outline,
                                                  color: Colors.deepOrange,
                                                )),
                                            Expanded(
                                                child: ReadOnlyTextField(
                                                    label:
                                                        "رقم الهاتف بعد التعديل",
                                                    value: _secondPhoneNumber.text)),
                                            SizedBox(
                                              width: 10,
                                            )
                                          ],
                                        ))
                                      : Container(),
                                  Expanded(
                                    child: Directionality(
                                      textDirection: TextDirection.rtl,
                                      child: TextFormField(
                                        readOnly:
                                            userModel.ldPhoneNo.length > 1,
                                        style:
                                            GoogleFonts.cairo(fontSize: 13.sp),
                                        controller:
                                            userModel.ldPhoneNo.length <= 1
                                                ? _secondPhoneNumber
                                                : TextEditingController(
                                                    text: userModel.ldPhoneNo[1]
                                                        .toString()),
                                        keyboardType: TextInputType.phone,
                                        decoration: InputDecoration(
                                          labelStyle: GoogleFonts.cairo(
                                              fontSize: 13.sp),
                                          prefixIcon: const Icon(Icons.phone),
                                          labelText: "رقم هاتف ولي الامر",
                                          border: OutlineInputBorder(),
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'الرجاء إدخال رقم الهاتف';
                                          }
                                          if (!RegExp(r'^07[3-9][0-9]{8}$')
                                              .hasMatch(value)) {
                                            return 'يرجى إدخال رقم هاتف عراقي صالح';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 20),
                            submitButton(
                                _image != null
                                    ? () {
                                        if (_formKey.currentState!.validate()) {
                                          if (provider.newProvince != '' &&
                                                  provider.selectedProvince !=
                                                      userModel.ldProviance
                                                          .toString() &&
                                                  provider.newJudiciary ==
                                                      '') {
                                            showTopSnackBar(
                                                context,
                                                'قم بتعديل القضاء ايضا',
                                                Colors.white,
                                                Colors.red,
                                                Icons.warning);
                                          }else if(provider.newJudiciary != '' &&
                                              provider.newArea == ''){

                                            showTopSnackBar(
                                                context,
                                                'قم بتعديل المنطقة كذلك',
                                                Colors.white,
                                                Colors.red,
                                                Icons.warning);
                                          }

                                          else {
                                            AwesomeDialog(
                                              context: context,
                                              dialogType: DialogType.warning,
                                              animType: AnimType.rightSlide,
                                              title: "ارسال البيانات",
                                              titleTextStyle: GoogleFonts.cairo(
                                                  fontSize: 15.sp,
                                                  fontWeight: FontWeight.bold),
                                              descTextStyle: GoogleFonts.cairo(
                                                fontSize: 15.sp,
                                              ),
                                              desc:
                                                  "هذه الخطوه غير قابله للتعديل هل انت متاكد من صحة المعلومات ؟",
                                              btnOk: submitButton(() {
                                                print('Form Submitted');
                                                handleSubmit(
                                                    context, userModel);
                                              },
                                                  Text("نعم",
                                                      style: GoogleFonts.cairo(
                                                          fontSize: 18,
                                                          color: Colors.white)),
                                                  Color(0xff1d284c)),
                                              btnCancel: submitButton(() {
                                                Navigator.pop(context);
                                              },
                                                  Text("الغاء",
                                                      style: GoogleFonts.cairo(
                                                          fontSize: 18,
                                                          color: Colors.white)),
                                                  Color(0xffAF9512)),
                                              btnCancelOnPress: () {
                                                Navigator.of(context,
                                                        rootNavigator: true)
                                                    .pop();
                                              },
                                            ).show();
                                          }
                                          // Handle form submission
                                        }
                                      }
                                    : null,
                                Text("ارسال البيانات",
                                    style: GoogleFonts.cairo(
                                        fontSize: 18, color: Colors.white)),
                                _image != null
                                    ? Color(0xff1d284c)
                                    : Colors.grey),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }
            }),
      ),
    );
  }

  void showLoadingOverlay(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing by tapping outside
      builder: (context) {
        return WillPopScope(
          onWillPop: () async => false, // Disable back button
          child: Scaffold(
            backgroundColor: Colors.black54.withAlpha(50),
            body: Stack(
              children: [
                ModalBarrier(
                    dismissible: false, color: Colors.black.withOpacity(0.5)),
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(
                          color: Color(0xffAF9512)), // Loading spinner
                      SizedBox(height: 10),
                      Container(
                        child: Text(
                          "يرجى الانتظار...",
                          style: GoogleFonts.cairo(
                              fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void handleSubmit(
    BuildContext context,
    UserModel userModel,
  ) async {
    var provider = Provider.of<MyProvider>(context, listen: false);
    Navigator.pop(context); // Close the confirmation dialog
    showLoadingOverlay(context); // Show full-screen loading overlay
    String message = await updateStudentInformation(
        userModel,
        provider.newProvince,
        provider.newJudiciary,
        provider.newArea,
        provider.newBloodGroup,
        provider.newBirthDay,
        _firstPhoneNumber.text.trim(),
        _secondPhoneNumber.text.trim());
    if (message == "success") {
      context.go("/success");
    } else {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.rightSlide,
        title: "حدث خطآ ما",
        titleTextStyle:
            GoogleFonts.cairo(fontSize: 15.sp, fontWeight: FontWeight.bold),
        descTextStyle: GoogleFonts.cairo(
          fontSize: 15.sp,
        ),
        desc: message,
        btnCancel: submitButton(() {
          Navigator.pop(context);
        },
            Text("حسنا",
                style: GoogleFonts.cairo(fontSize: 18, color: Colors.white)),
            Color(0xffAF9512)),
        btnCancelOnPress: () {
          Navigator.of(context, rootNavigator: true).pop();
        },
      ).show();
    }
  }

  Widget submitButton(Function()? fun, Widget widget, Color color) {
    return SizedBox(
      width: double.infinity,
      height: 40,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(color),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          ),
        ),
        onPressed: fun,
        child: widget,
      ),
    );
  }
}
