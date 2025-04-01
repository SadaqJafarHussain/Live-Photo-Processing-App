import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import 'dart:html' as html;

class SuccessPage extends StatefulWidget {
  const SuccessPage({super.key});

  @override
  State<SuccessPage> createState() => _SuccessPageState();
}

class _SuccessPageState extends State<SuccessPage> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    html.window.onPopState.listen((event) {
      if (mounted) {
        // Force refresh when navigating back using browser back button
        html.window.location.reload(); // This forces a page reload when navigating back.
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 430,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                elevation: 2,
                color: Color(0xffFFFFFF),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min, // Ensures the Column height matches its children
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.check_circle, // Right check icon
                        color: Colors.green,
                        size: 25.sp,
                      ),
                      SizedBox(height: 10), // Spacer between icon and text
                      Text(
                        "تم إرسال بياناتك بنجاح!", // The success message
                        style: GoogleFonts.cairo(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      Text(
                        "هويتك الجامعية قيد الطباعة", // The success message
                        style: GoogleFonts.cairo(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        '.لمزيد من المعلومات متابعة القنوات الرسمية للتليجرام الخاصة بالجامعة\nحيث سيتم الإعلان عن أسماء الطلاب الذين تم طباعة هوياتهم \nوفي  حال وجود مشكلة مراجعة قسم تكنولوجيا المعلومات\n نتمنى لك التوفيق والنجاح في مسيرتك الأكاديمية', // The success message
                        style: GoogleFonts.cairo(
                          fontSize: 11.sp,
                          color: Colors.black54,
                          wordSpacing: 2,
                          fontWeight: FontWeight.w600
                        ),
                        textDirection: TextDirection.rtl,
                        textAlign: TextAlign.center,
                        softWrap: true,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20,),
              Text(': قنوات التليكرام', style: GoogleFonts.cairo(
                  fontSize: 12.sp,
                  color: Colors.black54,
                  wordSpacing: 2,
                  fontWeight: FontWeight.bold
              ),),
              SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: (){
                      const String webAppUrl = "https://t.me/nustofficial";
                      html.window.location.assign(webAppUrl);
                    },
                      child: Column(
                        children: [
                          Icon(Icons.telegram,size: 40,color: Colors.blue,),
                          Text('@nustofficial', style: GoogleFonts.cairo(
                              fontSize: 10.sp,
                              color: Colors.blue,
                              wordSpacing: 2,
                              fontWeight: FontWeight.w600
                          ),),
                        ],
                      )),
                  SizedBox(width: 20,),

                  InkWell(
                      onTap: (){
                        const String webAppUrl = "https://t.me/NUSTACCOUNTS";
                        html.window.location.assign(webAppUrl);
                      },
                      child: Column(
                        children: [
                          Icon(Icons.telegram,size: 40,color: Colors.blue,),
                          Text('@NUSTACCOUNTS', style: GoogleFonts.cairo(
                              fontSize: 10.sp,
                              color: Colors.blue,
                              wordSpacing: 2,
                              fontWeight: FontWeight.w600
                          ),),
                        ],
                      )),
                  SizedBox(width: 20,),

                  InkWell(
                      onTap: (){
                        const String webAppUrl = "https://t.me/Nust6";
                        html.window.location.assign(webAppUrl);
                      },
                      child: Column(
                        children: [
                          Icon(Icons.telegram,size: 40,color: Colors.blue,),
                          Text('@Nust6', style: GoogleFonts.cairo(
                              fontSize: 10.sp,
                              color: Colors.blue,
                              wordSpacing: 2,
                              fontWeight: FontWeight.w600
                          ),),
                        ],
                      )),

                ],
              ),
              SizedBox(height: 20,),
               Container(
                 height: 1,
                 width: 300,
                 color: Colors.grey,
               ),
              SizedBox(height: 10,),
              Text(': المواقع الرسمية', style: GoogleFonts.cairo(
                  fontSize: 12.sp,
                  color: Colors.black54,
                  wordSpacing: 2,
                  fontWeight: FontWeight.bold
              ),),
              SizedBox(height: 23,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                      onTap: (){
                        const String webAppUrl = "https://t.me/nustofficial";
                        html.window.location.assign(webAppUrl);
                      },
                      child: Column(
                        children: [
                          Container(
                              child: Image.asset("assets/www.png",height:20.sp)),

                        ],
                      )),
                  SizedBox(width: 20,),
                  InkWell(
                      onTap: (){
                        const String webAppUrl = "https://www.facebook.com/share/1AMG1FMt79/?mibextid=wwXIfr";
                        html.window.location.assign(webAppUrl);
                      },
                      child: Column(
                        children: [
                          Icon(Icons.facebook,size: 22.sp,color: Colors.blue,),

                        ],
                      )),
                  SizedBox(width: 20,),
                  InkWell(
                      onTap: (){
                        const String webAppUrl = "https://www.instagram.com/alwatnya_university?igsh=MWJ5aGh2cWliM3Bjag==";
                        html.window.location.assign(webAppUrl);
                      },
                      child: Column(
                        children: [
                          Container(
                              child: Image.asset("assets/insta.png",height:20.sp)),

                        ],
                      )),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}