import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'blocs/authentication/authentication_bloc.dart';
import 'core/api/api_service.dart';
import 'core/api/dio_client.dart';
import 'data/auth_local_data_source.dart';
import 'data/repositories/user_repository.dart';
import 'screens/login/login_screen.dart';
import 'screens/home/home_screen.dart';
import 'data/shared_preferences_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  String? token = await SharedPreferencesHelper.getToken();  // Kiểm tra token lưu trong SharedPreferences
  runApp(MyApp(initialRoute: token != null ? '/home' : '/login'));
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  MyApp({required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    final dioClient = DioClient();
    final authApiClient = AuthApiClient(dioClient);

    final userRepository = UserRepository(authApiClient: authApiClient);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter BLoC App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
      ),
      initialRoute: initialRoute,
      routes: {
        '/login': (context) => BlocProvider(
          create: (context) => AuthenticationBloc(),
          child: LoginScreen(userRepository: userRepository),
        ),
        '/home': (context) => BlocProvider(
          create: (context) => AuthenticationBloc(),
          child: HomeScreen(),
        ),
      },
    );
  }
}
