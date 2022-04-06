import 'package:endeavour22/widgets/custom_loader.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FaqScreen extends StatelessWidget {
  final String eventId;
  const FaqScreen({Key? key, required this.eventId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _eventFaqDB =
        FirebaseDatabase.instance.reference().child('eventFaq').child(eventId);
    double statusBarHeight = MediaQuery.of(context).padding.top;
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
                onTap: () => Navigator.of(context).pop(),
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
                  'FAQ',
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
              child: Container(
                margin: EdgeInsets.only(
                  left: 16.w,
                  right: 16.w,
                  bottom: 16.w,
                ),
                child: FirebaseAnimatedList(
                  defaultChild: Center(
                    child: CustomLoader().buildLoader(),
                  ),
                  query: _eventFaqDB,
                  itemBuilder: (BuildContext context, DataSnapshot snapshot,
                      Animation<double> animation, int index) {
                    final data = snapshot.value as Map;
                    return faqTile(data['que'], data['ans']);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget faqTile(String que, String ans) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 16.h),
        buildLine(que, 'Q'),
        SizedBox(height: 4.h),
        buildLine(ans, 'A'),
      ],
    );
  }

  Widget buildLine(String text, String tag) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(tag + ". "),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14.sp,
              color: tag == 'Q' ? Colors.black : Colors.black54,
            ),
          ),
        ),
      ],
    );
  }
}
