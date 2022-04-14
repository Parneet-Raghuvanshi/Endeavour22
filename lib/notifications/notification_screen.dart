import 'package:endeavour22/auth/auth_provider.dart';
import 'package:endeavour22/notifications/notification_model.dart';
import 'package:endeavour22/notifications/notification_provider.dart';
import 'package:endeavour22/widgets/custom_loader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  void initState() {
    //First Clear All notifications
    final userId = Provider.of<Auth>(context, listen: false).userModel!.id;
    Provider.of<NotificationProvider>(context, listen: false)
        .refreshNotifications(userId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                  'Notifications',
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
              child: Consumer<NotificationProvider>(
                builder: (ctx, value, _) => value.allNotification.isEmpty
                    ? value.completed
                        ? noNewNotifications()
                        : Center(
                            child: CustomLoader().buildLoader(),
                          )
                    : ListView.builder(
                        padding: EdgeInsets.zero,
                        itemBuilder: (ctx, index) =>
                            notificationTile(value.allNotification[index]),
                        itemCount: value.allNotification.length,
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget noNewNotifications() {
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            'assets/images/no_new_not.svg',
            height: 200.w,
            width: 200.w,
            fit: BoxFit.cover,
          ),
          SizedBox(height: 16.w),
          Text(
            'No Notifications Here...',
            style: TextStyle(fontSize: 16.sp),
          ),
        ],
      ),
    );
  }

  Widget notificationTile(NotificationModel model) {
    return Dismissible(
      key: Key(model.id),
      onDismissed: (direction) async {
        final userId = Provider.of<Auth>(context, listen: false).userModel!.id;
        await Provider.of<NotificationProvider>(context, listen: false)
            .deleteNotification(userId, model.id);
      },
      direction: DismissDirection.endToStart,
      background: Container(
        child: const Icon(
          Icons.delete,
          color: Colors.white,
          size: 36,
        ),
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 24.w),
      ),
      child: Column(
        children: [
          ListTile(
            contentPadding:
                EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.w),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  model.title,
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  model.body,
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 14.sp,
                  ),
                  textAlign: TextAlign.justify,
                ),
                Container(
                  alignment: Alignment.centerRight,
                  child: Text(
                    model.date,
                    style: TextStyle(
                        color: Colors.black54,
                        fontSize: 12.sp,
                        fontStyle: FontStyle.italic),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16.w),
            color: Colors.black12,
            height: 1.h,
          ),
        ],
      ),
    );
  }
}
