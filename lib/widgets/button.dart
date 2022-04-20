import 'package:endeavour22/helper/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget buildButton({
  required String name,
  required double width,
  double h = 0,
  bool isGreen = false,
}) {
  return Container(
    decoration: BoxDecoration(
      color: isGreen ? Colors.green : kPrimaryMid,
      borderRadius: BorderRadius.circular(16),
      boxShadow: const [
        BoxShadow(
          color: Colors.black12, //New
          blurRadius: 10.0,
          offset: Offset(0.5, 0.5),
        ),
      ],
    ),
    alignment: Alignment.center,
    padding: EdgeInsets.symmetric(horizontal: 16.w),
    width: width,
    height: h == 0 ? 36.h : h,
    child: Text(
      name,
      style: TextStyle(
        fontSize: 16.sp,
        color: Colors.white,
      ),
    ),
  );
}
