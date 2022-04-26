import 'package:endeavour22/auth/auth_provider.dart';
import 'package:endeavour22/auth/profile_view.dart';
import 'package:endeavour22/auth/user_model.dart';
import 'package:endeavour22/events/event_detail_tile.dart';
import 'package:endeavour22/events/event_content_provider.dart';
import 'package:endeavour22/events/event_model.dart';
import 'package:endeavour22/events/event_registration_provider.dart';
import 'package:endeavour22/events/faq_screen.dart';
import 'package:endeavour22/helper/constants.dart';
import 'package:endeavour22/helper/http_exception.dart';
import 'package:endeavour22/helper/navigator.dart';
import 'package:endeavour22/marketwatch/market_watch_starter.dart';
import 'package:endeavour22/widgets/button.dart';
import 'package:endeavour22/widgets/custom_loader.dart';
import 'package:endeavour22/widgets/custom_snackbar.dart';
import 'package:endeavour22/widgets/input_field.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class EventDetail extends StatefulWidget {
  final EventModel model;
  const EventDetail({Key? key, required this.model}) : super(key: key);

  @override
  State<EventDetail> createState() => _EventDetailState();
}

class _EventDetailState extends State<EventDetail> {
  bool _loading = false;
  final _razorpay = Razorpay();
  bool isRegistered = false;
  bool isLeader = false;

  @override
  void initState() {
    final registered =
        Provider.of<Auth>(context, listen: false).userModel!.registered;
    for (Registered entry in registered) {
      if (entry.event == widget.model.mongoId) {
        isRegistered = true;
        // FIND IS LEADER OR NOT...
        refreshStatus();
        break;
      }
    }
    if (!isRegistered) {
      // REFRESH USER DATA
      refreshUserData();
    }
    Provider.of<EventContentProvider>(context, listen: false)
        .fetchData(widget.model.id);
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> refreshStatus() async {
    final userData = Provider.of<Auth>(context, listen: false).userModel;
    final _toggleDB =
        FirebaseDatabase.instance.ref().child('toggle').child('marketWatch');
    await _toggleDB.once().then((value) {
      if (value.snapshot.value == true) {
        final fullData = Provider.of<Auth>(context, listen: false).registered;
        var data = fullData
            .firstWhere((element) => element.eventName == widget.model.name);
        var user = data.members
            .firstWhere((element) => element.endvrid == userData!.endvrid);
        if (user.isLeader) {
          setState(() {
            isLeader = true;
          });
        }
      }
    });
  }

  Future<void> refreshUserData() async {
    setState(() {
      _loading = true;
    });
    final token = Provider.of<Auth>(context, listen: false).token;
    await Provider.of<Auth>(context, listen: false).fetchUserData(token);
    final registered =
        Provider.of<Auth>(context, listen: false).userModel!.registered;
    for (Registered entry in registered) {
      if (entry.event == widget.model.mongoId) {
        isRegistered = true;
        break;
      }
    }
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<EventDetailTile> details =
        Provider.of<EventContentProvider>(context).allContent;
    var topPadding = MediaQuery.of(context).padding.top;
    final perc = 100 -
        ((int.parse(widget.model.discount) / int.parse(widget.model.price)) *
                100)
            .toInt();
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                SizedBox(
                  height: 125.h,
                  width: 360.w,
                  child: Image.asset(
                    "assets/images/demo_img.jpg",
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: -24.w,
                  child: Center(
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
                        ],
                      ),
                      height: 96.w,
                      width: 96.w,
                      child: Center(
                        child: Hero(
                          tag: widget.model.eventId,
                          child: Image.network(
                            widget.model.imgUri,
                            height: 64.w,
                            width: 64.w,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: topPadding,
                  left: 0,
                  width: 56.w,
                  height: 56.h,
                  child: InkWell(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                        margin: EdgeInsets.all(16.w),
                        child: Image.asset(
                          'assets/images/back.png',
                          color: Colors.white,
                        )),
                  ),
                ),
                Positioned(
                  top: topPadding,
                  right: 0,
                  width: 56.w,
                  height: 56.h,
                  child: InkWell(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FaqScreen(
                          eventId: widget.model.id,
                        ),
                      ),
                    ),
                    child: Container(
                        margin: EdgeInsets.all(16.w),
                        child: Image.asset(
                          'assets/images/faq.png',
                          color: Colors.white,
                        )),
                  ),
                ),
              ],
            ),
            SizedBox(height: 24.w),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 16.w,
              ),
              child: Column(
                children: [
                  Text(
                    widget.model.name,
                    style: TextStyle(
                      fontSize: 24.sp,
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (widget.model.isDis)
                        Text(
                          '₹ ' + widget.model.price,
                          style: TextStyle(
                            decoration: TextDecoration.lineThrough,
                            fontSize: 14.sp,
                            color: Colors.red,
                          ),
                        ),
                      SizedBox(width: 8.w),
                      Text(
                        widget.model.isDis
                            ? '₹ ' + widget.model.discount
                            : '₹ ' + widget.model.price,
                        style: TextStyle(
                          fontSize: 18.sp,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      if (widget.model.isDis)
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.orangeAccent,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12, //New
                                blurRadius: 10.0,
                                offset: Offset(0.5, 0.5),
                              ),
                            ],
                          ),
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          height: 26.h,
                          child: Text(
                            '$perc% off',
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: Colors.white,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            if (details.isNotEmpty) buildDetailList(details),
            _loading
                ? SizedBox(
                    height: 36.h,
                    child: Center(
                      child: buildLoader(36.h),
                    ),
                  )
                : isRegistered
                    ? Column(
                        children: [
                          Center(
                            child: InkWell(
                              onTap: () {
                                // go to profile
                                Navigator.of(context).push(
                                  SlideRightRoute(
                                    page: const ProfileView(),
                                  ),
                                );
                              },
                              child: buildButton(
                                  name: 'Registered',
                                  width: 184.w,
                                  isGreen: true),
                            ),
                          ),
                          if (widget.model.eventId == 'FUN1' && isLeader)
                            SizedBox(height: 16.w),
                          if (widget.model.eventId == 'FUN1' && isLeader)
                            Center(
                              child: InkWell(
                                onTap: () {
                                  // GO TO STARTER SCREEN
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          MarketWatchStarter(),
                                    ),
                                  );
                                },
                                child: buildButton(
                                    name: 'Play Now',
                                    width: 184.w,
                                    isGreen: true),
                              ),
                            ),
                        ],
                      )
                    : Center(
                        child: InkWell(
                          onTap: showPopup,
                          child: buildButton(name: 'Register', width: 184.w),
                        ),
                      ),
            SizedBox(height: 24.w),
          ],
        ),
      ),
    );
  }

  void showPopup() {
    bool _isLoading = false;
    final userData = Provider.of<Auth>(context, listen: false).userModel!;
    final int memberCount = int.parse(widget.model.memberCount);
    final _member1 = TextEditingController();
    final _member2 = TextEditingController();
    final _member3 = TextEditingController();
    final _member4 = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Center(
              child: Text(
            'Enter Team Details!',
            style: TextStyle(color: kPrimaryMid),
          )),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              buildInputField(
                  controller: _member1..text = userData.endvrid,
                  name: 'Endeavour Id',
                  icon: 'assets/images/user.png',
                  width: 288.w,
                  limit: 15,
                  isMargin: false,
                  isEnabled: false),
              if (memberCount > 1) SizedBox(height: 8.h),
              if (memberCount > 1)
                buildInputField(
                    controller: _member2,
                    name: 'Endeavour Id',
                    icon: 'assets/images/user.png',
                    width: 288.w,
                    limit: 15,
                    isMargin: false),
              if (memberCount > 2) SizedBox(height: 8.h),
              if (memberCount > 2)
                buildInputField(
                    controller: _member3,
                    name: 'Endeavour Id',
                    icon: 'assets/images/user.png',
                    width: 288.w,
                    limit: 15,
                    isMargin: false),
              if (memberCount > 3) SizedBox(height: 8.h),
              if (memberCount > 3)
                buildInputField(
                    controller: _member4,
                    name: 'Endeavour Id',
                    icon: 'assets/images/user.png',
                    width: 288.w,
                    limit: 15,
                    isMargin: false),
              SizedBox(height: 16.h),
              Center(
                child: _isLoading
                    ? SizedBox(
                        height: 48.h,
                        child: Center(
                          child: buildLoader(48.h),
                        ),
                      )
                    : InkWell(
                        onTap: () async {
                          setState(() {
                            _isLoading = true;
                          });
                          // just make popup to take endeavour id of members
                          List<String> members = [];
                          members.add(userData.endvrid);
                          if (_member2.text.trim().isNotEmpty) {
                            members.add(_member2.text.trim());
                          }
                          if (_member3.text.trim().isNotEmpty) {
                            members.add(_member3.text.trim());
                          }
                          if (_member4.text.trim().isNotEmpty) {
                            members.add(_member4.text.trim());
                          }
                          // add rest of the members in the list
                          await registerEvent(
                              userData.id,
                              members,
                              userData.name,
                              userData.phoneNumber,
                              userData.email);
                          setState(() {
                            _isLoading = false;
                          });
                        },
                        child: buildButton(name: 'Continue', width: 184.w),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> registerEvent(String userId, List<String> members, String name,
      String phoneNum, String email) async {
    final token = Provider.of<Auth>(context, listen: false).token;
    try {
      final PayResponse? payRes =
          await Provider.of<EventRegistrationProvider>(context, listen: false)
              .registerEvent(userId, members, widget.model.mongoId, token);
      if (payRes != null) {
        await startPayment(payRes.id, payRes.amount.toString(), name,
            'Template Desc', phoneNum, email);
      }
    } on HttpException catch (error) {
      showErrorFlush(
        context: context,
        message: error.toString(),
      );
    } catch (error) {
      String errorMessage = 'Could not register, please try again!';
      showErrorFlush(
        context: context,
        message: errorMessage,
      );
    }
  }

  Future<void> startPayment(String orderId, String amount, String name,
      String desc, String contact, String email) async {
    var options = {
      'key': 'rzp_test_ZPUlvsXDSMYQyQ',
      'amount': amount,
      'order_id': orderId,
      'name': name,
      'description': desc,
      'prefill': {
        'contact': contact,
        'email': email,
      }
    };
    try {
      _razorpay.open(options);
    } catch (error) {
      //handle here
      print('Error : Payment ' + error.toString());
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    // Update User Data...
    refreshUserData();
    // Do something when payment succeeds
    print("Payment Success " +
        response.paymentId.toString() +
        " " +
        response.orderId.toString());
    Navigator.of(context).pop();
    // Show Success Popup...
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          Text(
            'Transaction\nCompleted',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(width: 8.w),
          Lottie.asset(
            'assets/lottie/pay_success.json',
            height: 48.w,
            width: 48.w,
            fit: BoxFit.cover,
            repeat: false,
          ),
        ]),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              color: Colors.black26,
              height: 1.w,
            ),
            SizedBox(height: 16.w),
            Text(
              'Transaction Id:',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              alignment: Alignment.centerRight,
              child: Text(
                response.paymentId.toString(),
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 16.sp,
                ),
              ),
            ),
            Text(
              'Order Id:',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              alignment: Alignment.centerRight,
              child: Text(
                response.orderId.toString(),
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 16.sp,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Amount:',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  widget.model.isDis
                      ? '₹ ' + widget.model.discount
                      : '₹ ' + widget.model.price,
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 16.sp,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Status:',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Success',
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 16.sp,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.w),
            Center(
              child: InkWell(
                onTap: () {
                  // Finish the Popup
                  Navigator.of(context).pop();
                },
                child: buildButton(name: 'Continue', width: 124.w),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Do something when payment fails
    print("Payment Failed Error Server " +
        response.code.toString() +
        " " +
        response.message.toString());
    Navigator.of(context).pop();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          Text(
            'Transaction\nFailed',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(width: 8.w),
          Lottie.asset(
            'assets/lottie/pay_failed.json',
            height: 48.w,
            width: 48.w,
            fit: BoxFit.cover,
            repeat: false,
          ),
        ]),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              color: Colors.black26,
              height: 1.w,
            ),
            SizedBox(height: 16.w),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Amount:',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  widget.model.isDis
                      ? '₹ ' + widget.model.discount
                      : '₹ ' + widget.model.price,
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 16.sp,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Status:',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Failed',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 16.sp,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.w),
            Center(
              child: InkWell(
                onTap: () {
                  // Finish the Popup
                  Navigator.of(context).pop();
                },
                child: buildButton(name: 'Continue', width: 124.w),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet was selected
    print("Payment Failed Wallet Name" + response.walletName.toString());
    Navigator.of(context).pop();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          Text(
            'Transaction\nFailed',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(width: 8.w),
          Lottie.asset(
            'assets/lottie/pay_failed.json',
            height: 48.w,
            width: 48.w,
            fit: BoxFit.cover,
            repeat: false,
          ),
        ]),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              color: Colors.black26,
              height: 1.w,
            ),
            SizedBox(height: 16.w),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Amount:',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  widget.model.isDis
                      ? '₹ ' + widget.model.discount
                      : '₹ ' + widget.model.price,
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 16.sp,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Status:',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Failed',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 16.sp,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.w),
            Center(
              child: InkWell(
                onTap: () {
                  // Finish the Popup
                  Navigator.of(context).pop();
                },
                child: buildButton(name: 'Continue', width: 124.w),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDetailList(List<EventDetailTile> details) {
    var widgets = <Widget>[];
    for (EventDetailTile box in details) {
      widgets.add(buildTile(box.title, box.body));
    }
    return Column(
      children: widgets,
    );
  }

  Widget buildTile(String title, String body) {
    List<String> bodyStr = body.split("[dot]");
    var lines = <Widget>[];
    for (String line in bodyStr) {
      lines.add(bulletLine(line, bodyStr.length));
    }
    return Container(
      margin: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 4.h),
          Column(
            children: lines,
          )
        ],
      ),
    );
  }

  Widget bulletLine(String text, int len) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (len > 1) const Text("● "),
        Expanded(
          child: Text(
            text.replaceAll('\\n', '\n'),
            style: TextStyle(
              fontSize: 14.sp,
            ),
          ),
        ),
      ],
    );
  }
}
