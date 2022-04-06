import 'package:endeavour22/auth/auth_provider.dart';
import 'package:endeavour22/helper/constants.dart';
import 'package:endeavour22/helper/http_exception.dart';
import 'package:endeavour22/widgets/custom_loader.dart';
import 'package:endeavour22/widgets/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

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
    } else if (_name.isEmpty) {
      showErrorFlush(
        context: context,
        message: 'Full Name field is empty!',
      );
      setState(() {
        _isLoading = false;
      });
      return;
    } else if (_phoneNumber.isEmpty) {
      showErrorFlush(
        context: context,
        message: 'Phone Number field is empty!',
      );
      setState(() {
        _isLoading = false;
      });
      return;
    }
    // now signup here
    try {
      await Provider.of<Auth>(context, listen: false)
          .signUp(_email, _password, _phoneNumber, _name, context);
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
      _isLoading = false;
    });
  }

  bool _isObscure = true;
  @override
  Widget build(BuildContext context) {
    final double statusBar = MediaQuery.of(context).padding.top;
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            SvgPicture.asset(
              'assets/images/greenback.svg',
              height: 640.h,
              fit: BoxFit.fitHeight,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 64.h + statusBar),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 26.w),
                  child: Text(
                    'Here\'s\nyour first\nstep with Us!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 44.h),
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
                    autofocus: false,
                    controller: _emailController,
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
                    autofocus: false,
                    controller: _passwordController,
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
                        color: Colors.white,
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
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  width: 312.w,
                  height: 48.h,
                  child: TextField(
                    autofocus: false,
                    controller: _nameController,
                    textAlignVertical: TextAlignVertical.center,
                    cursorColor: Colors.white,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Full Name',
                      hintStyle: const TextStyle(color: Colors.white),
                      icon: SizedBox(
                        width: 24.w,
                        height: 24.w,
                        child: Image.asset(
                          'assets/images/user.png',
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
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  width: 312.w,
                  height: 48.h,
                  child: TextField(
                    autofocus: false,
                    controller: _phoneNumberController,
                    textAlignVertical: TextAlignVertical.center,
                    cursorColor: Colors.white,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Contact Number',
                      hintStyle: const TextStyle(color: Colors.white),
                      icon: SizedBox(
                        width: 24.w,
                        height: 24.w,
                        child: Image.asset(
                          'assets/images/contact.png',
                          color: Colors.white,
                        ),
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
                          color: Colors.white,
                          fontSize: 16.sp,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          'Login',
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
          ],
        ),
      ),
    );
  }
}
