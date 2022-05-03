import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

// SERVER URL
const String serverURL = 'http://13.235.45.183:7000';
const String razorpayApi = 'rzp_live_sFxvVilfPtmghi';

// NEW COLORS
const kPrimaryLight = Color(0xFF0493BA);
const kPrimaryMid = Color(0xFF026B90);
const kPrimaryDark = Color(0xFF003b5c);
const kPrimaryTrans = Color(0x1A0493BA);

Widget comingSoon() {
  return Container(
    alignment: Alignment.center,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset(
          'assets/images/coming_soon.svg',
          height: 200.w,
          width: 200.w,
          fit: BoxFit.cover,
        ),
        SizedBox(height: 24.w),
        Text(
          'Coming Soon...',
          style: TextStyle(fontSize: 16.sp),
        ),
      ],
    ),
  );
}
