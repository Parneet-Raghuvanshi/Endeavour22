import 'package:cached_network_image/cached_network_image.dart';
import 'package:endeavour22/helper/constants.dart';
import 'package:endeavour22/speakers/speaker_tile.dart';
import 'package:endeavour22/speakers/speakers_provider.dart';
import 'package:endeavour22/widgets/custom_loader.dart';
import 'package:endeavour22/widgets/custom_snackbar.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SpeakersScreen extends StatefulWidget {
  final VoidCallback openDrawer;
  const SpeakersScreen({Key? key, required this.openDrawer}) : super(key: key);

  @override
  State<SpeakersScreen> createState() => _SpeakersScreenState();
}

class _SpeakersScreenState extends State<SpeakersScreen> {
  bool isOpen = false;
  bool isChecked = false;

  @override
  void initState() {
    refreshStatus();
    super.initState();
  }

  Future<void> refreshStatus() async {
    final _toggleDB =
        FirebaseDatabase.instance.reference().child('toggle').child('speakers');
    await _toggleDB.once().then((value) {
      if (value.snapshot.value == true) {
        setState(() {
          isOpen = true;
        });
      }
    });
    setState(() {
      isChecked = true;
    });
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
                  'Our Speakers',
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
              child: Consumer<SpeakerProvider>(
                builder: (ctx, value, _) => isOpen
                    ? value.allSpeakers.isEmpty
                        ? value.completed
                            ? comingSoon()
                            : Center(
                                child: buildLoader(48.h),
                              )
                        : ListView.builder(
                            padding: EdgeInsets.zero,
                            itemBuilder: (context, index) =>
                                speakerTile(value.allSpeakers[index], context),
                            itemCount: value.allSpeakers.length,
                          )
                    : isChecked
                        ? comingSoon()
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

  Widget speakerTile(SpeakerTile data, BuildContext context) {
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
                offset: Offset(0, 1),
              ),
            ]),
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.w),
        height: 252.w,
        width: 328.w,
        child: Stack(
          children: [
            Positioned(
              top: 6.h,
              left: 6.h,
              height: 102.w,
              width: 102.w,
              child: ClipRRect(
                borderRadius: const BorderRadius.all(
                  Radius.circular(7),
                ),
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
              left: 108.w,
              width: 328.w - 36.w - 108.w,
              height: 114.w,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.w),
                alignment: Alignment.center,
                child: Text(
                  data.name,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22.sp,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Positioned(
              left: 0,
              bottom: 0,
              width: 292.w,
              height: 252.w - 116.w,
              child: Container(
                margin: EdgeInsets.all(12.w),
                alignment: Alignment.center,
                child: Text(
                  data.desc,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 7,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            Positioned(
              right: 0,
              width: 36.w,
              height: 252.w,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
                child: Container(
                  alignment: Alignment.center,
                  color: kPrimaryMid,
                  child: RotatedBox(
                    quarterTurns: 3,
                    child: Text(
                      data.tag,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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

class BottomSheet extends StatelessWidget {
  final SpeakerTile data;
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
            SizedBox(height: 16.w),
            Text(
              data.name.replaceAll('\n', ' '),
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
                child: Image.asset('assets/images/twitter.png'),
              ),
              title: const Text('Tweet on Twitter'),
              onTap: () => link(data.twP, context),
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
            ListTile(
              leading: SizedBox(
                height: 24.w,
                width: 24.w,
                child: Image.asset('assets/images/instagram.png'),
              ),
              title: const Text('View on Instagram'),
              onTap: () => link(data.isP, context),
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
