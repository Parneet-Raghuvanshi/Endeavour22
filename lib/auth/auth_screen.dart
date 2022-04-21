import 'package:endeavour22/auth/auth_provider.dart';
import 'package:endeavour22/helper/constants.dart';
import 'package:endeavour22/helper/http_exception.dart';
import 'package:endeavour22/widgets/button.dart';
import 'package:endeavour22/widgets/custom_loader.dart';
import 'package:endeavour22/widgets/custom_snackbar.dart';
import 'package:endeavour22/widgets/input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  DateTime? currentBackPressTime;
  bool isDragging = false;

  // LOGIN CRED
  final _emailLoginController = TextEditingController();
  final _passwordLoginController = TextEditingController();
  final _emailLoginForgot = TextEditingController();
  bool _isLoadingLogin = false;

  // REGISTER CRED
  final _emailRegisterController = TextEditingController();
  final _passwordRegisterController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  bool _isLoadingRegister = false;

  var duration = 600;

  bool _isLogin = true;

  Future<void> _submitLogin() async {
    setState(() {
      _isLoadingLogin = true;
    });

    final _email = _emailLoginController.text.trim();
    final _password = _passwordLoginController.text.trim();

    if (_email.isEmpty) {
      showErrorFlush(
        context: context,
        message: 'Email field is empty!',
      );
      setState(() {
        _isLoadingLogin = false;
      });
      return;
    } else if (_password.isEmpty) {
      showErrorFlush(
        context: context,
        message: 'Password field is empty!',
      );
      setState(() {
        _isLoadingLogin = false;
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
      setState(() {
        _isLoadingLogin = false;
      });
    } catch (error) {
      String errorMessage = 'Could not authenticate, please try again!';
      showErrorFlush(
        context: context,
        message: errorMessage,
      );
      setState(() {
        _isLoadingLogin = false;
      });
    }
  }

  Future<void> _submitRegister() async {
    setState(() {
      _isLoadingRegister = true;
    });

    final _email = _emailRegisterController.text.trim();
    final _password = _passwordRegisterController.text.trim();
    final _name = _nameController.text.trim();
    final _phoneNumber = _phoneNumberController.text.trim();

    if (_email.isEmpty) {
      showErrorFlush(
        context: context,
        message: 'Email field is empty!',
      );
      setState(() {
        _isLoadingRegister = false;
      });
      return;
    } else if (_password.isEmpty) {
      showErrorFlush(
        context: context,
        message: 'Password field is empty!',
      );
      setState(() {
        _isLoadingRegister = false;
      });
      return;
    } else if (_name.isEmpty) {
      showErrorFlush(
        context: context,
        message: 'Full Name field is empty!',
      );
      setState(() {
        _isLoadingRegister = false;
      });
      return;
    } else if (_phoneNumber.isEmpty) {
      showErrorFlush(
        context: context,
        message: 'Phone Number field is empty!',
      );
      setState(() {
        _isLoadingRegister = false;
      });
      return;
    }
    // now signup here
    try {
      await Provider.of<Auth>(context, listen: false)
          .signUp(_email, _password, _phoneNumber, _name, context);
      showNormalFlush(
        context: context,
        message:
            "Account Created Successfully, please very you email and then longin!",
      );
      setState(() {
        _isLogin = true;
      });
      _emailRegisterController.clear();
      _passwordRegisterController.clear();
      _nameController.clear();
      _phoneNumberController.clear();
    } on HttpException catch (error) {
      showErrorFlush(
        context: context,
        message: error.toString(),
      );
    } catch (error) {
      String errorMessage = 'Could not Signup, please try again!';
      showErrorFlush(
        context: context,
        message: errorMessage,
      );
    }

    setState(() {
      _isLoadingRegister = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double statusBar = MediaQuery.of(context).padding.top;
    return WillPopScope(
      onWillPop: onWillPop,
      child: GestureDetector(
        onHorizontalDragStart: (details) => isDragging = true,
        onHorizontalDragUpdate: (details) {
          if (!isDragging) return;
          const delta = 1;
          if (details.delta.dx > delta) {
            setState(() {
              _isLogin = true;
            });
          } else if (details.delta.dx < -delta) {
            setState(() {
              _isLogin = false;
            });
          }
          isDragging = false;
        },
        child: Stack(
          children: [
            AnimatedPositioned(
              curve: Curves.ease,
              width: 1600.w,
              height: 640.h,
              left: _isLogin ? -360.w : -720.w,
              child: Container(
                alignment: Alignment.center,
                child: Image.asset(
                  'assets/images/moon_back.jpg',
                  fit: BoxFit.fitHeight,
                ),
              ),
              duration: Duration(milliseconds: duration),
            ),
            Positioned(
              child: Opacity(
                opacity: 0.4,
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        kPrimaryLight,
                        kPrimaryDark,
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Scaffold(
              backgroundColor: Colors.transparent,
              body: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.only(top: statusBar),
                  alignment: Alignment.center,
                  height: 640.h,
                  child: Stack(
                    children: [
                      AnimatedPositioned(
                        top: 108.h,
                        left: _isLogin ? 26.w : -120.w,
                        child: AnimatedOpacity(
                          curve: Curves.ease,
                          opacity: _isLogin ? 1 : 0,
                          duration: Duration(milliseconds: duration),
                          child: Text(
                            'Already\nhave an\nAccount?',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 28.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        curve: Curves.ease,
                        duration: Duration(milliseconds: duration),
                      ),
                      AnimatedPositioned(
                        top: 32.h,
                        right: !_isLogin ? 26.w : -120.w,
                        child: AnimatedOpacity(
                          curve: Curves.ease,
                          opacity: !_isLogin ? 1 : 0,
                          duration: Duration(milliseconds: duration),
                          child: Text(
                            'Here\'s\nyour first\nstep with Us!',
                            textAlign: TextAlign.end,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 28.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        curve: Curves.ease,
                        duration: Duration(milliseconds: duration),
                      ),
                      // THIS IS LOGIN PAGE
                      buildLogin(),
                      // THIS IS SIGNUP
                      buildSignUp(),
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

  Widget buildLogin() {
    return AnimatedPositioned(
      curve: Curves.ease,
      left: _isLogin ? 0.w : -360.w,
      duration: Duration(milliseconds: duration),
      bottom: 16.h,
      width: 360.w,
      child: AnimatedOpacity(
        curve: Curves.ease,
        opacity: _isLogin ? 1 : 0,
        duration: Duration(milliseconds: duration),
        child: AnimatedScale(
          curve: Curves.ease,
          duration: Duration(milliseconds: duration),
          scale: _isLogin ? 1 : 0.6,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 24.w),
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
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: 16.h),
                      Text(
                        'Continue with Credentials!',
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: kPrimaryMid,
                        ),
                      ),
                      SizedBox(height: 24.h),
                      buildInputField(
                          controller: _emailLoginController,
                          name: 'Email',
                          icon: 'assets/images/email.png',
                          width: 288.w),
                      SizedBox(height: 12.h),
                      buildInputField(
                          controller: _passwordLoginController,
                          name: 'Password',
                          icon: 'assets/images/pass.png',
                          width: 288.w,
                          isObs: true),
                      SizedBox(height: 24.h),
                      _isLoadingLogin
                          ? SizedBox(
                              height: 36.h,
                              child: Center(
                                child: buildLoader(36.h),
                              ),
                            )
                          : InkWell(
                              onTap: _submitLogin,
                              child: buildButton(name: 'Login', width: 184.w),
                            ),
                      SizedBox(height: 8.h),
                      InkWell(
                        onTap: forgotPass,
                        child: Text(
                          'Forgot Password?',
                          style: TextStyle(fontSize: 16.sp, color: kPrimaryMid),
                        ),
                      ),
                      SizedBox(height: 12.h),
                    ],
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
                        setState(() {
                          _isLogin = false;
                        });
                      },
                      child: Text(
                        'Register',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 16.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSignUp() {
    return AnimatedPositioned(
      width: 360.w,
      curve: Curves.ease,
      right: _isLogin ? -360.w : 0.w,
      duration: Duration(milliseconds: duration),
      bottom: 16.h,
      child: AnimatedOpacity(
        curve: Curves.ease,
        opacity: _isLogin ? 0 : 1,
        duration: Duration(milliseconds: duration),
        child: AnimatedScale(
          curve: Curves.ease,
          duration: Duration(milliseconds: duration),
          scale: _isLogin ? 0.6 : 1,
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 24.w),
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
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 18.h),
                    Text(
                      'Create New Account!',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: kPrimaryMid,
                      ),
                    ),
                    SizedBox(height: 24.h),
                    buildInputField(
                        controller: _emailRegisterController,
                        name: 'Email',
                        icon: 'assets/images/email.png',
                        width: 288.w),
                    SizedBox(height: 12.h),
                    buildInputField(
                        controller: _passwordRegisterController,
                        name: 'Password',
                        icon: 'assets/images/pass.png',
                        width: 288.w,
                        isObs: true),
                    SizedBox(height: 12.h),
                    buildInputField(
                        controller: _nameController,
                        name: 'Full Name',
                        icon: 'assets/images/user.png',
                        width: 288.w),
                    SizedBox(height: 12.h),
                    buildInputField(
                        controller: _phoneNumberController,
                        name: 'Contact Number',
                        icon: 'assets/images/contact.png',
                        width: 288.w,
                        limit: 10),
                    SizedBox(height: 24.h),
                    _isLoadingRegister
                        ? SizedBox(
                            height: 36.h,
                            child: Center(
                              child: buildLoader(36.h),
                            ),
                          )
                        : InkWell(
                            onTap: _submitRegister,
                            child: buildButton(name: 'Register', width: 184.w),
                          ),
                    SizedBox(height: 16.h),
                  ],
                ),
              ),
              SizedBox(height: 16.h),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already a user?',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    InkWell(
                      onTap: () {
                        setState(() {
                          _isLogin = true;
                        });
                      },
                      child: Text(
                        'Login',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 16.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> forgotPass() async {
    bool _isLoading = false;
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Forgot Password',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: kPrimaryMid,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '(Enter registered email address!)',
                style: TextStyle(fontSize: 14.sp),
              ),
              SizedBox(height: 16.w),
              buildInputField(
                  controller: _emailLoginForgot,
                  name: 'Registered Email',
                  icon: 'assets/images/email.png',
                  width: 288.w,
                  isMargin: false),
              SizedBox(height: 16.w),
              Center(
                child: _isLoading
                    ? SizedBox(
                        height: 36.h,
                        child: Center(
                          child: buildLoader(36.h),
                        ),
                      )
                    : InkWell(
                        onTap: () async {
                          setState(() {
                            _isLoading = true;
                          });
                          // send request for change password...
                          final email = _emailLoginForgot.text.trim();

                          if (email.isEmpty) {
                            showErrorFlush(
                              context: context,
                              message: 'Email field is empty!',
                            );
                            setState(() {
                              _isLoading = false;
                            });
                            return;
                          }
                          // now send request
                          try {
                            await Provider.of<Auth>(context, listen: false)
                                .forgotPassword(email, context);
                            _emailLoginForgot.clear();
                          } on HttpException catch (error) {
                            showErrorFlush(
                              context: context,
                              message: error.toString(),
                            );
                          } catch (error) {
                            String errorMessage =
                                'Could not send request, please try again!';
                            showErrorFlush(
                              context: context,
                              message: errorMessage,
                            );
                          }
                          setState(() {
                            _isLoading = false;
                          });
                        },
                        child: buildButton(name: 'Request', width: 124.w),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > const Duration(seconds: 3)) {
      currentBackPressTime = now;
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
