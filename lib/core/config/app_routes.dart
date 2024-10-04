import 'package:flutter/cupertino.dart';
import 'package:nttcs/presentation/create_schedule/create_schedule_screen.dart';
import 'package:nttcs/presentation/home/home_screen.dart';
import 'package:nttcs/presentation/login/login_screen.dart';

class AppRoutes{
  static const String initialRoute = '/';
  static const String loginScreen = '/login';
  static const String homeScreen = '/home';
  static const String createScheduleScreen = '/create-schedule';


  static Map<String, WidgetBuilder> get routes => {
    initialRoute: (context) => const LoginScreen(),
    loginScreen: (context) => const LoginScreen(),
    homeScreen: (context) => const HomeScreen(),
    createScheduleScreen: (context) => const CreateScheduleScreen(),
  };
}