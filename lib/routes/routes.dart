import 'package:flutter/material.dart';
import 'package:trucker/screens/login_screen/login.dart';
import 'package:trucker/screens/splash_screen/splash.dart';
import 'package:trucker/screens/welcome_screen/welcome.dart';

class AppRoutes {
  static final Map<String, WidgetBuilder> routes = {
    '/': (context) => const Splash(),
    'Welcome': (context) =>  Welcome(),
    'Login': (context) =>  Login(),
  };
}