import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class ReadOnlyTextField extends StatelessWidget {
  final String label;
  final String value;

  const ReadOnlyTextField({
    Key? key,
    required this.label,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl, // Ensures RTL for Arabic
      child: TextFormField(
        readOnly: true,
        style: GoogleFonts.cairo(fontSize: 13.sp),
        controller: TextEditingController(text: value),
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(
          labelStyle: GoogleFonts.cairo(fontSize: 13.sp),
          labelText: label,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}
