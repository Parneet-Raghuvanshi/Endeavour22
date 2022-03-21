import 'package:endeavour22/auth/auth_provider.dart';
import 'package:endeavour22/helper/http_exception.dart';
import 'package:endeavour22/widgets/custom_loader.dart';
import 'package:endeavour22/widgets/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  final VoidCallback callback;
  const RegisterScreen({Key? key, required this.callback}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  bool _isLoading = false;

  Future<void> _submit() async {
    setState(() {
      _isLoading = true;
    });

    final _email = _emailController.text.trim();
    final _password = _passwordController.text.trim();
    final _name = _nameController.text.trim();
    final _phoneNumber = _phoneNumberController.text.trim();

    if (_email.isEmpty) {
      CustomSnackbar().showFloatingFlushBar(
        context: context,
        message: 'Email field is empty!',
        color: Colors.red,
      );
      return;
    } else if (_password.isEmpty) {
      CustomSnackbar().showFloatingFlushBar(
        context: context,
        message: 'Password field is empty!',
        color: Colors.red,
      );
      return;
    } else if (_name.isEmpty) {
      CustomSnackbar().showFloatingFlushBar(
        context: context,
        message: 'Full Name field is empty!',
        color: Colors.red,
      );
      return;
    } else if (_phoneNumber.isEmpty) {
      CustomSnackbar().showFloatingFlushBar(
        context: context,
        message: 'Phone Number field is empty!',
        color: Colors.red,
      );
      return;
    }
    // now signup here
    try {
      await Provider.of<Auth>(context, listen: false)
          .signUp(_email, _password, _phoneNumber, _name, context);
    } on HttpException catch (error) {
      CustomSnackbar().showFloatingFlushBar(
        context: context,
        message: error.toString(),
        color: Colors.red,
      );
    } catch (error) {
      String errorMessage = 'Could not Signup, please try again!';
      CustomSnackbar().showFloatingFlushBar(
        context: context,
        message: errorMessage,
        color: Colors.red,
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  bool _isObscure = true;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFF9BFFBD),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 26.w),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 64.h),
                Text(
                  'Here\'s\nyour first\nstep with Us!',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 28.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 44.h),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black,
                    ),
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  width: 312.w,
                  height: 48.h,
                  child: TextField(
                    autofocus: false,
                    controller: _emailController,
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
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(left: 16.w),
                  width: 312.w,
                  height: 48.h,
                  child: TextField(
                    autofocus: false,
                    controller: _passwordController,
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
                SizedBox(height: 16.h),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black,
                    ),
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  width: 312.w,
                  height: 48.h,
                  child: TextField(
                    autofocus: false,
                    controller: _nameController,
                    textAlignVertical: TextAlignVertical.center,
                    cursorColor: Colors.black,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16.sp,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Full Name',
                      icon: SizedBox(
                        width: 24.w,
                        height: 24.w,
                        child: Image.asset('assets/images/user.png'),
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
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  width: 312.w,
                  height: 48.h,
                  child: TextField(
                    autofocus: false,
                    controller: _phoneNumberController,
                    textAlignVertical: TextAlignVertical.center,
                    cursorColor: Colors.black,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16.sp,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Contact Number',
                      icon: SizedBox(
                        width: 24.w,
                        height: 24.w,
                        child: Image.asset('assets/images/contact.png'),
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                SizedBox(height: 24.h),
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
                              'Register',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
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
                        'Already a user?',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16.sp,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      InkWell(
                        onTap: widget.callback,
                        child: Text(
                          'Login',
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
        ),
      ),
    );
  }
}
