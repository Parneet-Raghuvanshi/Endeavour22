import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EventScreen extends StatelessWidget {
  final VoidCallback openDrawer;
  const EventScreen({Key? key, required this.openDrawer}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(8)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12, //New
                  blurRadius: 10.0,
                  offset: Offset(0, 1),
                ),
              ]),
          margin: EdgeInsets.all(16.w),
          height: 128.w,
          width: 328.w,
          child: Stack(
            children: [
              Positioned(
                width: 196.w,
                height: 46.w,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(16),
                    topLeft: Radius.circular(8),
                  ),
                  child: Container(
                    alignment: Alignment.center,
                    color: Colors.blueAccent,
                    child: Text(
                      "Market Watch",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                width: 196.w,
                height: 128.w - 46.w,
                child: Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(left: 12),
                  child: Text(
                    "Market Watch is a very fun event and want to enhance the grid for the upcoming future content",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              Positioned(
                width: 328.w - 196.w,
                height: 128.w,
                right: 0,
                child: Container(
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.android,
                    size: 84.w,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
