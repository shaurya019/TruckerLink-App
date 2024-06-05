import 'package:b_dep/b_dep.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:trucker/routes/routes.dart';
import 'package:trucker/share_preferences/shared_preferences_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'Notification.dart';


GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
FlutterLocalNotificationsPlugin notificationsPlugin = FlutterLocalNotificationsPlugin();

// flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>().requestNotificationsPermission();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = 'pk_live_51OPkphDXewoxjEjbuz7aJUcB54lFMrhDXbEentJ9EEA50SbZyMvIe9oCXycsELybDyogH1JVtfvYocOIcCNOSnmm00CnQnZviB';

  // Stripe.merchantIdentifier = 'merchant.flutter.stripe.test';
  // Stripe.urlScheme = 'flutterstripe';

  await Firebase.initializeApp();
  await Stripe.instance.applySettings();
  final sharedPreferencesService = SharedPreferencesService.getInstance();
  await sharedPreferencesService.init();
  await initializeBackgroundService();

  initMain(436.0, 734.0, userEmail: 'client.blup.white.falcon@gmail.com');

  runApp(const MyApp());

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: (() => GetMaterialApp(
        navigatorKey: navigatorKey,
            debugShowCheckedModeBanner: false,
            title: 'Navigation Example',
            initialRoute: '/',
            routes: AppRoutes.routes,
          )),
    );
  }
}
