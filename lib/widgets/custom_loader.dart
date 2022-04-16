import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

Widget buildLoader(double height) {
  return SizedBox(
    width: height,
    height: height,
    child: SpinKitWave(
      type: SpinKitWaveType.start,
      size: height / 2,
      color: Colors.black54,
    ),
  );
}
