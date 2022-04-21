import 'package:endeavour22/auth/auth_provider.dart';
import 'package:endeavour22/helper/constants.dart';
import 'package:endeavour22/marketwatch/market_watch_provider.dart';
import 'package:endeavour22/marketwatch/market_watch_screen.dart';
import 'package:endeavour22/marketwatch/proifle_model.dart';
import 'package:endeavour22/widgets/button.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class MarketWatchStarter extends StatefulWidget {
  const MarketWatchStarter({Key? key}) : super(key: key);

  @override
  State<MarketWatchStarter> createState() => _MarketWatchStarterState();
}

class _MarketWatchStarterState extends State<MarketWatchStarter> {
  @override
  void initState() {
    fetchData();
    super.initState();
  }

  Future<void> fetchData() async {
    await Provider.of<MarketWatchProvider>(context, listen: false)
        .fetchStocks();
    final userId = Provider.of<Auth>(context, listen: false).userModel!.id;
    await Provider.of<MarketWatchProvider>(context, listen: false)
        .fetchProfileModel(userId);
    await Provider.of<MarketWatchProvider>(context, listen: false)
        .subscribeToToggle();
    await Provider.of<MarketWatchProvider>(context, listen: false)
        .subscribeToFinish();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/money.png',
                height: 184.w,
                width: 184.w,
              ),
              SizedBox(height: 24.h),
              Text(
                'Market Watch',
                style: TextStyle(
                  fontSize: 32.sp,
                  color: kPrimaryMid,
                ),
              ),
              SizedBox(height: 16.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Text(
                  "The four most dangerous words in investing are “it’s different this time” When, according to you, is the right time to invest? Do you think of yourself as a wise investor, an excellent player in the stock market?",
                  style: TextStyle(
                    fontSize: 18.sp,
                    color: kPrimaryMid,
                  ),
                  textAlign: TextAlign.justify,
                ),
              ),
            ],
          ),
          Center(
            child: InkWell(
              onTap: startNow,
              child: buildButton(
                name: 'Continue',
                width: 184.w,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void startNow() async {
    final userData = Provider.of<Auth>(context, listen: false).userModel!;
    final _profileDB =
        FirebaseDatabase.instance.reference().child('marketProfile');
    // FIRST CHECK PROFILE IS ALREADY ATTEMPTED
    await _profileDB.child(userData.id).once().then((value) async {
      if (value.snapshot.value != null) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => MarketWatchScreen(),
        ));
      } else {
        // CREATE PROFILE
        List<Company> company = [];
        final stocks =
            Provider.of<MarketWatchProvider>(context, listen: false).stocks;
        stocks.forEach((element) {
          company.add(Company(id: element.id, stocks: 0));
        });
        final profileData = ProfileModel(
          name: userData.name,
          endvrId: userData.endvrid,
          userId: userData.id,
          amount: 10000,
          company: company,
        );
        // NOW UPLOAD IT
        await _profileDB.child(userData.id).set(profileData.toMap());

        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => MarketWatchScreen(),
        ));
      }
    });
  }
}
