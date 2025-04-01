import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart' as picker;
import 'package:google_fonts/google_fonts.dart';
import 'package:nust_students/controller/my_provider.dart';
import 'package:nust_students/models/usermodel.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../utls/formate_date_of_birth.dart';

class CustomDatePickerDialog extends StatefulWidget {
  final UserModel userModel;
  final bool isReadOnly;

  const CustomDatePickerDialog({super.key, required this.userModel, required this.isReadOnly});

  @override
  _CustomDatePickerDialogState createState() => _CustomDatePickerDialogState();
}

class _CustomDatePickerDialogState extends State<CustomDatePickerDialog> {
  final TextEditingController _controller = TextEditingController();


  @override
  void initState() {
    super.initState();
    _controller.text = formattedDate(widget.userModel.ldDateOfBirth.toString());
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        "اختر تاريخ الميلاد",
        textAlign: TextAlign.center,
        style: GoogleFonts.cairo(fontSize: 14.sp, fontWeight: FontWeight.bold),
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 6.h,
              child: GestureDetector(
                onTap: widget.isReadOnly
                    ? null
                    : () {
                  picker.DatePicker.showDatePicker(
                    context,
                    showTitleActions: true,
                    theme: picker.DatePickerTheme(
                      headerColor: Color(0xffAF9512),
                      backgroundColor: Color(0xff1d284c),
                      itemStyle: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                      doneStyle: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    minTime: DateTime(1900, 1, 1),
                    maxTime: DateTime(2100, 12, 31),
                    onChanged: (date) {
                      print('change $date');
                    },
                    onConfirm: (date) {
                      setState(() {
                        _controller.text =
                        "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
                      });
                    },
                    currentTime: DateTime.now(),
                    locale: picker.LocaleType.en,
                  );
                },
                child: AbsorbPointer(
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        labelText: "تاريح الميلاد",
                        labelStyle: GoogleFonts.cairo(fontSize: 12.sp),
                        prefixIcon: Icon(
                          Icons.calendar_today,
                          color: Color(0xffAF9512),
                        ),
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text("إلغاء", style: GoogleFonts.cairo(fontSize: 12.sp)),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context, _controller.text);
          },
          child: Text("تأكيد", style: GoogleFonts.cairo(fontSize: 12.sp, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}

// Function to show the date picker dialog
Future<void> showDatePickerDialog(BuildContext context, UserModel userModel, bool isReadOnly) async {
 final provider =Provider.of<MyProvider>(context,listen: false);

  String? selectedDate = await showDialog<String>(
    context: context,
    builder: (context) => CustomDatePickerDialog(userModel: userModel, isReadOnly: isReadOnly),
  );

  if (selectedDate != null) {
    provider.setNewBirthDay(selectedDate);
    print(provider.newBirthDay);
  }
}
