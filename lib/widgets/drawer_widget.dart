import 'package:endeavour22/helper/drawer_items.dart';
import 'package:endeavour22/drawermain/drawer_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DrawerWidget extends StatelessWidget {
  final ValueChanged<DrawerItem> onSelectedItem;
  const DrawerWidget({Key? key, required this.onSelectedItem})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: buildDrawerItems(context),
    );
  }

  Widget buildDrawerItems(BuildContext context) => SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Flex(
            direction: Axis.vertical,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.center,
                height: 124.w,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Parneet",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 20.sp,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 8.w,
                    ),
                    Text(
                      "parneetraghuvanshi@gmail.com",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(
                      height: 8.w,
                    ),
                    Text(
                      "ENDVR8586825947",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.black,
                      ),
                    ),
                  ],
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
                            child: Image.asset(item.icon),
                          ),
                          title: Text(
                            item.title,
                            style: TextStyle(
                              color: Colors.black,
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
