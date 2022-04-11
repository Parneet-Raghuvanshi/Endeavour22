import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';

// SERVER URL
const serverURL = 'http://protected-chamber-92948.herokuapp.com';
//const serverURL = 'http://10.0.2.2:7000';
//const serverURL = 'http://192.168.171.231:7000';
//const serverURL = 'http://192.168.0.142:7000';

// COLORS
const kLayer1Color = Color(0xFF00CC8E);
const kLayer2Color = Color(0xFF00BD8B);
const kLayer3Color = Color(0xFF00AE87);
const kLayer4Color = Color(0xFF00A081);
const kLayer5Color = Color(0xFF00917B);
const kLayer6Color = Color(0xFF038373);

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
