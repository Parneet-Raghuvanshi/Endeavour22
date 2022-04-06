import 'package:endeavour22/auth/auth_provider.dart';
import 'package:endeavour22/auth/profile_screen.dart';
import 'package:endeavour22/auth/user_model.dart';
import 'package:endeavour22/helper/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final UserModel user = Provider.of<Auth>(context, listen: false).userModel!;
    final statusBar = MediaQuery.of(context).padding.top;
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: statusBar),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 56.w,
                height: 56.w,
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                      margin: EdgeInsets.all(16.w),
                      child: Image.asset('assets/images/back.png')),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 16.h),
                alignment: Alignment.center,
                height: 96.h,
                width: 96.h,
                child: Text(
                  user.name[0],
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 56.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                decoration: const BoxDecoration(
                  color: kLayer1Color,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12, //New
                      blurRadius: 10.0,
                      offset: Offset(6, 6),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 56.w,
                height: 56.w,
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (ctx) => const ProfileScreen(isUpdate: true),
                    ));
                  },
                  child: Container(
                      margin: EdgeInsets.all(16.w),
                      child: SvgPicture.asset('assets/images/edit.svg')),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Center(
            child: Text(
              user.name,
              style: TextStyle(
                color: Colors.black,
                fontSize: 22.sp,
              ),
            ),
          ),
          SizedBox(height: 8.h),
          Center(
            child: Text(
              user.email,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16.sp,
              ),
            ),
          ),
          SizedBox(height: 8.h),
          Center(
            child: Text(
              user.endvrid,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16.sp,
              ),
            ),
          ),
          SizedBox(height: 16.h),
          Container(
            color: Colors.black12,
            height: 1.h,
          ),
          SizedBox(height: 16.h),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 26.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'College',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.sp,
                  ),
                ),
                SizedBox(width: 24.w),
                Expanded(
                  child: Text(
                    user.college,
                    textAlign: TextAlign.end,
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 16.sp,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 8.h),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 26.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'College ID',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.sp,
                  ),
                ),
                Text(
                  user.libId,
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 16.sp,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 8.h),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 26.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Branch',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.sp,
                  ),
                ),
                Text(
                  user.branch,
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 16.sp,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 8.h),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 26.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Semester',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.sp,
                  ),
                ),
                Text(
                  user.semester,
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 16.sp,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),
          Container(
            color: Colors.black12,
            height: 1.h,
          ),
          SizedBox(height: 16.h),
          Center(
            child: Text(
              'Registered Events',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18.sp,
              ),
            ),
          ),
          SizedBox(height: 16.h),
        ],
      ),
    );
  }
}
