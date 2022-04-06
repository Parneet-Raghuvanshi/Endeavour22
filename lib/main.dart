import 'package:endeavour22/auth/auth_provider.dart';
import 'package:endeavour22/auth/login_screen.dart';
import 'package:endeavour22/auth/profile_screen.dart';
import 'package:endeavour22/drawermain/mian_screen.dart';
import 'package:endeavour22/events/event_content_provider.dart';
import 'package:endeavour22/events/event_main_provider.dart';
import 'package:endeavour22/events/event_registration_provider.dart';
import 'package:endeavour22/notifications/notification_provider.dart';
import 'package:endeavour22/schedule/schedule_provider.dart';
import 'package:endeavour22/speakers/speakers_provider.dart';
import 'package:endeavour22/sponsors/sponsors_provider.dart';
import 'package:endeavour22/team/team_provider.dart';
import 'package:endeavour22/widgets/spalsh_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Auth(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => SponsorsProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => EventContentProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => EventMainProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => TeamProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => SpeakerProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => ScheduleProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => NotificationProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => EventRegistrationProvider(),
        ),
      ],
      child: ScreenUtilInit(
        builder: () => Consumer<Auth>(
          builder: (ctx, auth, _) => MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Endeavour 22',
            theme: ThemeData(
              fontFamily: 'Nunito',
              primarySwatch: Colors.blue,
            ),
            home: auth.isAuth
                ? auth.userModel == null
                    ? const SplashScreen()
                    : auth.userModel!.profile
                        ? const MainScreen()
                        : const ProfileScreen(isUpdate: false)
                : FutureBuilder(
                    future: auth.tryAutoLogin(context),
                    builder: (ctx, authResultSnapshot) =>
                        authResultSnapshot.connectionState ==
                                ConnectionState.waiting
                            ? const SplashScreen()
                            : const LoginScreen(),
                  ),
          ),
        ),
        designSize: const Size(360, 640),
      ),
    );
  }
}
