import 'dart:convert';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nust_students/widgets/dialog_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart' as intl;
import 'package:awesome_dialog/awesome_dialog.dart';
import 'dart:html' as html;

class LoginView extends StatefulWidget {
  const LoginView({super.key});
  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  TextEditingController examNumber = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
bool loading =false;
  @override
  void dispose() {
    examNumber.dispose();
    phoneController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: false,
          body: LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 600) {
                return _buildLargeScreen(size);
              } else {
                return _buildSmallScreen(size);
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildLargeScreen(Size size) {
    return Row(
      children: [
        SizedBox(width: size.width * 0.06),
        Expanded(
          flex: 4,
          child: Image.asset("assets/logo.jpg"),
        ),
        SizedBox(width: size.width * 0.06),
        Expanded(flex: 5, child: _buildMainBody(size)),
      ],
    );
  }

  Widget _buildSmallScreen(Size size) {
    return Center(child: _buildMainBody(size));
  }

  Widget _buildMainBody(Size size) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: size.width > 600 ? MainAxisAlignment.center : MainAxisAlignment.start,
        children: [
          size.width > 600
              ? Container()
              : Stack(
                children: [
                  Lottie.asset(
                   'assets/wave.json',
                    height: size.height * 0.2,
                    width: size.width,
                    fit: BoxFit.fill,
                      ),
                  Center(child: Image.asset("assets/logo.jpg",height: size.height * 0.2,)),
                ],
              ),
          SizedBox(height: size.height * 0.03),
          Text('تسجيل الدخول', style: GoogleFonts.cairo(fontSize: 24, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Text('اهلا وسهلا بكم في الجامعة الوطنية للعلوم والتكنلوجيا', style: GoogleFonts.cairo(fontSize: 18, color: Colors.grey)),
          SizedBox(height: size.height * 0.03),
          Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  style: GoogleFonts.cairo(),
                  decoration:  InputDecoration(
                    prefixIcon: Icon(Icons.person),
                    labelStyle: GoogleFonts.cairo(),
                    labelText: "الرقم الامتحاني",
                    border: OutlineInputBorder(),
                  ),
                  controller: examNumber,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'الرجاء إدخال الرقم الامتحاني';
                    } else if (value.length < 4) {
                      return 'الرقم قصير جدا';
                    }
                    return null;
                  },
                ),
                SizedBox(height: size.height * 0.02),
                TextFormField(
                  style: GoogleFonts.cairo(),
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelStyle: GoogleFonts.cairo(),
                    prefixIcon: const Icon(Icons.phone),
                    labelText: "رقم الهاتف المضاف اثناء تسجيل الطلبة",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'الرجاء إدخال رقم الهاتف';
                    }
                    if (!RegExp(r'^07[3-9][0-9]{8}$').hasMatch(value)) {
                      return 'يرجى إدخال رقم هاتف عراقي صالح';
                    }
                    return null;
                  },
                ),

                SizedBox(height: size.height * 0.02),
                loginButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }
  String getTimestamp() {
    // Get current time
    DateTime now = DateTime.now();
    // Format the time using the DateFormat class from the intl package
    String timeStamp = intl.DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
    return timeStamp;
  }

  Future<String> updateUnregistered() async {
    setState(() { loading=true; });
    String timestamp = getTimestamp(); // Get the timestamp
    print(timestamp); // Print timestamp for debugging
try{
  final url = "Your-Login-API";
  var response = await http.post(
    Uri.parse(url),
    headers: {
      "Accept": "application/json",
      "Content-Type": "application/json",
    },
    body: jsonEncode({
      "first-parameter": phoneController.text.trim().substring(1),
      "second-parameter": examNumber.text.trim(),
    }),
  );
  var decodedData=jsonDecode(response.body);
  if (decodedData['ldStatus']>=0) {
    setState(() { loading=false; });
    print("Success: ${response.body}");
    var jsonData = jsonDecode(response.body);
    await saveUser(jsonData);
    print("user saved oooooooooo");
  return 'success';
  } else {
    setState(() {loading=false;});

   return decodedData['ldStatus'].toString() ;

    }

}catch(e){
  setState(() {loading=false;});
 return e.toString();
}
  }
  Widget submitButton(VoidCallback fun,String label,Color color) {
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
        onPressed:fun,
        child: Text(label, style: GoogleFonts.cairo(fontSize: 18, color: Colors.white)),
      ),
    );
  }

  Widget loginButton() {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(Color(0xff1d284c)),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          ),
        ),
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            // Replace with your React web app URL
           String result=await updateUnregistered();
           if(result=='success') {
             DialogHelper.showSuccessDialog(
               context: context,
               title: "تم تسجيل الدخول بنجاح",
               description:
               "سوف يتم تحويلك الى صفحة التقاط صورة الهوية بشكل مباشر.\n إذا كنت مستعدًا اضغط موافق أو اضغط إلغاء للدخول لاحقًا.",
               onConfirm: () {
                handleSubmit(context);
               },
             );
           }
           else if(result=='-2'||result=='-1'){
             DialogHelper.showErrorDialog(
               type: DialogType.error,
               context: context, title: 'خطا في تسجيل الدخول',
               description: "تاكد من إدخال الرقم الامتحاني ورقم الهاتف بشكل صحيح",
             );
           }
           else if(result=='-3'){
             DialogHelper.showErrorDialog(
               type: DialogType.infoReverse,
               context: context, title: 'تم تحديث بياناتك',
               description: "صورة الهويه ومعلوماتك محدثه بالفعل ، لغرض تعديلها قم بمراجعة قسم تكنولوجيا المعلومات",
             );
           }else{
             DialogHelper.showErrorDialog(
               type: DialogType.error,
               context: context, title: 'خطا في تسجيل الدخول',
               description: 'لايمكن الوصول للسيرفر',
             );
           }
          }
        },
        child:loading?Center(child: CircularProgressIndicator(
          color: Color(0xffAF9512),
        )): Text('تسجيل الدخول', style: GoogleFonts.cairo(fontSize: 16, color: Colors.white)),
      ),
    );
  }

  Future<void> saveUser(Map<String,dynamic> user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('user_data', jsonEncode(user));

  }
  void handleSubmit(BuildContext context) async {
    Navigator.pop(context); // Close the confirmation dialog
    showLoadingOverlay(context); // Show full-screen loading overlay
       const String webAppUrl = "Your-React-Web-URL";
       html.window.location.assign(webAppUrl);
      // context.go("/capture");
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
                ModalBarrier(dismissible: false, color: Colors.black.withOpacity(0.5)),
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(color: Color(0xffAF9512)), // Loading spinner
                      SizedBox(height: 10),
                      Container(
                        child: Text(
                          "يرجى الانتظار...",
                          style: GoogleFonts.cairo(fontSize: 18, color: Colors.white),
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

}
