import 'package:endeavour22/auth/auth_provider.dart';
import 'package:endeavour22/auth/profile_view.dart';
import 'package:endeavour22/auth/user_model.dart';
import 'package:endeavour22/helper/drawer_items.dart';
import 'package:endeavour22/drawermain/drawer_item.dart';
import 'package:endeavour22/helper/navigator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class DrawerWidget extends StatelessWidget {
  final ValueChanged<DrawerItem> onSelectedItem;
  final VoidCallback closeDrawer;
  const DrawerWidget(
      {Key? key, required this.onSelectedItem, required this.closeDrawer})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: buildDrawerItems(context),
    );
  }

  Widget buildDrawerItems(BuildContext context) {
    final UserModel user = Provider.of<Auth>(context, listen: false).userModel!;
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Flex(
          direction: Axis.vertical,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                //closeDrawer();
                Navigator.of(context).push(
                  SlideRightRoute(
                    page: const ProfileView(),
                  ),
                );
              },
              child: Container(
                alignment: Alignment.center,
                height: 124.w,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      user.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 20.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 6.w,
                    ),
                    Text(
                      user.email,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      height: 6.w,
                    ),
                    Text(
                      user.endvrid,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: DrawerItems.all
                  .map((item) => ListTile(
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 24.w, vertical: 4.w),
                        leading: SizedBox(
                          width: 24.w,
                          height: 24.w,
                          child: Image.asset(
                            item.icon,
                            color: Colors.white,
                          ),
                        ),
                        title: Text(
                          item.title,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.sp,
                          ),
                        ),
                        onTap: () => onSelectedItem(item),
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
