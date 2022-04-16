import 'package:endeavour22/auth/auth_provider.dart';
import 'package:endeavour22/auth/auth_screen.dart';
import 'package:endeavour22/auth/profile_screen.dart';
import 'package:endeavour22/drawermain/glimpses_provider.dart';
import 'package:endeavour22/drawermain/mian_screen.dart';
import 'package:endeavour22/events/event_content_provider.dart';
import 'package:endeavour22/events/event_main_provider.dart';
import 'package:endeavour22/events/event_registration_provider.dart';
import 'package:endeavour22/helper/date_time_stamp.dart';
import 'package:endeavour22/notifications/notification_model.dart';
import 'package:endeavour22/notifications/notification_provider.dart';
import 'package:endeavour22/schedule/schedule_provider.dart';
import 'package:endeavour22/speakers/speakers_provider.dart';
import 'package:endeavour22/sponsors/sponsors_provider.dart';
import 'package:endeavour22/team/team_provider.dart';
import 'package:endeavour22/widgets/spalsh_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

Future<void> backGroundHandler(RemoteMessage message) async {
  // SEND NOTIFICATION DATA TO FIREBASE
  const storage = FlutterSecureStorage();
  var check = await storage.containsKey(key: 'userId');
  if (check) {
    var userId = await storage.read(key: 'userId');
    await Firebase.initializeApp();
    var now = DateTime.now();
    var formatter = DateFormat.yMMMMd('en_US');
    String formattedDate = formatter.format(now);
    int id = DateTimeStamp().getDate();
    var model = NotificationModel(
      title: message.notification!.title.toString(),
      body: message.notification!.body.toString(),
      id: id.toString(),
      date: formattedDate,
      read: 'false',
    );
    final db = FirebaseDatabase.instance.reference();
    db
        .child('notifications')
        .child(userId.toString())
        .child(id.toString())
        .set(model.toMap());
  }
}

late AndroidNotificationChannel channel;
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // USED TO INVOKE BACKGROUND SERVICES
  FirebaseMessaging.onBackgroundMessage(backGroundHandler);

  channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.high,
  );

  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  runApp(
    const MyApp(),
  );
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
        ChangeNotifierProvider(
          create: (ctx) => GlimpsesProvider(),
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
            initialRoute: '/',
            routes: {
              '/': (contextMain) => AuthWrapper(auth: auth),
              //'/': (contextMain) => const ProfileScreen(isUpdate: false),
            },
          ),
        ),
        designSize: const Size(360, 640),
      ),
    );
  }
}

class AuthWrapper extends StatefulWidget {
  Auth auth;
  AuthWrapper({Key? key, required this.auth}) : super(key: key);

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  @override
  void initState() {
    super.initState();

    // IMPORTANT TO GET INITIAL MESSAGE ( BACKGROUND + KILLED + ON TAP )
    // FirebaseMessaging.instance.getInitialMessage().then((message) {
    //   if (message != null) {
    //     print("HERE ${message.notification!.title}");
    //   }
    // });

    // ONLY FOR ( FOREGROUND )
    FirebaseMessaging.onMessage.listen((message) async {
      const storage = FlutterSecureStorage();
      var check = await storage.containsKey(key: 'userId');
      if (check) {
        var userId = await storage.read(key: 'userId');
        await Firebase.initializeApp();
        var now = DateTime.now();
        var formatter = DateFormat.yMMMMd('en_US');
        String formattedDate = formatter.format(now);
        int id = DateTimeStamp().getDate();
        var model = NotificationModel(
          title: message.notification!.title.toString(),
          body: message.notification!.body.toString(),
          id: id.toString(),
          date: formattedDate,
          read: 'false',
        );
        final db = FirebaseDatabase.instance.reference();
        db
            .child('notifications')
            .child(userId.toString())
            .child(id.toString())
            .set(model.toMap());
      }

      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channelDescription: channel.description,
              icon: '@mipmap/ic_launcher',
            ),
          ),
        );
      }
    });

    // APP IS IN ( BACKGROUND + OPENED + ON TAP )  AND USER TAPS ON IT
    //FirebaseMessaging.onMessageOpenedApp.listen((message) {});
  }

  @override
  Widget build(BuildContext context) {
    return widget.auth.isAuth
        ? widget.auth.userModel == null
            ? const SplashScreen()
            : widget.auth.userModel!.profile
                ? const MainScreen()
                : const ProfileScreen(isUpdate: false)
        : FutureBuilder(
            future: widget.auth.tryAutoLogin(context),
            builder: (ctx, authResultSnapshot) =>
                authResultSnapshot.connectionState == ConnectionState.waiting
                    ? const SplashScreen()
                    : const AuthScreen(),
          );
  }
}
