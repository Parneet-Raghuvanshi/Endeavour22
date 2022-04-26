import 'package:endeavour22/events/event_detail_screen.dart';
import 'package:endeavour22/events/event_model.dart';
import 'package:endeavour22/events/event_main_provider.dart';
import 'package:endeavour22/helper/constants.dart';
import 'package:endeavour22/widgets/banner.dart';
import 'package:endeavour22/widgets/custom_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class EventScreen extends StatefulWidget {
  final VoidCallback openDrawer;
  const EventScreen({Key? key, required this.openDrawer}) : super(key: key);

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  @override
  void initState() {
    Provider.of<EventMainProvider>(context, listen: false).fetchEvents();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double statusBarHeight = MediaQuery.of(context).padding.top;
    return Scaffold(
      backgroundColor: const Color(0xFFFEFEFE),
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
                  'Events',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 56.h,
              width: 360.w,
              height: 640.h - 56.h - statusBarHeight,
              child: Consumer<EventMainProvider>(
                builder: (ctx, event, _) => event.completed
                    ? event.isEventsOpen
                        ? buildEventTypes(context)
                        : const Center(
                            child: Text('Coming Soon!'),
                          )
                    : Center(
                        child: buildLoader(48.h),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildEventTypes(BuildContext context) {
    List<EventModel> corpEvents =
        Provider.of<EventMainProvider>(context).corpEvents;
    List<EventModel> funEvents =
        Provider.of<EventMainProvider>(context).funEvents;
    List<EventModel> spsEvents =
        Provider.of<EventMainProvider>(context).spsEvents;

    var widgets = <Widget>[];
    widgets.add(
      buildEventList(context, "Corporate Events", "Let's test your ability!",
          "assets/images/studying.png", corpEvents),
    );
    widgets.add(
      buildEventList(context, "Fun Events", "Just chill around here!",
          "assets/images/creative.png", funEvents),
    );
    widgets.add(
      buildEventList(context, "Special Events", "Work too hard!",
          "assets/images/creativity.png", spsEvents),
    );
    return SingleChildScrollView(
      child: Column(children: widgets),
    );
  }

  Widget buildEventList(BuildContext context, String eventType,
      String eventTypeTag, String imgUri, List<EventModel> data) {
    return SizedBox(
      height: 244.w,
      width: 360.w,
      child: Stack(
        children: [
          Positioned(
            height: 84.w,
            width: 186.w,
            left: 26.w,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  eventType,
                  style: TextStyle(
                    fontSize: 20.sp,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  eventTypeTag,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            height: 84.w,
            width: 158.w,
            right: 0,
            child: Container(
              alignment: Alignment.bottomCenter,
              child: Image.asset(
                imgUri,
                fit: BoxFit.contain,
                height: 64.w,
              ),
            ),
          ),
          Positioned(
            height: 160.w,
            width: 360.w, //138.w
            bottom: 0,
            child: buildEventCardList(context, data),
          ),
        ],
      ),
    );
  }

  Widget buildEventCardList(BuildContext context, List<EventModel> data) {
    var widgets = <Widget>[];
    for (EventModel model in data) {
      widgets.add(buildEventCard(context, model));
    }
    if (widgets.length == 1) {
      return Center(
        child: widgets[0],
      );
    } else {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 12.w,
            ),
            child: Row(children: widgets)),
      );
    }
  }

  Widget buildEventCard(BuildContext context, EventModel model) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EventDetail(model: model),
          ),
        );
      },
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(8)),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6.0,
              offset: Offset(0, 3),
            ),
          ],
        ),
        margin: EdgeInsets.symmetric(
          vertical: 12.w,
          horizontal: 6.w,
        ),
        height: 128.w,
        width: 314.w,
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
                  color: kPrimaryMid,
                  child: Text(
                    model.name,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18.sp,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              width: 186.w,
              height: 128.w - 46.w,
              child: Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.only(left: 12),
                child: Text(
                  model.desc,
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
              width: 128.w,
              height: 128.w,
              right: 0,
              child: model.isDis
                  ? ClipRect(
                      child: buildBanner(
                        child: Center(
                          child: Hero(
                            tag: model.eventId,
                            child: Image.network(
                              model.imgUri,
                              height: 78.w,
                              width: 78.w,
                            ),
                          ),
                        ),
                        oldP: int.parse(model.price),
                        newP: int.parse(model.discount),
                      ),
                    )
                  : Center(
                      child: Hero(
                        tag: model.eventId,
                        child: Image.network(
                          model.imgUri,
                          height: 78.w,
                          width: 78.w,
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
