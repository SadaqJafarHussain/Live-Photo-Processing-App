import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class CustomDropdownField extends StatelessWidget {
  final String label;
  final String? value;
  final List<DropdownMenuItem<String>> items;
  final ValueChanged<String?> onChanged;

  const CustomDropdownField({
    Key? key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Directionality(
        textDirection: TextDirection.rtl, // Ensure RTL for Arabic
        child: DropdownButtonFormField<String>(
          value: value!.isNotEmpty ? value : null, // Prevents empty string issues
          decoration: InputDecoration(
            label: Text(label,style: GoogleFonts.cairo(fontSize: 14.sp, color: Colors.grey),),
            hintText: 'اختر $label',
            hintStyle: GoogleFonts.cairo(fontSize: 14.sp, color: Colors.grey),
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
            errorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
            focusedErrorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
            errorStyle: TextStyle(color: Colors.red, fontSize: 12),
          ),
          style: GoogleFonts.cairo(fontSize: 15.sp),
          items: items,
          onChanged: onChanged,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'الرجاء اختيار $label';
            }
            return null;
          },
        ),
      ),
    );
  }
}
