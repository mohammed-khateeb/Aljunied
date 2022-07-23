import 'dart:io';
import 'package:aljunied/Controller/area_controller.dart';
import 'package:aljunied/Controller/bid_controller.dart';
import 'package:aljunied/Controller/complaint_controller.dart';
import 'package:aljunied/Controller/headline_controller.dart';
import 'package:aljunied/Controller/investment_controller.dart';
import 'package:aljunied/Controller/news_controller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_phone_auth_handler/firebase_phone_auth_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'Controller/admin_controller.dart';
import 'Controller/notification_controller.dart';
import 'Controller/transaction_controller.dart';
import 'Controller/user_controller.dart';
import 'Localizations/app_language.dart';
import 'Localizations/app_localization.dart';
import 'Push_notification/push_notification_serveice.dart';
import 'Screens/splash_screen.dart';
import 'Utils/util.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter_localizations/flutter_localizations.dart';




void main() async {
  tz.initializeTimeZones();
  WidgetsFlutterBinding.ensureInitialized();


  await Firebase.initializeApp();


  if (Platform.isIOS) FirebaseMessaging.instance.requestPermission();

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: false,
    sound: true,
  );



  AppLanguage appLanguage = AppLanguage();
  await appLanguage.fetchLocale();
  HttpOverrides.global = MyHttpOverrides();

  runApp(
    /// Providers are above [MyApp] instead of inside it, so that tests
    /// can use [MyApp] while mocking the providers
    MultiProvider(
      providers: [

        ChangeNotifierProvider(
          create: (_) => UserController(),
        ),

        ChangeNotifierProvider(
          create: (_) => AdminController(),
        ),
        ChangeNotifierProvider(
          create: (_) => NotificationController(),
        ),
        ChangeNotifierProvider(
          create: (_) => TransactionController(),
        ),
        ChangeNotifierProvider(
          create: (_) => BidController(),
        ),
        ChangeNotifierProvider(
          create: (_) => NewsController(),
        ),
        ChangeNotifierProvider(
          create: (_) => HeadlineController(),
        ),

        ChangeNotifierProvider(
          create: (_) => AreaController(),
        ),
        ChangeNotifierProvider(
          create: (_) => InvestmentController(),
        ),

        ChangeNotifierProvider(
          create: (_) => ComplaintController(),
        ),


      ],
      child: MyApp(appLanguage: appLanguage),
    ),
  );
}

class MyApp extends StatefulWidget {
  final AppLanguage appLanguage;

  const MyApp({key, required this.appLanguage}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;


  String? fcmToken;


  void initFirebaseMessaging() async {
    _messaging.getToken().then((token) {
      fcmToken = token;


      PushNotificationServices.fcmToken = fcmToken;

    });

    _messaging.onTokenRefresh.listen((newToken) {
      PushNotificationServices.fcmToken = fcmToken;
    });

    FirebaseMessaging.onBackgroundMessage(
        PushNotificationServices.firebaseMessagingBackgroundHandler);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      PushNotificationServices.showNotification(
          message.notification!.title!, message.notification!.body!);
    });

  }

  @override
  void initState() {
    PushNotificationServices.initLocalNotification();
    initFirebaseMessaging();
    super.initState();
  }




  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return  ChangeNotifierProvider<AppLanguage>(
      create: (_) => widget.appLanguage,
      child: Consumer<AppLanguage>(builder: (context,model, child) {

        return  FirebasePhoneAuthProvider(
          child: MaterialApp(
            navigatorKey: Utils.navKey,
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              appBarTheme: const AppBarTheme(
                  backgroundColor: Colors.white,
                  iconTheme: IconThemeData(
                      color: Colors.black
                  )
              ),
              focusColor: Colors.black26,///For Shimmer

              primaryColor: Colors.white,
              iconTheme: IconThemeData(
                  color: Colors.grey[800]
              ),

              brightness: Brightness.light,
              fontFamily: model.appLocal.languageCode=="en"?"Poppins_Regular":"ArabFont",
              /* light theme settings */
            ),

            locale: model.appLocal,
            supportedLocales: const [
              Locale("en", "US"),
              Locale("ar", "SA"),
            ],
            localizationsDelegates: const[
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            initialRoute: SplashScreen.id,
            routes: {
              SplashScreen.id: (context) => const SplashScreen(),

            },
          ),
        );
      }),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
