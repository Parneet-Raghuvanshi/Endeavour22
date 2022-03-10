import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CustomLoader {
  Widget buildLoader() {
    return SizedBox(
      width: 56.w,
      height: 56.w,
      child: SpinKitWave(
        type: SpinKitWaveType.start,
        size: 36.w,
        color: Colors.black54,
      ),
    );
  }
}
