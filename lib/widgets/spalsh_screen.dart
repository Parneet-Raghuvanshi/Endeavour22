import 'package:endeavour22/helper/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: 640.h,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              kPrimaryLight,
              kPrimaryDark,
            ],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              left: -180.w,
              width: 720.w,
              top: 280.h,
              child: Center(
                child: Text(
                  'Launching...',
                  style: TextStyle(
                    fontSize: 24.sp,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Positioned(
              left: -180.w,
              width: 720.w,
              bottom: -60.h,
              height: 380.h,
              child: Center(
                child: Lottie.asset(
                  'assets/lottie/spaceship.json',
                  fit: BoxFit.cover,
                  repeat: true,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
