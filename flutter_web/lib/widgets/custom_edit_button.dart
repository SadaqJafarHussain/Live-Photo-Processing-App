import'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class CustomEditButton extends StatelessWidget {
  final VoidCallback onTap;
  const CustomEditButton({super.key,required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 6.h,
          padding: EdgeInsets.symmetric(vertical: 3, horizontal: 5),
          decoration: BoxDecoration(
            border: Border.all(
              color: Color(0xff1d284c),
            ),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Row(
              children: [
                Icon(
                  Icons.edit_note_outlined,
                  color: Color(0xffAF9512),
                ),
                Text(
                  'تعديل',
                  style: GoogleFonts.cairo(fontSize: 12.sp),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
