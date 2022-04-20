import 'package:endeavour22/auth/auth_provider.dart';
import 'package:endeavour22/auth/profile_screen.dart';
import 'package:endeavour22/auth/user_model.dart';
import 'package:endeavour22/events/regietered_model.dart';
import 'package:endeavour22/helper/constants.dart';
import 'package:endeavour22/helper/http_exception.dart';
import 'package:endeavour22/widgets/button.dart';
import 'package:endeavour22/widgets/custom_loader.dart';
import 'package:endeavour22/widgets/custom_snackbar.dart';
import 'package:endeavour22/widgets/input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final _oldPass = TextEditingController();
  final _newPass = TextEditingController();

  @override
  void initState() {
    // TO REFRESH THE USER DATA
    final token = Provider.of<Auth>(context, listen: false).token;
    Provider.of<Auth>(context, listen: false).fetchUserData(token);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final UserModel user = Provider.of<Auth>(context).userModel!;
    final List<RegisteredModel> list = Provider.of<Auth>(context).registered;
    final statusBar = MediaQuery.of(context).padding.top;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        physics: const ScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: statusBar),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 56.w,
                  height: 56.w,
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                        margin: EdgeInsets.all(16.w),
                        child: Image.asset('assets/images/back.png')),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 16.h),
                  alignment: Alignment.center,
                  height: 96.h,
                  width: 96.h,
                  child: Text(
                    user.name[0].toUpperCase(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 56.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  decoration: const BoxDecoration(
                    //color: kLayer1Color,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        kPrimaryLight,
                        kPrimaryMid,
                      ],
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12, //New
                        blurRadius: 10.0,
                        offset: Offset(6, 6),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 56.w,
                  height: 56.w,
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (ctx) => const ProfileScreen(isUpdate: true),
                      ));
                    },
                    child: Container(
                        margin: EdgeInsets.all(16.w),
                        child: SvgPicture.asset('assets/images/edit.svg')),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Center(
              child: Text(
                user.name,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 22.sp,
                ),
              ),
            ),
            SizedBox(height: 8.h),
            Center(
              child: Text(
                user.email,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16.sp,
                ),
              ),
            ),
            SizedBox(height: 8.h),
            Center(
              child: Text(
                user.endvrid,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16.sp,
                ),
              ),
            ),
            SizedBox(height: 8.w),
            Center(
              child: InkWell(
                onTap: changePasswordCall,
                child: buildButton(name: 'ChangePassword', width: 184.w),
              ),
            ),
            SizedBox(height: 16.h),
            Container(
              color: Colors.black12,
              height: 1.h,
            ),
            SizedBox(height: 16.h),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 26.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'College',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16.sp,
                    ),
                  ),
                  SizedBox(width: 24.w),
                  Expanded(
                    child: Text(
                      user.college,
                      textAlign: TextAlign.end,
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 16.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8.h),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 26.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'College ID',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16.sp,
                    ),
                  ),
                  Text(
                    user.libId,
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 16.sp,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8.h),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 26.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Branch',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16.sp,
                    ),
                  ),
                  Text(
                    user.branch,
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 16.sp,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8.h),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 26.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Semester',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16.sp,
                    ),
                  ),
                  Text(
                    user.semester,
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 16.sp,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),
            Container(
              color: Colors.black12,
              height: 1.h,
            ),
            SizedBox(height: 16.h),
            Center(
              child: Text(
                'Registered Events',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18.sp,
                ),
              ),
            ),
            SizedBox(height: 16.h),
            list.isEmpty
                ? Container(
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset(
                          'assets/images/no_new_not.svg',
                          height: 108.w,
                          width: 108.w,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(height: 16.w),
                        Text(
                          "You haven't registered yet...",
                          style: TextStyle(fontSize: 14.sp),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.zero,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) =>
                        buildRegisteredTile(list[index], context),
                    itemCount: list.length,
                  ),
            SizedBox(height: 16.w),
          ],
        ),
      ),
    );
  }

  Future<void> changePasswordCall() async {
    bool _isLoading = false;
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (contextBuilder, setState) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'Change Password',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.sp,
              color: kPrimaryMid,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              buildInputField(
                  controller: _oldPass,
                  name: 'Old Password',
                  icon: 'assets/images/pass.png',
                  width: 288.w,
                  isObs: true,
                  isMargin: false),
              SizedBox(height: 12.w),
              buildInputField(
                  controller: _newPass,
                  name: 'New Password',
                  icon: 'assets/images/pass.png',
                  width: 288.w,
                  isObs: true,
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
                          //Navigator.of(context).pop();
                          setState(() {
                            _isLoading = true;
                          });
                          // send request for change password...
                          final newPass = _newPass.text.trim();
                          final oldPass = _oldPass.text.trim();

                          if (oldPass.isEmpty) {
                            showErrorFlush(
                              context: context,
                              message: 'Old password is empty!',
                            );
                            setState(() {
                              _isLoading = false;
                            });
                            return;
                          } else if (newPass.isEmpty) {
                            showErrorFlush(
                              context: context,
                              message: 'New password is empty!',
                            );
                            setState(() {
                              _isLoading = false;
                            });
                            return;
                          }
                          // now send request
                          try {
                            await Provider.of<Auth>(context, listen: false)
                                .changePassword(
                              oldPass,
                              newPass,
                              context,
                            );
                            _newPass.clear();
                            _oldPass.clear();
                          } on HttpException catch (error) {
                            showErrorFlush(
                              context: context,
                              message: error.toString(),
                            );
                          } catch (error) {
                            String errorMessage =
                                'Could not Change Password, please try again!';
                            showErrorFlush(
                              context: context,
                              message: errorMessage,
                            );
                          }
                          setState(() {
                            _isLoading = false;
                          });
                        },
                        child: buildButton(name: 'Update', width: 124.w),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildRegisteredTile(RegisteredModel model, BuildContext context) {
    return InkWell(
      onTap: () {
        showModalBottomSheet(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          context: context,
          builder: (context) {
            return BottomSheet(model: model);
          },
        );
      },
      child: Container(
        height: 48.w,
        width: 360.w,
        alignment: Alignment.center,
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.w),
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(8)),
            boxShadow: [
              BoxShadow(
                color: Colors.black12, //New
                blurRadius: 10.0,
                offset: Offset(0.5, 0.5),
              ),
            ]),
        child: Text(
          model.eventName,
          style: TextStyle(fontSize: 16.sp),
        ),
      ),
    );
  }
}

class BottomSheet extends StatelessWidget {
  RegisteredModel model;
  BottomSheet({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: 6.w,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(height: 16.w),
            Text(
              model.eventName,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: TextStyle(
                fontSize: 20.sp,
                color: Colors.black,
              ),
            ),
            Text(
              '(Team Details)',
              style: TextStyle(fontSize: 14.sp),
            ),
            SizedBox(height: 16.w),
            Container(
              color: Colors.black26,
              height: 1.w,
            ),
            SizedBox(height: 16.w),
            Container(
                //margin: EdgeInsets.symmetric(horizontal: 16.w),
                alignment: Alignment.centerLeft,
                child: buildTeamMembers(model.members)),
          ],
        ),
      ),
    );
  }

  Widget buildTeamMembers(List<Member> list) {
    var widgets = <Widget>[];
    for (var element in list) {
      widgets.add(buildTeamMemberTile(element));
    }
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start, children: widgets);
  }

  Widget buildTeamMemberTile(Member model) {
    return model.isLeader
        ? Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Text(
                        model.name,
                        style: TextStyle(fontSize: 16.sp),
                      ),
                      Text(
                        model.endvrid,
                        style: TextStyle(fontSize: 16.sp),
                      ),
                    ],
                  ),
                  Container(
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
                    width: 96.w,
                    height: 26.h,
                    child: Text(
                      'Leader',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.w),
            ],
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                model.name,
                style: TextStyle(fontSize: 16.sp),
              ),
              Text(
                model.endvrid,
                style: TextStyle(fontSize: 16.sp),
              ),
              SizedBox(height: 16.w),
            ],
          );
  }
}
