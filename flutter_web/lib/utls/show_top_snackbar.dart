import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

void showTopSnackBar(BuildContext context, String message,Color backColor,Color forColor,IconData icon) {
  final overlay = Overlay.of(context);
  final overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      top: MediaQuery.of(context).padding.top + 20, // Adjust based on status bar
      left: 50,
      right: 50,
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
          decoration: BoxDecoration(
            color: backColor, // Background color
            borderRadius: BorderRadius.circular(12), // Rounded corners
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color:forColor),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  message,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.cairo(color:forColor, fontSize: 16.sp),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );

  // Insert the overlay
  overlay.insert(overlayEntry);

  // Remove it after 3 seconds
  Future.delayed(Duration(seconds: 4), () {
    overlayEntry.remove();
  });
}