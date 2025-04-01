import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class DialogHelper {
  static void showSuccessDialog({
    required BuildContext context,
    required String title,
    required String description,
    required VoidCallback onConfirm,
  }) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.success,
      animType: AnimType.rightSlide,
      title: title,
      titleTextStyle: GoogleFonts.cairo(fontSize: 15.sp, fontWeight: FontWeight.bold),
      descTextStyle: GoogleFonts.cairo(fontSize: 15.sp),
      desc: description,
      btnOk: _submitButton(onConfirm, "موافق", const Color(0xff1d284c)),
      btnCancel: _submitButton(() => Navigator.pop(context), "إلغاء", const Color(0xffAF9512)),
      btnCancelOnPress: () => Navigator.of(context, rootNavigator: true).pop(),
      btnOkOnPress: onConfirm,
    ).show();
  }

  static void showErrorDialog({
    required BuildContext context,
    required String title,
    required String description,
    required DialogType type,
  }) {
    AwesomeDialog(
      context: context,
      dialogType: type,
      animType: AnimType.bottomSlide,
      title: title,
      titleTextStyle: GoogleFonts.cairo(fontSize: 15.sp, fontWeight: FontWeight.bold),
      descTextStyle: GoogleFonts.cairo(fontSize: 15.sp),
      desc: description,
      btnOk: _submitButton(() => Navigator.pop(context), "حسناً", const Color(0xffAF9512)),
      btnOkOnPress: () {},
    ).show();
  }

  static Widget _submitButton(VoidCallback onPressed, String label, Color color) {
    return SizedBox(
      width: double.infinity,
      height: 40,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(color),
          shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
        ),
        onPressed: onPressed,
        child: Text(label, style: GoogleFonts.cairo(fontSize: 14.sp, color: Colors.white)),
      ),
    );
  }
}
