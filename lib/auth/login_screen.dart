import 'package:endeavour22/auth/auth_provider.dart';
import 'package:endeavour22/auth/register_screen.dart';
import 'package:endeavour22/helper/http_exception.dart';
import 'package:endeavour22/helper/navigator.dart';
import 'package:endeavour22/widgets/custom_loader.dart';
import 'package:endeavour22/widgets/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  DateTime? currentBackPressTime;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _submit() async {
    setState(() {
      _isLoading = true;
    });

    final _email = _emailController.text.trim();
    final _password = _passwordController.text.trim();

    if (_email.isEmpty) {
      showErrorFlush(
        context: context,
        message: 'Email field is empty!',
      );
      setState(() {
        _isLoading = false;
      });
      return;
    } else if (_password.isEmpty) {
      showErrorFlush(
        context: context,
        message: 'Password field is empty!',
      );
      setState(() {
        _isLoading = false;
      });
      return;
    }
    // now login here
    try {
      await Provider.of<Auth>(context, listen: false).login(_email, _password);
    } on HttpException catch (error) {
      showErrorFlush(
        context: context,
        message: error.toString(),
      );
    } catch (error) {
      String errorMessage = 'Could not authenticate, please try again!';
      showErrorFlush(
        context: context,
        message: errorMessage,
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  bool _isObscure = true;
  @override
  Widget build(BuildContext context) {
    final double statusBar = MediaQuery.of(context).padding.top;
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Stack(children: [
            SvgPicture.asset(
              'assets/images/greenback.svg',
              height: 640.h,
              fit: BoxFit.fitHeight,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 42.h + statusBar),
                SizedBox(
                  height: 246.h,
                  child: Stack(
                    children: [
                      Positioned(
                        child: Text(
                          'Already\nhave an\nAccount?',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        top: 26.h,
                        left: 26.w,
                      ),
                      Positioned(
                        right: 0,
                        width: 246.h,
                        height: 246.h,
                        child: Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.rotationY(math.pi),
                          child: SvgPicture.asset(
                              'assets/images/color-scheme-left.svg'),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 42.h),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 26.w),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.white,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  width: 312.w,
                  height: 48.h,
                  child: TextField(
                    keyboardType: TextInputType.emailAddress,
                    controller: _emailController,
                    autofocus: false,
                    textAlignVertical: TextAlignVertical.center,
                    cursorColor: Colors.white,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Email',
                      hintStyle: const TextStyle(color: Colors.white),
                      icon: SizedBox(
                        width: 24.w,
                        height: 24.w,
                        child: Image.asset(
                          'assets/images/email.png',
                          color: Colors.white,
                        ),
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 26.w),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.white,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(left: 16.w),
                  width: 312.w,
                  height: 48.h,
                  child: TextField(
                    keyboardType: TextInputType.visiblePassword,
                    controller: _passwordController,
                    autofocus: false,
                    textAlignVertical: TextAlignVertical.center,
                    cursorColor: Colors.white,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                    ),
                    obscureText: _isObscure,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      hintStyle: const TextStyle(color: Colors.white),
                      icon: SizedBox(
                        width: 24.w,
                        height: 24.w,
                        child: Image.asset(
                          'assets/images/pass.png',
                          color: Colors.white,
                        ),
                      ),
                      border: InputBorder.none,
                      suffixIcon: IconButton(
                        color: Colors.black,
                        icon: Icon(
                          _isObscure ? Icons.visibility : Icons.visibility_off,
                          color: Colors.white,
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
                  child: _isLoading
                      ? SizedBox(
                          height: 48.h,
                          child: Center(
                            child: CustomLoader().buildLoader(),
                          ),
                        )
                      : InkWell(
                          onTap: _submit,
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
                                color: Colors.white,
                              ),
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
                          color: Colors.white,
                          fontSize: 16.sp,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            SlideLeftRoute(
                              page: const RegisterScreen(),
                            ),
                          );
                        },
                        child: Text(
                          'Register',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ]),
        ),
      ),
    );
  }

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > const Duration(seconds: 3)) {
      currentBackPressTime = now;
      // showNormalFlush(
      //   context: context,
      //   message: 'Press back again to exit the application!',
      // );
      const snackBar = SnackBar(
        content: Text('Press back again to exit the application!'),
        duration: Duration(seconds: 3),
      );
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(snackBar);
      return Future.value(false);
    }
    return Future.value(true);
  }
}
