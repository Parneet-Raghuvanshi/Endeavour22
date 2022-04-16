import 'package:cached_network_image/cached_network_image.dart';
import 'package:endeavour22/helper/constants.dart';
import 'package:endeavour22/sponsors/sponsor_tile.dart';
import 'package:endeavour22/sponsors/sponsors_provider.dart';
import 'package:endeavour22/widgets/custom_loader.dart';
import 'package:endeavour22/widgets/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SponsorsScreen extends StatelessWidget {
  final VoidCallback openDrawer;
  const SponsorsScreen({Key? key, required this.openDrawer}) : super(key: key);

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
                  'Our Sponsors',
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
              child: Consumer<SponsorsProvider>(
                builder: (ctx, value, _) => Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  child: value.allSponsors.isEmpty
                      ? value.completed
                          ? comingSoon()
                          : Center(child: buildLoader(48.h))
                      : StaggeredGridView.countBuilder(
                          padding: EdgeInsets.zero,
                          staggeredTileBuilder: (index) => StaggeredTile.count(
                              value.allSponsors[index].tile == 'SQ' ? 1 : 2, 1),
                          crossAxisCount: 3,
                          mainAxisSpacing: 8.w,
                          itemCount: value.allSponsors.length,
                          crossAxisSpacing: 8.w,
                          itemBuilder: (BuildContext context, int index) {
                            final data = value.allSponsors[index];
                            return sponsorTile(data, context);
                          },
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget sponsorTile(SponsorTile data, BuildContext context) {
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
          ],
        ),
        padding: EdgeInsets.symmetric(vertical: 16.w),
        child: CachedNetworkImage(
          placeholder: (context, url) => Center(
            child: SpinKitFadingCircle(
              color: Colors.grey,
              size: 24.h,
            ),
          ),
          fit: BoxFit.fitHeight,
          imageUrl: data.imgUri,
        ),
      ),
    );
  }
}

class BottomSheet extends StatelessWidget {
  final SponsorTile data;
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
              onTap: () => link(data.link, context),
            ),
            ListTile(
              leading: SizedBox(
                height: 24.w,
                width: 24.w,
                child: Image.asset('assets/images/google.png'),
              ),
              title: const Text('Write an e-Mail'),
              onTap: () => link(data.link, context),
            ),
            ListTile(
              leading: SizedBox(
                height: 24.w,
                width: 24.w,
                child: Image.asset('assets/images/facebook.png'),
              ),
              title: const Text('View on Facebook'),
              onTap: () => link(data.link, context),
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
