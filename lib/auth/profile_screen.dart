import 'package:endeavour22/auth/auth_provider.dart';
import 'package:endeavour22/auth/user_model.dart';
import 'package:endeavour22/helper/http_exception.dart';
import 'package:endeavour22/widgets/custom_loader.dart';
import 'package:endeavour22/widgets/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 26.w),
                  child: Text(
                    widget.isUpdate
                        ? 'Please\nupdate your\nprofile!'
                        : 'Just one\nmore step\nto go!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: widget.isUpdate ? 36.h : 70.h),
                if (widget.isUpdate)
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
                    controller: _clgNameController,
                    textAlignVertical: TextAlignVertical.center,
                    cursorColor: Colors.white,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                    ),
                    decoration: InputDecoration(
                      hintText: 'College Name',
                      hintStyle: const TextStyle(color: Colors.white),
                      icon: SizedBox(
                        width: 24.w,
                        height: 24.w,
                        child: Image.asset(
                          'assets/images/college.png',
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
                    controller: _clgIdController,
                    textAlignVertical: TextAlignVertical.center,
                    cursorColor: Colors.white,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                    ),
                    decoration: InputDecoration(
                      hintText: 'College Id',
                      hintStyle: const TextStyle(color: Colors.white),
                      icon: SizedBox(
                        width: 24.w,
                        height: 24.w,
                        child: Image.asset(
                          'assets/images/clgid.png',
                          color: Colors.white,
                        ),
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
                          color: Colors.white,
                        ),
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
                        cursorColor: Colors.white,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Branch',
                          hintStyle: const TextStyle(color: Colors.white),
                          icon: SizedBox(
                            width: 24.w,
                            height: 24.w,
                            child: Image.asset(
                              'assets/images/branch.png',
                              color: Colors.white,
                            ),
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.white,
                        ),
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
                        cursorColor: Colors.white,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Sem',
                          hintStyle: const TextStyle(color: Colors.white),
                          icon: SizedBox(
                            width: 24.w,
                            height: 24.w,
                            child: Image.asset(
                              'assets/images/sem.png',
                              color: Colors.white,
                            ),
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
                          onTap: () {
                            _submit();
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
                              widget.isUpdate ? 'Save' : 'Continue',
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
          ],
        ),
      ),
    );
  }
}
