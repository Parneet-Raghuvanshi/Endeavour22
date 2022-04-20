import 'package:endeavour22/auth/auth_provider.dart';
import 'package:endeavour22/marketwatch/market_watch_provider.dart';
import 'package:endeavour22/marketwatch/market_watch_screen.dart';
import 'package:endeavour22/marketwatch/proifle_model.dart';
import 'package:endeavour22/widgets/button.dart';
import 'package:endeavour22/widgets/custom_snackbar.dart';
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: InkWell(
          onTap: startNow,
          child: buildButton(
            name: 'Continue',
            width: 184.w,
          ),
        ),
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
        showNormalFlush(
            context: context, message: 'Already Started The Attempt');
        return;
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
