import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nttcs/presentation/home/home_screen.dart';
import 'package:nttcs/presentation/login/bloc/auth_bloc.dart';
import 'package:nttcs/presentation/login/login_screen.dart';

class RouteName {
  static const String home = '/home';
  static const String login = '/login';

  static const publicRoutes = [
    login,
  ];
}

final router = GoRouter(
  redirect: (context, state) {
    if (RouteName.publicRoutes.contains(state.fullPath)) {
      return null;
    }
    if (context.read<AuthBloc>().state is AuthAuthenticateSuccess) {
      return null;
    }
    return RouteName.login;
  },
  routes: [
    GoRoute(
      path: RouteName.home,
      builder: (context, state) => HomeScreen(),
    ),
    GoRoute(
      path: RouteName.login,
      builder: (context, state) => LoginScreen(),
    ),
  ],
);
