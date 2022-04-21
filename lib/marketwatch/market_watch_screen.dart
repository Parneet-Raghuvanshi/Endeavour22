import 'package:endeavour22/auth/auth_provider.dart';
import 'package:endeavour22/helper/constants.dart';
import 'package:endeavour22/marketwatch/main_model.dart';
import 'package:endeavour22/marketwatch/market_watch_provider.dart';
import 'package:endeavour22/widgets/button.dart';
import 'package:endeavour22/widgets/custom_loader.dart';
import 'package:endeavour22/widgets/custom_snackbar.dart';
import 'package:endeavour22/widgets/input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MarketWatchScreen extends StatefulWidget {
  const MarketWatchScreen({Key? key}) : super(key: key);

  @override
  State<MarketWatchScreen> createState() => _MarketWatchScreenState();
}

class _MarketWatchScreenState extends State<MarketWatchScreen> {
  List<TextEditingController> _controller = [];
  var formatter = NumberFormat('#,##,000');

  @override
  void initState() {
    final length =
        Provider.of<MarketWatchProvider>(context, listen: false).stocks.length;
    _controller = List.generate(length, (i) => TextEditingController());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _toggle = Provider.of<MarketWatchProvider>(context).toggleStatus;
    final _finished = Provider.of<MarketWatchProvider>(context).finished;
    final statusBarHeight = MediaQuery.of(context).padding.top;
    final model = Provider.of<MarketWatchProvider>(context).profile;
    final round = Provider.of<MarketWatchProvider>(context).stocks[0].round;
    return WillPopScope(
      onWillPop: () async {
        showNormalFlush(
            context: context,
            message: "You can't exit application during this moment...");
        return false;
      },
      child: Scaffold(
        body: _finished
            ? buildFinishPage()
            : SingleChildScrollView(
                child: Container(
                  height: 640.h,
                  padding: EdgeInsets.only(top: statusBarHeight),
                  child: Stack(
                    children: [
                      Positioned(
                        width: 360.w,
                        height: 56.h,
                        right: 0,
                        child: Container(
                          alignment: Alignment.center,
                          child: Text(
                            'Market Watch',
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
                        left: 0,
                        height: 44.h,
                        width: 180.w,
                        child: Container(
                          alignment: Alignment.center,
                          child: Text(
                            round,
                            style: TextStyle(
                              fontSize: 20.sp,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        top: 56.h,
                        height: 48.h,
                        width: 180.w,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/money.png',
                              height: 36.w,
                              width: 36.w,
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              model!.amount > 999
                                  ? formatter.format(model.amount)
                                  : model.amount.toString(),
                              style: TextStyle(
                                fontSize: 18.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        top: 104.h,
                        width: 360.w,
                        height: 640.h - 56.h - 48.h - statusBarHeight,
                        child: _toggle
                            ? buildCardList()
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Center(
                                    child: Text(
                                      'Updating',
                                      style: TextStyle(fontSize: 18.sp),
                                    ),
                                  ),
                                  Center(
                                    child: buildLoader(48.h),
                                  ),
                                ],
                              ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget buildFinishPage() {
    int worth = Provider.of<MarketWatchProvider>(context).totalWorth;
    return Column(
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
              'Thank You For Playing!',
              style: TextStyle(
                fontSize: 28.sp,
                color: kPrimaryMid,
              ),
            ),
            SizedBox(height: 24.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Text(
                "Your Total Worth",
                style: TextStyle(
                  fontSize: 24.sp,
                  color: kPrimaryMid,
                ),
                textAlign: TextAlign.justify,
              ),
            ),
            SizedBox(height: 8.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/money_single.png',
                  height: 36.w,
                  width: 36.w,
                ),
                SizedBox(width: 8.w),
                Text(
                  worth > 999 ? formatter.format(worth) : worth.toString(),
                  style: TextStyle(
                    fontSize: 24.sp,
                    color: kPrimaryMid,
                  ),
                ),
              ],
            ),
          ],
        ),
        Center(
          child: InkWell(
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: buildButton(
              name: 'Finish',
              width: 184.w,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildCardList() {
    return Consumer<MarketWatchProvider>(
      builder: (ctx, value, _) => ListView.builder(
        padding: EdgeInsets.symmetric(vertical: 4.w),
        itemBuilder: (context, index) => Container(
          child: buildCard(value.mainStocks[index], index),
        ),
        itemCount: value.mainStocks.length,
      ),
    );
  }

  Widget buildCard(MainModel data, int index) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(16)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12, //New
            blurRadius: 10.0,
            offset: Offset(0.5, 0.5),
          ),
        ],
      ),
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.w),
      height: 128.h,
      width: 328.w,
      child: Stack(
        children: [
          Positioned(
            width: 164.w,
            left: 0,
            height: 36.h,
            child: Container(
              alignment: Alignment.center,
              child: Text(
                data.name,
                style: TextStyle(fontSize: 20.sp),
              ),
            ),
          ),
          Positioned(
            right: 0,
            width: 164.w,
            height: 38.h,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  data.isUp
                      ? 'assets/images/upward-arrow.png'
                      : 'assets/images/downward-arrow.png',
                  height: 24.w,
                  width: 24.w,
                  color: data.isUp ? Colors.green : Colors.red,
                ),
                SizedBox(width: 8.w),
                Text(
                  data.rate > 999
                      ? formatter.format(data.rate)
                      : data.rate.toString(),
                  style: TextStyle(
                    fontSize: 18.sp,
                    color: data.isUp ? Colors.green : Colors.red,
                  ),
                )
              ],
            ),
          ),
          Positioned(
            top: 38.h,
            height: 38.h,
            width: 328.w,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/box.png',
                  height: 20.w,
                  width: 20.w,
                ),
                SizedBox(width: 8.w),
                Text(
                  data.stocks > 999
                      ? formatter.format(data.stocks)
                      : data.stocks.toString(),
                  style: TextStyle(
                    fontSize: 16.sp,
                  ),
                ),
                Text(
                  ' Owned  =  ',
                  style: TextStyle(
                    fontSize: 16.sp,
                  ),
                ),
                Image.asset(
                  'assets/images/money_single.png',
                  height: 20.w,
                  width: 20.w,
                ),
                SizedBox(width: 8.w),
                Text(
                  data.worth > 999
                      ? formatter.format(data.worth)
                      : data.worth.toString(),
                  style: TextStyle(
                    fontSize: 16.sp,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 38.h + 38.h,
            height: 48.h,
            width: 328.w,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buildInputField(
                    controller: _controller[index],
                    name: 'Stocks...',
                    icon: '',
                    width: 104.w,
                    isMargin: false,
                    hideIcon: true,
                    limit: 6),
                InkWell(
                  onTap: () async {
                    if (_controller[index].text.isNotEmpty) {
                      int qty = int.parse(_controller[index].text.trim());
                      if (qty > 0 && qty <= data.stocks) {
                        // CAN BUY STOCKS...
                        final userId = Provider.of<Auth>(context, listen: false)
                            .userModel!
                            .id;
                        await Provider.of<MarketWatchProvider>(context,
                                listen: false)
                            .sellStocks(qty, data, userId);
                      } else {
                        showErrorFlush(
                            context: context,
                            message: "You don't have enough stocks!");
                      }
                      _controller[index].clear();
                    }
                  },
                  child: buildButton(name: 'Sell', width: 96.w, h: 44.h),
                ),
                InkWell(
                  onTap: () async {
                    if (_controller[index].text.isNotEmpty) {
                      int qty = int.parse(_controller[index].text.trim());
                      if (qty > 0) {
                        // CAN BUY STOCKS...
                        final userId = Provider.of<Auth>(context, listen: false)
                            .userModel!
                            .id;
                        await Provider.of<MarketWatchProvider>(context,
                                listen: false)
                            .buyStocks(qty, data, userId, context);
                      } else {
                        showErrorFlush(
                            context: context, message: "Can't buy 0 stocks...");
                      }
                      _controller[index].clear();
                    }
                  },
                  child: buildButton(name: 'Buy', width: 96.w, h: 44.h),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
