import 'package:endeavour22/auth/auth_provider.dart';
import 'package:endeavour22/helper/constants.dart';
import 'package:endeavour22/helper/drawer_items.dart';
import 'package:endeavour22/drawermain/drawer_item.dart';
import 'package:endeavour22/team/about_us_screen.dart';
import 'package:endeavour22/events/event_screen.dart';
import 'package:endeavour22/drawermain/home_screen.dart';
import 'package:endeavour22/schedule/schedule_screen.dart';
import 'package:endeavour22/speakers/speakers_screen.dart';
import 'package:endeavour22/sponsors/sponsors_screen.dart';
import 'package:endeavour22/team/team_screen.dart';
import 'package:endeavour22/widgets/custom_snackbar.dart';
import 'package:endeavour22/drawermain/drawer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  DateTime? currentBackPressTime;
  late double xOffset;
  late double yOffset;
  late double scaleFactor;
  late bool isDrawerOpen;
  DrawerItem item = DrawerItems.home;
  bool isDragging = false;

  @override
  void initState() {
    super.initState();
    closeDrawer();
  }

  void closeDrawer() => setState(() {
        xOffset = 0;
        yOffset = 0;
        scaleFactor = 1;
        isDrawerOpen = false;
      });

  void openDrawer() => setState(() {
        xOffset = 236.w;
        yOffset = 0;
        scaleFactor = 1;
        isDrawerOpen = true;
      });

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                kPrimaryLight,
                kPrimaryDark,
              ],
            ),
          ),
          child: Stack(
            children: [
              buildDrawer(),
              buildPage(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDrawer() => SafeArea(
        child: SizedBox(
          width: xOffset,
          child: DrawerWidget(
            onSelectedItem: (item) {
              switch (item) {
                case DrawerItems.logout:
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      //title: const Text('Are You Sure!'),
                      content: Text(
                        'Do you want to logout?',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16.sp,
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            'No',
                            style: TextStyle(
                              color: kPrimaryMid,
                              fontSize: 16.sp,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            Provider.of<Auth>(context, listen: false).logout();
                            showNormalFlush(
                              context: context,
                              message: 'Logout Successfully!',
                            );
                          },
                          child: Text(
                            'Yes',
                            style: TextStyle(
                              color: kPrimaryMid,
                              fontSize: 16.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                  return;
                default:
                  setState(() => this.item = item);
                  closeDrawer();
              }
            },
            closeDrawer: closeDrawer,
          ),
        ),
      );

  Widget buildPage() {
    return WillPopScope(
      onWillPop: () async {
        if (isDrawerOpen) {
          closeDrawer();
          return false;
        } else {
          return true;
        }
      },
      child: GestureDetector(
        onHorizontalDragStart: (details) => isDragging = true,
        onHorizontalDragUpdate: (details) {
          if (!isDragging) return;
          const delta = 1;
          if (details.delta.dx > delta) {
            openDrawer();
          } else if (details.delta.dx < -delta) {
            closeDrawer();
          }
          isDragging = false;
        },
        onTap: closeDrawer,
        child: AnimatedContainer(
          curve: Curves.easeOutSine,
          transform: Matrix4.translationValues(xOffset, yOffset, 0)
            ..scale(scaleFactor),
          duration: const Duration(milliseconds: 220),
          child: AbsorbPointer(
            absorbing: isDrawerOpen,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(isDrawerOpen ? 0 : 0),
              child: getDrawerPage(),
            ),
          ),
        ),
      ),
    );
  }

  Widget getDrawerPage() {
    switch (item) {
      case DrawerItems.events:
        return EventScreen(openDrawer: openDrawer);
      case DrawerItems.team:
        return TeamScreen(openDrawer: openDrawer);
      case DrawerItems.schedule:
        return ScheduleScreen(openDrawer: openDrawer);
      case DrawerItems.sponsors:
        return SponsorsScreen(openDrawer: openDrawer);
      case DrawerItems.speakers:
        return SpeakersScreen(openDrawer: openDrawer);
      case DrawerItems.aboutUs:
        return AboutUsScreen(openDrawer: openDrawer);
      case DrawerItems.home:
      default:
        return HomeScreen(openDrawer: openDrawer);
    }
  }

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (isDrawerOpen) {
      closeDrawer();
      return Future.value(false);
    }
    if (item != DrawerItems.home) {
      setState(() {
        item = DrawerItems.home;
      });
      return Future.value(false);
    }
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > const Duration(seconds: 3)) {
      currentBackPressTime = now;
      const snackBar = SnackBar(
        content: Text('Press back again to exit the application!'),
        duration: Duration(seconds: 3),
      );
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(snackBar);
      return Future.value(false);
    }
    return Future.value(true);
  }
}
