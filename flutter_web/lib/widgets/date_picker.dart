import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart' as picker;
import 'package:google_fonts/google_fonts.dart';
import 'package:nust_students/controller/my_provider.dart';
import 'package:nust_students/models/usermodel.dart';
import 'package:nust_students/widgets/custom_edit_button.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../utls/date_picker_dialog.dart';
import '../utls/formate_date_of_birth.dart';

class CustomDatePicker extends StatefulWidget {
  final UserModel userModel;
  final bool isReadOnly;
  const CustomDatePicker(
      {super.key, required this.userModel, required this.isReadOnly});

  @override
  _CustomDatePickerState createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var provider=Provider.of<MyProvider>(context);
    return Row(
      children: [
        widget.isReadOnly
            ? CustomEditButton(onTap:(){
              showDatePickerDialog(context, widget.userModel, false);
            }
            )
            : Container(),
         provider.newBirthDay.isNotEmpty&&widget.isReadOnly
              ? Expanded(
                  child: Row(
                    children: [
                      IconButton(onPressed: (){
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.warning,
                          animType: AnimType.rightSlide,
                          title: "حذف تاريخ الميلاد المعدل",
                          titleTextStyle: GoogleFonts.cairo(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.bold),
                          descTextStyle: GoogleFonts.cairo(
                            fontSize: 15.sp,
                          ),
                          desc:
                          "هل انت متاكد من حذف هذا التعديل ؟",
                          btnOk: submitButton(() {
                            print('Form Submitted');
                            provider.setNewBirthDay('');
                            Navigator.of(context,
                                rootNavigator: true)
                                .pop();
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
                      }, icon: Icon(Icons.delete_outline,color: Colors.deepOrange,)),
                      Expanded(
                        child: SizedBox(
                          height: 6.h,
                          child: GestureDetector(
                            onTap: null,
                            child: AbsorbPointer(
                              child: Directionality(
                                textDirection: TextDirection.rtl,
                                child: TextField(
                                  style: TextStyle(fontSize: 13.sp),
                                  controller: TextEditingController()
                                    ..text = provider.newBirthDay,
                                  decoration: InputDecoration(
                                    labelText: "تاريخ الميلادالمعدل ",
                                    labelStyle: GoogleFonts.cairo(fontSize: 13.sp),
                                    prefixIcon: Icon(Icons.calendar_today,
                                        color: Color(0xffAA9516)),
                                    border: OutlineInputBorder(),
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 15),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : Container(),
        SizedBox(width: provider.newBirthDay.isNotEmpty&&widget.isReadOnly?10:0,),
        Expanded(
          child: SizedBox(
            height: 6.h,
            child: GestureDetector(
              onTap: widget.isReadOnly
                  ? null
                  : () {
                      // Show Date Picker (only date, no time)
                      picker.DatePicker.showDatePicker(
                        context,
                        showTitleActions: true,
                        theme: picker.DatePickerTheme(
                          headerColor: Color(0xffAF9512),
                          backgroundColor: Color(0xff1d284c),
                          itemStyle: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 13.sp),
                          doneStyle:
                              TextStyle(color: Colors.white, fontSize: 13.sp),
                        ),
                        minTime: DateTime(1900, 1, 1),
                        maxTime: DateTime(2100, 12, 31),
                        onChanged: (date) {
                          print('change $date');
                        },
                        onConfirm: (date) {
                          setState(() {
                            // Format the date to show only year, month, and day
                            _controller.text =
                                "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
                            provider.setNewBirthDay(
                                "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}");
                          });

                          print('confirm $date');
                        },
                        currentTime: DateTime.now(),
                        locale: picker.LocaleType.en,
                      );
                    },
              child: AbsorbPointer(
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: TextField(
                    controller: widget.isReadOnly
                        ? TextEditingController(
                            text: formattedDate(
                                widget.userModel.ldDateOfBirth.toString()))
                        : _controller,
                    style: TextStyle(fontSize: 13.sp),
                    decoration: InputDecoration(
                      labelText: "تاريح الميلاد",
                      labelStyle: GoogleFonts.cairo(fontSize: 13.sp),
                      prefixIcon: Icon(
                        Icons.calendar_today,
                        color: Color(0xffAF9512),
                      ),
                      border: OutlineInputBorder(),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
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
