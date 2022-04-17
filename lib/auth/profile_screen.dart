import 'package:endeavour22/auth/auth_provider.dart';
import 'package:endeavour22/auth/user_model.dart';
import 'package:endeavour22/helper/constants.dart';
import 'package:endeavour22/helper/http_exception.dart';
import 'package:endeavour22/widgets/button.dart';
import 'package:endeavour22/widgets/custom_loader.dart';
import 'package:endeavour22/widgets/custom_snackbar.dart';
import 'package:endeavour22/widgets/input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  final bool isUpdate;
  const ProfileScreen({Key? key, required this.isUpdate}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _clgNameController = TextEditingController();
  final _clgIdController = TextEditingController();
  final _branchController = TextEditingController();
  final _semController = TextEditingController();
  final _nameController = TextEditingController();
  bool _isLoading = false;

  Future<void> _submit() async {
    setState(() {
      _isLoading = true;
    });

    final _clgName = _clgNameController.text.trim();
    final _clgId = _clgIdController.text.trim();
    final _branch = _branchController.text.trim();
    final _sem = _semController.text.trim();
    final _name = _nameController.text.trim();

    if (_name == '') {
      showErrorFlush(
        context: context,
        message: 'Your Name is empty!',
      );
      setState(() {
        _isLoading = false;
      });
      return;
    }
    if (_clgName.isEmpty) {
      showErrorFlush(
        context: context,
        message: 'College Name is empty!',
      );
      setState(() {
        _isLoading = false;
      });
      return;
    } else if (_clgId.isEmpty) {
      showErrorFlush(
        context: context,
        message: 'College Id is empty!',
      );
      setState(() {
        _isLoading = false;
      });
      return;
    } else if (_branch.isEmpty) {
      showErrorFlush(
        context: context,
        message: 'Branch field is empty!',
      );
      setState(() {
        _isLoading = false;
      });
      return;
    } else if (_sem.isEmpty) {
      showErrorFlush(
        context: context,
        message: 'Semester field is empty!',
      );
      setState(() {
        _isLoading = false;
      });
      return;
    }
    // now signup here
    try {
      await Provider.of<Auth>(context, listen: false).updateProfile(
          _clgName, _clgId, _branch, _sem, _name, context, !widget.isUpdate);
    } on HttpException catch (error) {
      showErrorFlush(
        context: context,
        message: error.toString(),
      );
    } catch (error) {
      String errorMessage = 'Could not Complete Profile, please try again!';
      showErrorFlush(
        context: context,
        message: errorMessage,
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    final UserModel user = Provider.of<Auth>(context, listen: false).userModel!;
    _nameController.text = user.name;
    _nameController.selection = TextSelection.fromPosition(
        TextPosition(offset: _nameController.text.length));
    if (widget.isUpdate) {
      _clgNameController.text = user.college;
      _clgNameController.selection = TextSelection.fromPosition(
          TextPosition(offset: _clgNameController.text.length));
      _clgIdController.text = user.libId;
      _clgIdController.selection = TextSelection.fromPosition(
          TextPosition(offset: _clgIdController.text.length));
      _branchController.text = user.branch;
      _branchController.selection = TextSelection.fromPosition(
          TextPosition(offset: _branchController.text.length));
      _semController.text = user.semester;
      _semController.selection = TextSelection.fromPosition(
          TextPosition(offset: _semController.text.length));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double statusBar = MediaQuery.of(context).padding.top;
    return Stack(
      children: [
        Positioned(
          width: 1600.w,
          height: 640.h,
          left: -360.w,
          child: Container(
            alignment: Alignment.center,
            child: Image.asset(
              'assets/images/moon_back.jpg',
              fit: BoxFit.fitHeight,
            ),
          ),
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
                  Positioned(
                    top: widget.isUpdate ? 76.h : 108.h,
                    left: 26.w,
                    child: Text(
                      widget.isUpdate
                          ? 'Please\nupdate your\nprofile!'
                          : 'Just one\nmore step\nto go!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  buildUpdate(),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildUpdate() {
    return Positioned(
      width: 360.w,
      bottom: 16.h,
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
                  widget.isUpdate
                      ? 'Check your details!'
                      : 'Update your details!',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: kPrimaryMid,
                  ),
                ),
                SizedBox(height: 24.h),
                if (widget.isUpdate)
                  buildInputField(
                      controller: _nameController,
                      name: 'Full Name',
                      icon: 'assets/images/user.png',
                      width: 288.w),
                if (widget.isUpdate) SizedBox(height: 12.h),
                buildInputField(
                    controller: _clgNameController,
                    name: 'College Name',
                    icon: 'assets/images/college.png',
                    width: 288.w),
                SizedBox(height: 12.h),
                buildInputField(
                    controller: _clgIdController,
                    name: 'College Id',
                    icon: 'assets/images/clgid.png',
                    width: 288.w),
                SizedBox(height: 12.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    buildInputField(
                        controller: _branchController,
                        name: 'Branch',
                        icon: 'assets/images/branch.png',
                        width: 124.w),
                    buildInputField(
                        controller: _semController,
                        name: 'Sem',
                        icon: 'assets/images/sem.png',
                        width: 124.w,
                        limit: 1),
                  ],
                ),
                SizedBox(height: 24.h),
                _isLoading
                    ? SizedBox(
                        height: 36.h,
                        child: Center(
                          child: buildLoader(36.h),
                        ),
                      )
                    : InkWell(
                        onTap: _submit,
                        child: buildButton(
                            name: widget.isUpdate ? 'Save' : 'Finish',
                            width: 184.w),
                      ),
                SizedBox(height: 16.h),
              ],
            ),
          ),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }
}
