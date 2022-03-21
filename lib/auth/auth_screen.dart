import 'package:endeavour22/auth/login_screen.dart';
import 'package:endeavour22/auth/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  late double xOffset;
  late bool isLoginOpen;
  bool isDragging = false;

  @override
  void initState() {
    super.initState();
    openLogin();
  }

  void closeLogin() => setState(() {
        xOffset = 0;
        isLoginOpen = false;
      });

  void openLogin() => setState(() {
        xOffset = 360.w;
        isLoginOpen = true;
      });

  @override
  Widget build(BuildContext context) {
    double keyboard = MediaQuery.of(context).viewInsets.bottom;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            buildLogin(),
            buildRegister(),
            if (!isLoginOpen)
              Positioned(
                left: 0,
                height: 640.h,
                width: 8.w,
                child: Container(
                  color: Colors.white,
                ),
              ),
            if (!isLoginOpen && keyboard == 0)
              Positioned(
                bottom: 64.h,
                left: 0,
                height: 64.h,
                width: 36.w,
                child: GestureDetector(
                  onTap: openLogin,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(50),
                      bottomRight: Radius.circular(50),
                    ),
                    child: Container(
                      padding: EdgeInsets.all(8.w),
                      color: Colors.white,
                      child: Image.asset('assets/images/back.png'),
                    ),
                  ),
                ),
              ),
            if (isLoginOpen)
              Positioned(
                right: 0,
                height: 640.h,
                width: 8.w,
                child: Container(
                  color: const Color(0xFF9BFFBD),
                ),
              ),
            if (isLoginOpen && keyboard == 0)
              Positioned(
                bottom: 64.h,
                right: 0,
                height: 64.h,
                width: 36.w,
                child: GestureDetector(
                  onTap: closeLogin,
                  child: RotatedBox(
                    quarterTurns: 2,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(50),
                        bottomRight: Radius.circular(50),
                      ),
                      child: Container(
                        padding: EdgeInsets.all(8.w),
                        color: const Color(0xFF9BFFBD),
                        child: Image.asset('assets/images/back.png'),
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

  Widget buildLogin() => SizedBox(
        width: xOffset,
        child: GestureDetector(
          onHorizontalDragStart: (details) => isDragging = true,
          onHorizontalDragUpdate: (details) {
            if (!isDragging) return;
            const delta = 1;
            if (details.delta.dx < delta) {
              closeLogin();
            } else if (details.delta.dx > -delta) {
              openLogin();
            }
            isDragging = false;
          },
          //onTap: closeLogin,
          child: LoginScreen(callback: closeLogin),
        ),
      );

  Widget buildRegister() => WillPopScope(
        onWillPop: () async {
          if (isLoginOpen) {
            closeLogin();
            return false;
          } else {
            return true;
          }
        },
        child: GestureDetector(
          onHorizontalDragStart: (details) => isDragging = true,
          onHorizontalDragUpdate: (details) {
            if (!isDragging) return;
            const delta = 1;
            if (details.delta.dx > delta) {
              openLogin();
            } else if (details.delta.dx < -delta) {
              closeLogin();
            }
            isDragging = false;
          },
          //onTap: closeLogin,
          child: AnimatedContainer(
            curve: Curves.easeIn,
            transform: Matrix4.translationValues(xOffset, 0, 0),
            duration: const Duration(milliseconds: 100),
            child: AbsorbPointer(
              absorbing: isLoginOpen,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(isLoginOpen ? 0 : 0),
                child: RegisterScreen(callback: openLogin),
              ),
            ),
          ),
        ),
      );
}
