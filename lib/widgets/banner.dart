import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget buildBanner(
    {required Widget child, required int oldP, required int newP}) {
  final perc = 100 - ((newP / oldP) * 100).toInt();
  final rotateRight = AlwaysStoppedAnimation(45 / 350);
  return Stack(
    children: [
      child,
      Positioned(
        right: -40.w,
        top: 18.w,
        width: 128.w,
        height: 20.w,
        child: RotationTransition(
          turns: rotateRight,
          child: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6.0,
                  offset: Offset(0, 3),
                ),
              ],
              color: Colors.orangeAccent,
            ),
            padding: EdgeInsets.symmetric(horizontal: 40.w),
            alignment: Alignment.center,
            child: FittedBox(
              child: Text(
                '$perc% off',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                ),
              ),
            ),
          ),
        ),
      )
    ],
  );
}
