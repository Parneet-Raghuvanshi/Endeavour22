import 'package:carousel_slider/carousel_slider.dart';
import 'package:endeavour22/auth/auth_provider.dart';
import 'package:endeavour22/helper/constants.dart';
import 'package:endeavour22/notifications/badge.dart';
import 'package:endeavour22/notifications/notification_provider.dart';
import 'package:endeavour22/notifications/notification_screen.dart';
import 'package:endeavour22/widgets/custom_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback openDrawer;
  const HomeScreen({Key? key, required this.openDrawer}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading = false;

  @override
  void initState() {
    final userId = Provider.of<Auth>(context, listen: false).userModel!.id;
    Provider.of<NotificationProvider>(context, listen: false)
        .fetchNotifications(userId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final statusBar = MediaQuery.of(context).padding.top;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 328.h + statusBar,
              child: Stack(
                children: [
                  // Positioned(
                  //   child: SvgPicture.asset(
                  //     'assets/images/greenback.svg',
                  //     height: 640.h,
                  //     fit: BoxFit.fitHeight,
                  //   ),
                  // ),
                  Positioned(
                    top: 0 + statusBar,
                    right: 8.w,
                    width: 56.w,
                    height: 56.w,
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (ctx) => const NotificationScreen(),
                          ),
                        );
                      },
                      child: Consumer<NotificationProvider>(
                        builder: (context, value, child) => value.dotCount > 0
                            ? Badge(
                                child: child!,
                                value: value.dotCount > 9
                                    ? "9+"
                                    : value.dotCount.toString())
                            : child!,
                        child: Container(
                          margin: EdgeInsets.all(14.w),
                          child: SvgPicture.asset(
                            'assets/images/bell.svg',
                            color: kLayer1Color,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0 + statusBar,
                    left: 8.w,
                    width: 56.w,
                    height: 56.w,
                    child: InkWell(
                      onTap: widget.openDrawer,
                      child: Container(
                        margin: EdgeInsets.all(14.w),
                        child: SvgPicture.asset(
                          'assets/images/hamburger.svg',
                          color: kLayer1Color,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: SizedBox(
                      width: 240.h,
                      height: 220.h,
                      child: SvgPicture.asset(
                        'assets/images/color-scheme-right.svg',
                        color: kLayer1Color,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 36.w,
                    top: 80.h + statusBar,
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/images/logo.png',
                          height: 50.h,
                        ),
                        Text(
                          "Endeavour\n2021-22",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: kLayer1Color,
                            fontSize: 24.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                left: 24.w,
                right: 24.w,
                top: 16.h,
                bottom: 12.h,
              ),
              child: Text(
                'About Endeavour',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                left: 24.w,
                right: 24.w,
                bottom: 16.h,
              ),
              child: Text(
                "Pichai Sundararajan, better known for me a Sundar Pichai, is an Indian-born help you business executive. He is the. Pichai here to Sundararajan, better known the known off Sundar Pichai, is an Indian-born to the time business executive.",
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 16.sp,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                left: 24.w,
                right: 24.w,
                bottom: 16.h,
              ),
              child: Text(
                'Our Guests',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            buildCarousel(),
            SizedBox(height: 24.w),
            Container(
              margin: EdgeInsets.only(
                left: 24.w,
                right: 24.w,
                bottom: 16.h,
              ),
              child: Text(
                'Contact Us',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 26.w),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              width: 312.w,
              height: 48.h,
              child: TextField(
                autofocus: false,
                textAlignVertical: TextAlignVertical.center,
                cursorColor: Colors.black,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16.sp,
                ),
                decoration: InputDecoration(
                  hintText: 'Subject',
                  hintStyle: const TextStyle(color: Colors.black),
                  icon: SizedBox(
                    width: 24.w,
                    height: 24.w,
                    child: Image.asset(
                      'assets/images/email.png',
                      color: Colors.black,
                    ),
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
            SizedBox(height: 16.h),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 26.w),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              width: 312.w,
              height: 48.h,
              child: TextField(
                autofocus: false,
                textAlignVertical: TextAlignVertical.center,
                cursorColor: Colors.black,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16.sp,
                ),
                decoration: InputDecoration(
                  hintText: 'How we can help you...',
                  hintStyle: const TextStyle(color: Colors.black),
                  icon: SizedBox(
                    width: 24.w,
                    height: 24.w,
                    child: Image.asset(
                      'assets/images/email.png',
                      color: Colors.black,
                    ),
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
            SizedBox(height: 16.h),
            Center(
              child: _isLoading
                  ? SizedBox(
                      height: 48.h,
                      child: Center(
                        child: CustomLoader().buildLoader(),
                      ),
                    )
                  : InkWell(
                      onTap: () {},
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black,
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
                        width: 196.w,
                        height: 48.h,
                        child: Text(
                          'Submit',
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
            ),
            SizedBox(height: 26.h),
            Container(
              margin: EdgeInsets.only(
                left: 24.w,
                right: 24.w,
                bottom: 8.w,
              ),
              child: Text(
                'Created By',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              width: 360.w,
              height: 156.w,
              padding: EdgeInsets.symmetric(horizontal: 26.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: 108.w,
                    height: 156.w,
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(16.w),
                          width: 108.w,
                          height: 108.w,
                          child: Image.asset('assets/images/woman.png'),
                        ),
                        Center(
                          child: Text(
                            'Tanika\nGulati',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16.sp),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 108.w,
                    height: 156.w,
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(16.w),
                          width: 108.w,
                          height: 108.w,
                          child: Image.asset('assets/images/man.png'),
                        ),
                        Center(
                          child: Text(
                            'Dhruv\nRastogi',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16.sp),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),
          ],
        ),
      ),
    );
  }

  Widget buildCarousel() {
    return CarouselSlider(
      items: [
        Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              height: 260.w,
              width: 260.w,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(12),
                ),
                image: DecorationImage(
                  image: NetworkImage(
                      "https://firebasestorage.googleapis.com/v0/b/endeavour-21.appspot.com/o/teams%2FIMG_20181229_142945newasqre.jpg?alt=media&token=701f3216-63ac-46af-ac14-6d60be819708"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white70,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(12.w),
                  bottomRight: Radius.circular(12.w),
                ),
              ),
              height: 42.w,
              child: Center(
                child: Text(
                  'Parneet Raghavanshi',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
      options: CarouselOptions(
        autoPlay: true,
        height: 260.w,
        autoPlayCurve: Curves.easeInOut,
      ),
    );
  }
}
