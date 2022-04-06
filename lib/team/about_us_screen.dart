import 'package:endeavour22/widgets/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUsScreen extends StatelessWidget {
  final VoidCallback openDrawer;
  const AboutUsScreen({Key? key, required this.openDrawer}) : super(key: key);

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
                  'About e-Cell',
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
              child: SingleChildScrollView(
                child: Padding(
                  padding:
                      EdgeInsets.only(left: 24.w, right: 24.w, bottom: 24.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Introduction',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'KIET e-Cell is a student body of Krishna Institute of Engineering and Technology, formed in 2014 with the aim to promote an entrepreneurial culture among students of technical streams, and encouraging the entrepreneurial minds of the students to convert their drop of idea into an ocean of reality.\nThrough its various activities and events, the Entrepreneurship Cell of KIET strives to enrich their knowledge in the domain of management and technology intervention, and overall ecosystem development for innovation and entrepreneurship.',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14.sp,
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        'Vision',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'We work with a vision to develop a spirit of entrepreneurship among the students of KIET and to support budding entrepreneurs in the exciting and rigorous journey they dare to take.',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14.sp,
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        'What we do!',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'We support the idea of student-led entrepreneurship in the institute. We incite and encourage them to take up entrepreneurial challenges, and assist them in their endeavours to launch and run business ventures. The events conducted by us focus on creating awareness on entrepreneurship, encouraging technology incubation which are culminated by holding an annual event ENDEAVOUR, a Techno-Entrepreneurial Fest to provide a platform to students of different colleges to interact and compete with each other.',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14.sp,
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        'Who support us',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'We are aided by the counsel and backing of TBI-KIET (Technology Business Incubator-Government of India). We seek to benefit from the experiences of the capable experts here and give entrepreneurship a comprehensive boost in order to address the needs of the society at large through institutionalized incubation support.',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14.sp,
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        'Why Associate with us',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'Indian government has realised the need of new entrepreneurs for development in various fields. In accordance with this, Department of Science and Technology, Government of India, is very keen on developing Entrepreneurial Development bodies in all major educational institutions in India.\nIn this regard, KIET e-Cell aims at manifesting the latent entrepreneurial spirit of young entrepreneurs. It is quite active in motivating the technical undergraduate students to make ideas happen. Thus, any association with us will be symbiotic and mutually rewarding to both sides.',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14.sp,
                        ),
                      ),
                      SizedBox(height: 24.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          buildLink(
                            'https://www.facebook.com/ecellkiet/',
                            'assets/images/facebook.png',
                            context,
                          ),
                          buildLink(
                            'https://www.linkedin.com/company/e-cell-kiet/',
                            'assets/images/linkedin.png',
                            context,
                          ),
                          buildLink(
                            'https://www.instagram.com/kietecell/?igshid=lbrt09aprj0l',
                            'assets/images/instagram.png',
                            context,
                          ),
                          buildLink(
                            'mailto:ecell@kiet.edu',
                            'assets/images/google.png',
                            context,
                          ),
                          buildLink(
                            'https://www.youtube.com/channel/UCtnkeQnhcAGS_AWKgYUicEA',
                            'assets/images/youtube.png',
                            context,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildLink(String url, String icon, BuildContext context) {
    return InkWell(
      onTap: () async {
        if (await canLaunch(url)) {
          await launch(url);
        } else {
          showErrorFlush(
            context: context,
            message: 'Error loading URL, please try again!',
          );
        }
      },
      child: SizedBox(
        height: 28.w,
        width: 28.w,
        child: Image.asset(icon),
      ),
    );
  }
}
