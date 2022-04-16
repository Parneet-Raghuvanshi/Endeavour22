import 'package:endeavour22/helper/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget buildInputField({
  required TextEditingController controller,
  required String name,
  required String icon,
  required double width,
  bool isObs = false,
  int maxLines = 1,
  int limit = 0,
  bool isMargin = true,
  bool isEnabled = true,
  bool hideIcon = false,
  double height = 0,
}) {
  bool _obscure = isObs;
  return Container(
    margin: isMargin ? EdgeInsets.symmetric(horizontal: 16.w) : null,
    decoration: BoxDecoration(
      color: kPrimaryTrans,
      borderRadius: BorderRadius.circular(16),
    ),
    alignment: Alignment.center,
    padding: isObs
        ? EdgeInsets.only(left: 16.w)
        : EdgeInsets.symmetric(horizontal: 16.w),
    width: width,
    height: height == 0 ? 44.h : height,
    child: StatefulBuilder(
      builder: (context, setState) => TextField(
        maxLines: maxLines,
        enabled: isEnabled,
        inputFormatters: [
          if (limit > 0) LengthLimitingTextInputFormatter(limit),
        ],
        obscureText: isObs ? _obscure : false,
        controller: controller,
        autofocus: false,
        textAlignVertical: TextAlignVertical.center,
        cursorColor: kPrimaryMid,
        style: TextStyle(
          color: kPrimaryMid,
          fontSize: 16.sp,
        ),
        decoration: InputDecoration(
          hintText: name,
          hintStyle: const TextStyle(color: kPrimaryMid),
          icon: hideIcon
              ? null
              : SizedBox(
                  width: 20.w,
                  height: 20.w,
                  child: Image.asset(
                    icon,
                    color: kPrimaryMid,
                    fit: BoxFit.cover,
                  ),
                ),
          border: InputBorder.none,
          suffixIcon: isObs
              ? IconButton(
                  icon: Icon(
                    _obscure ? Icons.visibility : Icons.visibility_off,
                    color: kPrimaryMid,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscure = !_obscure;
                    });
                  },
                )
              : null,
        ),
      ),
    ),
  );
}
