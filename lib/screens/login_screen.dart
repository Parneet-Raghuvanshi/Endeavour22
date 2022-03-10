import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginScreen extends StatefulWidget {
  final VoidCallback callback;
  const LoginScreen({Key? key, required this.callback}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isObscure = true;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 26.w),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 104.h),
            Text(
              'Already\nhave an\nAccount?',
              style: TextStyle(
                color: Colors.black,
                fontSize: 28.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 114.h),
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              width: 312.w,
              height: 48.h,
              child: TextField(
                textAlignVertical: TextAlignVertical.center,
                cursorColor: Colors.black,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16.sp,
                ),
                decoration: InputDecoration(
                  hintText: 'Email',
                  icon: SizedBox(
                    width: 24.w,
                    height: 24.w,
                    child: Image.asset('assets/images/email.png'),
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
            SizedBox(height: 16.h),
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              alignment: Alignment.center,
              padding: EdgeInsets.only(left: 16.w),
              width: 312.w,
              height: 48.h,
              child: TextField(
                textAlignVertical: TextAlignVertical.center,
                cursorColor: Colors.black,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16.sp,
                ),
                obscureText: _isObscure,
                decoration: InputDecoration(
                  hintText: 'Password',
                  icon: SizedBox(
                    width: 24.w,
                    height: 24.w,
                    child: Image.asset('assets/images/pass.png'),
                  ),
                  border: InputBorder.none,
                  suffixIcon: IconButton(
                    color: Colors.black,
                    icon: Icon(
                      _isObscure ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _isObscure = !_isObscure;
                      });
                    },
                  ),
                ),
              ),
            ),
            SizedBox(height: 40.h),
            Center(
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
                  'Login',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(height: 16.h),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'New user?',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16.sp,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  InkWell(
                    onTap: widget.callback,
                    child: Text(
                      'Register',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 16.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
