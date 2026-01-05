import 'package:firebase_core/firebase_core.dart';
import 'package:face_camera/face_camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:staffku/api/http_overrides.dart';
import 'package:staffku/shared/shared.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'app_binding.dart';
import 'di.dart';
import 'lang/lang.dart';
import 'routes/routes.dart';
import 'theme/theme.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'firebase_options.dart';
import 'package:get_storage/get_storage.dart';

Future<void> _messageHandler(RemoteMessage message) async {
  print('background message ${message.notification!.body}');
}

/// Create a [AndroidNotificationChannel] for heads up notifications
late AndroidNotificationChannel channel;

/// Initialize the [FlutterLocalNotificationsPlugin] package.
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  applySalesHttpOverrides();
  // await FaceCamera.initialize();
  await DenpendencyInjection.init();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(_messageHandler);

  // await Firebase.initializeApp(
  //   options: const FirebaseOptions(
  //     apiKey: 'AIzaSyAHAsf51D0A407EklG1bs-5wA7EbyfNFg0',
  //     appId: '1:740236615990:android:5c7ee6e55ca7b3e48dd397',
  //     messagingSenderId: '740236615990',
  //     projectId: 'sigesit-143f5',
  //   ),
  // );

  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  if (!kIsWeb) {
    channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      // 'This channel is used for important notifications.', // description
      importance: Importance.high,
    );

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    /// Create an Android Notification Channel.
    ///
    /// We use this channel in the `AndroidManifest.xml` file to override the
    /// default FCM channel to enable heads up notifications.
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);

    /// Update the iOS foreground notification presentation options to allow
    /// heads up notifications.
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
          alert: true,
          badge: true,
          sound: true,
        );
  }
  GetStorage.init();
  await initializeDateFormatting('id_ID', "").then((_) => runApp(const App()));
  configLoading();
}

class App extends StatefulWidget {
  // final List<FirebaseMessage> messageList = [];

  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    super.initState();
    initFCM();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      enableLog: true,
      initialRoute: Routes.SPLASH,
      defaultTransition: Transition.fade,
      getPages: AppPages.routes,
      initialBinding: AppBinding(),
      smartManagement: SmartManagement.keepFactory,
      title: 'Staffku',
      theme: ThemeConfig.lightTheme,
      locale: TranslationService.locale,
      fallbackLocale: TranslationService.fallbackLocale,
      translations: TranslationService(),
      builder: EasyLoading.init(),
    );
  }
}

void configLoading() {
  EasyLoading.instance
    ..indicatorType = EasyLoadingIndicatorType.threeBounce
    ..loadingStyle = EasyLoadingStyle.custom
    // ..indicatorSize = 45.0
    ..radius = 10.0
    // ..progressColor = Colors.yellow
    ..backgroundColor = ColorConstants.lightGray
    ..indicatorColor = ColorConstants.mainColor
    ..textColor = ColorConstants.mainColor
    // ..maskColor = Colors.red
    ..userInteractions = false
    ..dismissOnTap = false
    ..animationStyle = EasyLoadingAnimationStyle.scale;
}

Future<void> initFCM() async {
  if (Firebase.apps.isEmpty) return;

  // if (StringUtils.isEmpty(_userData.token)) return; // stop
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print('User granted permission');
  } else {
    print('User declined or has not accepted permission');
  }

  messaging.getToken().then((value) {
    print("token FCM " + value.toString());
  });

  FirebaseMessaging.onMessage.listen((RemoteMessage event) {
    // PushNotification notification = PushNotification(
    //   title: event.notification?.title,
    //   body: event.notification?.body,
    //   // type: event.notification?.type,
    // );

    FirebaseMessaging.onBackgroundMessage(_messageHandler);

    print("message recieved");
    print(event.notification!.body);
    Get.snackbar(
      event.notification!.title ?? '',
      event.notification!.body.toString(),
      icon: Icon(Icons.person, color: Colors.white),
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.green,
      borderRadius: 20,
      margin: EdgeInsets.all(15),
      colorText: Colors.white,
      duration: Duration(seconds: 4),
      isDismissible: true,
      // //dismissDirection: SnackDismissDirection.HORIZONTAL,
      forwardAnimationCurve: Curves.easeOutBack,
    );
  });

  // FirebaseMessaging.onMessageOpenedApp.listen((message) {
  //   print('Message clicked!');
  //   // print(message);
  //   if (message.data.containsKey('type')) {
  //     if (message.data['type'] == 'cnc') {
  //       Get.toNamed(Routes.CN_C);
  //     } else if (message.data['type'] == 'izin') {
  //       Get.toNamed(Routes.LEAVE);
  //     } else if (message.data['type'] == 'cuti') {
  //       Get.toNamed(Routes.BENEFIT);
  //     } else if (message.data['type'] == 'overtime') {
  //       Get.toNamed(Routes.PROSPEK);
  //     } else if (message.data['type'] == 'task') {
  //       Get.toNamed(Routes.HOME);
  //     } else {
  //       Get.toNamed(Routes.HOME);
  //     }
  //   }
  // });
  // FirebaseMessaging.instance
  //     .getInitialMessage()
  //     .then((RemoteMessage? message) {
  //   if (message != null) {
  //     // _openNotificationPage(message);
  //   }
  // });
  // FirebaseMessaging.onMessage.listen(_handleFirebaseMessage);
  // FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
  //   print('A new onMessageOpenedApp event was published!');
  //   // _openNotificationPage(message);
  // });
  // FirebaseMessaging.onMessageOpenedApp.listen(_openNotificationPage);
  // FirebaseMessaging.instance.getInitialMessage().then((remoteMessage) {
  //   if (remoteMessage != null) _openNotificationPage(remoteMessage);
  // });
}
