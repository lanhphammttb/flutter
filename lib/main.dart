import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nttcs/core/api/api_service.dart';
import 'package:nttcs/core/api/dio_client.dart';
import 'package:nttcs/core/app_export.dart';
import 'package:nttcs/core/config/app_routes.dart';
import 'package:nttcs/data/auth_local_data_source.dart';
import 'package:nttcs/data/repositories/auth_repository.dart';
import 'package:nttcs/presentation/home/bloc/home_bloc.dart';
import 'package:nttcs/presentation/login/bloc/auth_bloc.dart';

var globalMessengerKey = GlobalKey<ScaffoldMessengerState>();

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Future.wait([SystemChrome.setPreferredOrientations([])]).then((value) {
    PrefUtils().init();
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return MultiRepositoryProvider(
        providers: [
          RepositoryProvider(
            create: (context) => AuthRepository(
              authApiClient: AuthApiClient(DioClient()),
              authLocalDataSource:
                  AuthLocalDataSource(PrefUtils().sharedPreferences!),
            ),
          ),
        ],
        child: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => AuthBloc(
                context.read<AuthRepository>(),
              ),
            ),
            BlocProvider(
              create: (context) => ThemeBloc(ThemeState( themeType: PrefUtils().getThemeData())),
            ),
            BlocProvider(
              create: (context) => HomeBloc(), // Providing HomeBloc
            ),
          ],
          child: AppContent(),
        ),
      );
    });
  }
}

class AppContent extends StatefulWidget {
  const AppContent({
    super.key,
  });

  @override
  State<AppContent> createState() => _AppContentState();
}

class _AppContentState extends State<AppContent> {
  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(AuthAuthenticateStarted());
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;
    if (authState is AuthInitial) {
      return Container();
    }

    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          navigatorKey: NavigatorService.navigatorKey,
          localizationsDelegates: [AppLocalizationDelegate()],
          theme: theme,
          // Use the theme data from the ThemeBloc
          title: 'Nguồn thông tin cơ sở',
          supportedLocales: [
            const Locale('en', 'US'),
            const Locale('vi', 'VI'),
          ],
          initialRoute: AppRoutes.initialRoute,
          routes: AppRoutes.routes,
        );
      },
    );
  }
}
