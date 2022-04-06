import 'package:cached_network_image/cached_network_image.dart';
import 'package:endeavour22/helper/constants.dart';
import 'package:endeavour22/team/team_provider.dart';
import 'package:endeavour22/team/team_tile.dart';
import 'package:endeavour22/widgets/custom_loader.dart';
import 'package:endeavour22/widgets/custom_snackbar.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class TeamScreen extends StatelessWidget {
  final VoidCallback openDrawer;
  const TeamScreen({Key? key, required this.openDrawer}) : super(key: key);

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
                onTap: openDrawer,
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
                  'Our Team',
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
              child: Consumer<TeamProvider>(
                builder: (ctx, value, _) => value.allTeam.isEmpty
                    ? value.completed
                        ? comingSoon()
                        : Center(
                            child: CustomLoader().buildLoader(),
                          )
                    : ListView.builder(
                        padding: EdgeInsets.zero,
                        itemBuilder: (context, index) =>
                            eventTile(value.allTeam[index], context),
                        itemCount: value.allTeam.length,
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget eventTile(TeamTile data, BuildContext context) {
    return InkWell(
      onTap: () {
        showModalBottomSheet(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          context: context,
          builder: (context) {
            return BottomSheet(data: data);
          },
        );
      },
      child: Container(
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(8)),
            boxShadow: [
              BoxShadow(
                color: Colors.black12, //New
                blurRadius: 10.0,
                offset: Offset(0.5, 0.5),
              ),
            ]),
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.w),
        height: 84.h,
        width: 328.w,
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                bottomLeft: Radius.circular(8),
              ),
              child: SizedBox(
                height: 84.h,
                width: 84.h,
                child: CachedNetworkImage(
                  placeholder: (context, url) => Center(
                    child: SpinKitFadingCircle(
                      color: Colors.grey,
                      size: 36.h,
                    ),
                  ),
                  imageUrl: data.imgUri,
                ),
              ),
            ),
            Positioned(
              left: 84.h,
              width: 328.w - 84.h,
              height: 52.h,
              child: Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(left: 12.w, right: 12.w),
                child: Text(
                  data.name,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 18.sp,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Positioned(
              width: 120.w,
              right: 0,
              bottom: 0,
              height: 32.h,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  bottomRight: Radius.circular(8),
                ),
                child: Container(
                  color: kLayer1Color,
                  alignment: Alignment.center,
                  child: Text(
                    data.domain,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 84.h,
              bottom: 0,
              width: 328.w - 84.h - 120.w,
              height: 32.h,
              child: Container(
                alignment: Alignment.center,
                child: const Icon(Icons.badge_rounded),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BottomSheet extends StatelessWidget {
  final TeamTile data;
  const BottomSheet({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: 6.w,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 10.0),
            //   child: ClipRRect(
            //     borderRadius: BorderRadius.circular(8.0),
            //     child: Container(
            //       height: 5.0,
            //       width: 40.0,
            //       color: Colors.black87,
            //     ),
            //   ),
            // ),
            SizedBox(height: 16.w),
            Text(
              data.name,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: TextStyle(
                fontSize: 18.sp,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 16.w),
            Container(
              color: Colors.black26,
              height: 1.w,
            ),
            ListTile(
              leading: SizedBox(
                height: 24.w,
                width: 24.w,
                child: Image.asset('assets/images/linkedin.png'),
              ),
              title: const Text('Connect on LinkedIn'),
              onTap: () => link(data.liP, context),
            ),
            ListTile(
              leading: SizedBox(
                height: 24.w,
                width: 24.w,
                child: Image.asset('assets/images/google.png'),
              ),
              title: const Text('Write an e-Mail'),
              onTap: () => link(data.glP, context),
            ),
            ListTile(
              leading: SizedBox(
                height: 24.w,
                width: 24.w,
                child: Image.asset('assets/images/facebook.png'),
              ),
              title: const Text('View on Facebook'),
              onTap: () => link(data.fbP, context),
            ),
          ],
        ),
      ),
    );
  }

  void link(String url, BuildContext context) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      showErrorFlush(
        context: context,
        message: 'Error loading URL, please try again!',
      );
    }
  }
}
