import 'package:endeavour22/schedule/schedule_provider.dart';
import 'package:endeavour22/schedule/schedule_tile.dart';
import 'package:endeavour22/widgets/custom_loader.dart';
import 'package:flutter/cupertino.dart';
import 'package:endeavour22/helper/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class ScheduleScreen extends StatefulWidget {
  final VoidCallback openDrawer;
  const ScheduleScreen({Key? key, required this.openDrawer}) : super(key: key);

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen>
    with TickerProviderStateMixin {
  late TabController _appTitleController;

  @override
  void initState() {
    super.initState();
    _appTitleController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _appTitleController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double statusBarHeight = MediaQuery.of(context).padding.top;
    double width = MediaQuery.of(context).size.width;
    double yourWidth = width / 2;
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(top: statusBarHeight),
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              width: 56.w,
              height: 56.h,
              child: InkWell(
                onTap: widget.openDrawer,
                child: Container(
                    margin: EdgeInsets.all(16.w),
                    child: Image.asset('assets/images/back.png')),
              ),
            ),
            Positioned(
              width: 360.w,
              height: 56.h,
              right: 0,
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  'Schedule',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 48.h,
              width: 360.w,
              height: 36.h,
              child: Column(
                children: [
                  TabBar(
                    physics: const NeverScrollableScrollPhysics(),
                    controller: _appTitleController,
                    indicatorColor: kLayer6Color,
                    labelColor: kLayer6Color,
                    unselectedLabelColor: Colors.black26,
                    isScrollable: false,
                    tabs: [
                      SizedBox(
                        height: 34.h,
                        width: yourWidth,
                        child: const Tab(
                          text: 'Day One',
                        ),
                      ),
                      SizedBox(
                        height: 34.h,
                        width: yourWidth,
                        child: const Tab(
                          text: 'Day Two',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              top: 84.h,
              width: 360.w,
              height: 640.h - 84.h - statusBarHeight,
              child: TabBarView(
                physics: const NeverScrollableScrollPhysics(),
                controller: _appTitleController,
                children: [
                  buildDayOne(),
                  buildDayTwo(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDayOne() {
    return Consumer<ScheduleProvider>(
      builder: (ctx, value, _) => value.dayOne.isEmpty
          ? value.completedOne
              ? comingSoon()
              : Center(
                  child: CustomLoader().buildLoader(),
                )
          : ListView.builder(
              padding: EdgeInsets.zero,
              itemBuilder: (context, index) =>
                  scheduleTile(value.dayOne[index], index),
              itemCount: value.dayOne.length - 1,
            ),
    );
  }

  Widget buildDayTwo() {
    return Consumer<ScheduleProvider>(
      builder: (ctx, value, _) => value.dayTwo.isEmpty
          ? value.completedTwo
              ? comingSoon()
              : Center(
                  child: CustomLoader().buildLoader(),
                )
          : ListView.builder(
              padding: EdgeInsets.zero,
              itemBuilder: (context, index) =>
                  scheduleTile(value.dayTwo[index], index),
              itemCount: value.dayTwo.length,
            ),
    );
  }

  Widget scheduleTile(ScheduleTile data, int index) {
    return SizedBox(
      height: 124.w,
      width: 360.w,
      child: Stack(
        children: [
          Positioned(
            left: 104.w,
            height: 124.w,
            width: 8.w,
            child: Container(
              color: index % 2 == 0 ? kLayer1Color : kLayer5Color,
            ),
          ),
          Positioned(
            height: 124.w,
            width: 104.w,
            child: Container(
              alignment: Alignment.center,
              child: Text(
                data.time,
                overflow: TextOverflow.ellipsis,
                maxLines: 3,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            height: 64.w,
            width: 360.w - 104.w - 8.w,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.w),
              alignment: Alignment.bottomLeft,
              child: Text(
                data.title,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            height: 64.w,
            width: 360.w - 104.w - 8.w,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 8.w, horizontal: 12.w),
              alignment: Alignment.topLeft,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.location_pin),
                  SizedBox(
                    width: 6.w,
                  ),
                  Expanded(
                    child: Text(
                      data.location,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
