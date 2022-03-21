import 'package:endeavour22/auth/auth_provider.dart';
import 'package:endeavour22/helper/http_exception.dart';
import 'package:endeavour22/widgets/custom_loader.dart';
import 'package:endeavour22/widgets/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _clgNameController = TextEditingController();
  final _clgIdController = TextEditingController();
  final _branchController = TextEditingController();
  final _semController = TextEditingController();
  bool _isLoading = false;

  Future<void> _submit() async {
    setState(() {
      _isLoading = true;
    });

    final _clgName = _clgNameController.text.trim();
    final _clgId = _clgIdController.text.trim();
    final _branch = _branchController.text.trim();
    final _sem = _semController.text.trim();

    if (_clgName.isEmpty) {
      CustomSnackbar().showFloatingFlushBar(
        context: context,
        message: 'College Name is empty!',
        color: Colors.red,
      );
      return;
    } else if (_clgId.isEmpty) {
      CustomSnackbar().showFloatingFlushBar(
        context: context,
        message: 'College Id is empty!',
        color: Colors.red,
      );
      return;
    } else if (_branch.isEmpty) {
      CustomSnackbar().showFloatingFlushBar(
        context: context,
        message: 'Branch field is empty!',
        color: Colors.red,
      );
      return;
    } else if (_sem.isEmpty) {
      CustomSnackbar().showFloatingFlushBar(
        context: context,
        message: 'Semester field is empty!',
        color: Colors.red,
      );
      return;
    }
    // now signup here
    try {
      await Provider.of<Auth>(context, listen: false)
          .updateProfile(_clgName, _clgId, _branch, _sem, context, true);
    } on HttpException catch (error) {
      CustomSnackbar().showFloatingFlushBar(
        context: context,
        message: error.toString(),
        color: Colors.red,
      );
    } catch (error) {
      String errorMessage = 'Could not Complete Profile, please try again!';
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        //backgroundColor: const Color(0xFF9BFFBD),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 26.w),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 64.h),
                Text(
                  'Just one\nmore step\nto go!',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 28.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 70.h),
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
                    controller: _clgNameController,
                    textAlignVertical: TextAlignVertical.center,
                    cursorColor: Colors.black,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16.sp,
                    ),
                    decoration: InputDecoration(
                      hintText: 'College Name',
                      icon: SizedBox(
                        width: 24.w,
                        height: 24.w,
                        child: Image.asset('assets/images/college.png'),
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
                    controller: _clgIdController,
                    textAlignVertical: TextAlignVertical.center,
                    cursorColor: Colors.black,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16.sp,
                    ),
                    decoration: InputDecoration(
                      hintText: 'College Id',
                      icon: SizedBox(
                        width: 24.w,
                        height: 24.w,
                        child: Image.asset('assets/images/clgid.png'),
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
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
                      width: 146.w,
                      height: 48.h,
                      child: TextField(
                        autofocus: false,
                        controller: _branchController,
                        textAlignVertical: TextAlignVertical.center,
                        cursorColor: Colors.black,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16.sp,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Branch',
                          icon: SizedBox(
                            width: 24.w,
                            height: 24.w,
                            child: Image.asset('assets/images/branch.png'),
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    SizedBox(width: 16.w),
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
                      width: 146.w,
                      height: 48.h,
                      child: TextField(
                        autofocus: false,
                        controller: _semController,
                        textAlignVertical: TextAlignVertical.center,
                        cursorColor: Colors.black,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16.sp,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Sem',
                          icon: SizedBox(
                            width: 24.w,
                            height: 24.w,
                            child: Image.asset('assets/images/sem.png'),
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 58.h),
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
                              'Continue',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
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
      ),
    );
  }
}
