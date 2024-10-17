import 'package:flutter/material.dart';
import 'package:nttcs/presentation/create_schedule/choice_date_screen.dart';
import 'package:nttcs/presentation/create_schedule/choice_device_screen.dart';
import 'package:nttcs/presentation/create_schedule/choice_place_screen.dart';
import 'package:nttcs/presentation/create_schedule/create_schedule_screen.dart';
import 'package:nttcs/presentation/home/home_screen.dart';
import 'package:nttcs/presentation/login/login_screen.dart';

class AppRoutes {
  static const String initialRoute = '/';
  static const String loginScreen = '/login';
  static const String homeScreen = '/home';
  static const String createScheduleScreen = '/create-schedule';
  static const String choicePlaceScreen = '/choice-place';
  static const String choiceDeviceScreen = '/choice-device';
  static const String choiceDateScreen = '/choice-date';

  static Map<String, WidgetBuilder> get routes => {
        initialRoute: (context) => const LoginScreen(),
        loginScreen: (context) => const LoginScreen(),
        homeScreen: (context) => const HomeScreen(),
        createScheduleScreen: (context) => const CreateScheduleScreen(),
        choicePlaceScreen: (context) => const ChoicePlaceScreen(),
        choiceDeviceScreen: (context) => const ChoiceDeviceScreen(),
        choiceDateScreen: (context) => const ChoiceDateScreen(),
      };
}
