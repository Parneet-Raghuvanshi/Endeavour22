import 'package:endeavour22/events/event_detail_tile.dart';
import 'package:endeavour22/events/event_content_provider.dart';
import 'package:endeavour22/events/faq_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class EventDetail extends StatefulWidget {
  final String eventId;
  const EventDetail({Key? key, required this.eventId}) : super(key: key);

  @override
  State<EventDetail> createState() => _EventDetailState();
}

class _EventDetailState extends State<EventDetail> {
  @override
  Widget build(BuildContext context) {
    Provider.of<EventContentProvider>(context, listen: false)
        .fetchData(widget.eventId);
    final List<EventDetailTile> details =
        Provider.of<EventContentProvider>(context).allContent;
    var topPadding = MediaQuery.of(context).padding.top;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                SizedBox(
                  height: 125.h,
                  width: 360.w,
                  child: Image.asset(
                    "assets/images/demo_img.jpg",
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: -24.w,
                  child: Center(
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12, //New
                            blurRadius: 10.0,
                            offset: Offset(0, 1),
                          ),
                        ],
                      ),
                      height: 96.w,
                      width: 96.w,
                      child: Center(
                        child: Icon(
                          Icons.android,
                          size: 54.w,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: topPadding,
                  left: 0,
                  width: 56.w,
                  height: 56.h,
                  child: InkWell(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                        margin: EdgeInsets.all(16.w),
                        child: Image.asset(
                          'assets/images/back.png',
                          color: Colors.white,
                        )),
                  ),
                ),
                Positioned(
                  top: topPadding,
                  right: 0,
                  width: 56.w,
                  height: 56.h,
                  child: InkWell(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FaqScreen(
                          eventId: widget.eventId,
                        ),
                      ),
                    ),
                    child: Container(
                        margin: EdgeInsets.all(16.w),
                        child: Image.asset(
                          'assets/images/faq.png',
                          color: Colors.white,
                        )),
                  ),
                ),
              ],
            ),
            SizedBox(height: 24.w),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 16.w,
              ),
              child: Text(
                "Market Watch",
                style: TextStyle(
                  fontSize: 24.sp,
                ),
              ),
            ),
            if (details.isNotEmpty) buildDetailList(details),
          ],
        ),
      ),
    );
  }

  Widget buildDetailList(List<EventDetailTile> details) {
    var widgets = <Widget>[];
    for (EventDetailTile box in details) {
      widgets.add(buildTile(box.title, box.body));
    }
    return Column(
      children: widgets,
    );
  }

  Widget buildTile(String title, String body) {
    List<String> bodyStr = body.split("[dot]");
    var lines = <Widget>[];
    for (String line in bodyStr) {
      lines.add(bulletLine(line, bodyStr.length));
    }
    return Container(
      margin: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 4.h),
          Column(
            children: lines,
          )
        ],
      ),
    );
  }

  Widget bulletLine(String text, int len) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        if (len > 1) const Text("● "),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14.sp,
            ),
          ),
        ),
      ],
    );
  }
}
