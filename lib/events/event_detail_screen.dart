import 'package:endeavour22/auth/auth_provider.dart';
import 'package:endeavour22/auth/user_model.dart';
import 'package:endeavour22/events/event_detail_tile.dart';
import 'package:endeavour22/events/event_content_provider.dart';
import 'package:endeavour22/events/event_model.dart';
import 'package:endeavour22/events/event_registration_provider.dart';
import 'package:endeavour22/events/faq_screen.dart';
import 'package:endeavour22/widgets/custom_loader.dart';
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
  final _razorpay = Razorpay();
  bool isRegistered = false;
  @override
  void initState() {
    Provider.of<EventContentProvider>(context, listen: false)
        .fetchData(widget.model.id);
    final registered =
        Provider.of<Auth>(context, listen: false).userModel!.registered;
    for (Registered entry in registered) {
      if (entry.event == widget.model.mongoId) {
        isRegistered = true;
      }
    }
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final List<EventDetailTile> details =
        Provider.of<EventContentProvider>(context).allContent;
    var topPadding = MediaQuery.of(context).padding.top;
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
                            height: 54.w,
                            width: 54.w,
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
              child: Text(
                "Market Watch",
                style: TextStyle(
                  fontSize: 24.sp,
                ),
              ),
            ),
            if (details.isNotEmpty) buildDetailList(details),
            if (isRegistered)
              Center(
                child: InkWell(
                  onTap: () {
                    // go to profile
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.green,
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
                    width: 196.w,
                    height: 48.h,
                    child: Text(
                      'Registered',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              )
            else
              Center(
                child: InkWell(
                  onTap: showPopup,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10.0,
                          offset: Offset(0.5, 0.5),
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    width: 196.w,
                    height: 48.h,
                    child: Text(
                      'Register',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.white,
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
          title: const Center(child: Text('Enter Team Details!')),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: TextField(
                  controller: _member1..text = userData.endvrid,
                  enabled: false,
                  autofocus: false,
                  textAlignVertical: TextAlignVertical.center,
                  cursorColor: Colors.black,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.sp,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Endeavour Id',
                    hintStyle: const TextStyle(color: Colors.black),
                    icon: SizedBox(
                      width: 24.w,
                      height: 24.w,
                      child: Image.asset(
                        'assets/images/user.png',
                        color: Colors.black,
                      ),
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
              if (memberCount > 1) SizedBox(height: 8.h),
              if (memberCount > 1)
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: TextField(
                    controller: _member2,
                    autofocus: false,
                    textAlignVertical: TextAlignVertical.center,
                    cursorColor: Colors.black,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16.sp,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Endeavour Id',
                      hintStyle: const TextStyle(color: Colors.black),
                      icon: SizedBox(
                        width: 24.w,
                        height: 24.w,
                        child: Image.asset(
                          'assets/images/user.png',
                          color: Colors.black,
                        ),
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              if (memberCount > 2) SizedBox(height: 8.h),
              if (memberCount > 2)
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: TextField(
                    controller: _member3,
                    autofocus: false,
                    textAlignVertical: TextAlignVertical.center,
                    cursorColor: Colors.black,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16.sp,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Endeavour Id',
                      hintStyle: const TextStyle(color: Colors.black),
                      icon: SizedBox(
                        width: 24.w,
                        height: 24.w,
                        child: Image.asset(
                          'assets/images/user.png',
                          color: Colors.black,
                        ),
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              if (memberCount > 3) SizedBox(height: 8.h),
              if (memberCount > 3)
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: TextField(
                    controller: _member4,
                    autofocus: false,
                    textAlignVertical: TextAlignVertical.center,
                    cursorColor: Colors.black,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16.sp,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Endeavour Id',
                      hintStyle: const TextStyle(color: Colors.black),
                      icon: SizedBox(
                        width: 24.w,
                        height: 24.w,
                        child: Image.asset(
                          'assets/images/user.png',
                          color: Colors.black,
                        ),
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              SizedBox(height: 16.h),
              Center(
                child: _isLoading
                    ? SizedBox(
                        height: 48.h,
                        child: Center(
                          child: CustomLoader().buildLoader(),
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
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black,
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
                          width: 196.w,
                          height: 48.h,
                          child: Text(
                            'Register',
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: Colors.white,
                            ),
                          ),
                        ),
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
    final PayResponse? payRes =
        await Provider.of<EventRegistrationProvider>(context, listen: false)
            .registerEvent(userId, members, widget.model.mongoId, token);
    if (payRes != null) {
      await startPayment(payRes.id, payRes.amount.toString(), name,
          'Template Desc', phoneNum, email);
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
                  widget.model.price,
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
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
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
                  width: 124.w,
                  height: 36.h,
                  child: Text(
                    'Continue',
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
    // Update User Data...
    final token = Provider.of<Auth>(context, listen: false).token;
    await Provider.of<Auth>(context, listen: false).fetchUserData(token);
    // Re-Check Event Status...
    final registered =
        Provider.of<Auth>(context, listen: false).userModel!.registered;
    for (Registered entry in registered) {
      if (entry.event == widget.model.mongoId) {
        isRegistered = true;
      }
    }
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
                  widget.model.price,
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
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
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
                  width: 124.w,
                  height: 36.h,
                  child: Text(
                    'Continue',
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.white,
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
                  widget.model.price,
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
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
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
                  width: 124.w,
                  height: 36.h,
                  child: Text(
                    'Continue',
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.white,
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
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        if (len > 1) const Text("● "),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14.sp,
            ),
          ),
        ),
      ],
    );
  }
}
