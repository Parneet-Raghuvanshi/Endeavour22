import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:endeavour22/auth/auth_provider.dart';
import 'package:endeavour22/drawermain/glimpses_provider.dart';
import 'package:endeavour22/helper/constants.dart';
import 'package:endeavour22/helper/http_exception.dart';
import 'package:endeavour22/notifications/badge.dart';
import 'package:endeavour22/notifications/notification_provider.dart';
import 'package:endeavour22/notifications/notification_screen.dart';
import 'package:endeavour22/widgets/custom_loader.dart';
import 'package:endeavour22/widgets/custom_snackbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  final VoidCallback openDrawer;
  const HomeScreen({Key? key, required this.openDrawer}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading = false;
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();

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
                      // child: Consumer<NotificationProvider>(
                      //   builder: (context, value, child) => value.dotCount > 0
                      //       ? Badge(
                      //           child: child!,
                      //           value: value.dotCount > 9
                      //               ? "9+"
                      //               : value.dotCount.toString())
                      //       : child!,
                      //
                      // ),
                      child: Container(
                        margin: EdgeInsets.all(14.w),
                        child: SvgPicture.asset(
                          'assets/images/bell.svg',
                          color: kLayer1Color,
                        ),
                      ),
                    ),
                  ),
                  Consumer<NotificationProvider>(
                    builder: (context, value, _) => value.dotCount > 0
                        ? Positioned(
                            right: 16.w,
                            top: 8.w + statusBar,
                            child: Container(
                              padding: const EdgeInsets.all(2.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: Colors.red,
                              ),
                              constraints: const BoxConstraints(
                                minWidth: 20,
                                minHeight: 20,
                              ),
                              child: Center(
                                child: Text(
                                  value.dotCount > 9
                                      ? "9+"
                                      : value.dotCount.toString(),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          )
                        : Container(),
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
                'Glimpses',
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
                bottom: 8.h,
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
              margin: EdgeInsets.only(left: 26.w),
              alignment: Alignment.centerLeft,
              child: Text(
                'Subject',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 8.w),
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
                controller: _subjectController,
                autofocus: false,
                textAlignVertical: TextAlignVertical.center,
                cursorColor: Colors.black,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16.sp,
                ),
                decoration: const InputDecoration(
                  hintText: 'Specify your subject...',
                  hintStyle: TextStyle(color: Colors.black54),
                  border: InputBorder.none,
                ),
              ),
            ),
            SizedBox(height: 8.h),
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(left: 26.w),
              child: Text(
                'Message',
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 8.w),
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
              height: 96.h,
              child: TextField(
                controller: _messageController,
                maxLines: 4,
                autofocus: false,
                textAlignVertical: TextAlignVertical.top,
                cursorColor: Colors.black,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16.sp,
                ),
                decoration: const InputDecoration(
                  hintText: 'How we can help you...',
                  hintStyle: TextStyle(color: Colors.black54),
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
                      onTap: submitContactUs,
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
            SizedBox(height: 16.h),
          ],
        ),
      ),
    );
  }

  void submitContactUs() async {
    setState(() {
      _isLoading = true;
    });
    final subject = _subjectController.text.trim();
    final message = _messageController.text.trim();

    if (subject.isEmpty) {
      showErrorFlush(
        context: context,
        message: 'Subject field is empty!',
      );
      setState(() {
        _isLoading = false;
      });
      return;
    } else if (message.isEmpty) {
      showErrorFlush(
        context: context,
        message: 'Message field is empty!',
      );
      setState(() {
        _isLoading = false;
      });
      return;
    }

    // now send request here...
    final userData = Provider.of<Auth>(context, listen: false).userModel!;
    try {
      final response = await http.post(
        Uri.parse('$serverURL/api/user/contactUs'),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          'name': userData.name,
          'subject': subject,
          'email': userData.email,
          'message': message,
        }),
      );
      final responseData = json.decode(response.body);
      if (responseData['hasError']) {
        throw HttpException(responseData['msg']);
      }
      // clear the form after submitting
      _subjectController.clear();
      _messageController.clear();
      // Form Send
      showNormalFlush(
        context: context,
        message: 'Contact Form Submitted Successfully!',
      );
    } on HttpException catch (error) {
      showErrorFlush(
        context: context,
        message: error.toString(),
      );
    } catch (error) {
      String errorMessage = 'Could not send form, please try again!';
      showErrorFlush(
        context: context,
        message: errorMessage,
      );
    }
    setState(() {
      _isLoading = false;
    });
  }

  Widget buildCarousel() {
    return Consumer<GlimpsesProvider>(builder: (ctx, value, _) {
      if (value.glimpses.isNotEmpty) {
        var widgets = <Widget>[];
        for (var element in value.glimpses) {
          widgets.add(
            SizedBox(
              height: 274.w,
              width: 274.w,
              // decoration: BoxDecoration(
              //   borderRadius: const BorderRadius.all(
              //     Radius.circular(12),
              //   ),
              //   // image: DecorationImage(
              //   //   image: NetworkImage(element),
              //   //   fit: BoxFit.cover,
              //   // ),
              //   //image: DecorationImage(image: CachedNetworkImage(imageUrl: element,)),
              // ),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(12)),
                child: CachedNetworkImage(
                  placeholder: (context, url) => Center(
                    child: Container(
                      color: Colors.white60,
                      child: SpinKitFadingCircle(
                        color: Colors.grey,
                        size: 36.h,
                      ),
                    ),
                  ),
                  imageUrl: element,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        }
        return CarouselSlider(
          items: widgets,
          options: CarouselOptions(
            autoPlay: true,
            height: 274.w,
            autoPlayCurve: Curves.easeInOut,
          ),
        );
      } else {
        return Container();
      }
    });
  }
}
