import"package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:nust_students/widgets/custom_drop_down_widget.dart";
import "package:sizer/sizer.dart";

void showDropdownDialog(BuildContext context, {
  required String label,
  required String? value,
  required List<DropdownMenuItem<String>> items,
  required ValueChanged<String?> onChanged,
  required VoidCallback onConfirm,
}) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Directionality(
            textDirection: TextDirection.rtl,
            child: Text("اختر $label", style: GoogleFonts.cairo(fontSize: 13.sp))),
        content: SizedBox(
          width: 60.w,
          child: CustomDropdownField(
            label: label,
            value: value,
            items: items,
            onChanged: onChanged,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("إلغاء", style: GoogleFonts.cairo(fontSize: 12.sp)),
          ),
          TextButton(
            onPressed: onConfirm,
            child: Text("تأكيد", style: GoogleFonts.cairo(fontSize: 12.sp, fontWeight: FontWeight.bold)),
          ),
        ],
      );
    },
  );
}
