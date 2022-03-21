import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomSnackbar {
  void showFloatingFlushBar({
    required BuildContext context,
    required String message,
    String title = '',
    required Color color,
  }) {
    Flushbar(
      duration: const Duration(seconds: 3),
      margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      flushbarPosition: FlushbarPosition.TOP,
      borderRadius: const BorderRadius.all(Radius.circular(8)),
      backgroundColor: color,
      boxShadows: const [
        BoxShadow(
          color: Colors.black45,
          offset: Offset(3, 3),
          blurRadius: 3,
        ),
      ],
      dismissDirection: FlushbarDismissDirection.HORIZONTAL,
      animationDuration: const Duration(milliseconds: 500),
      forwardAnimationCurve: Curves.fastLinearToSlowEaseIn,
      title: title.isEmpty ? null : title,
      message: message,
    ).show(context);
  }
}
