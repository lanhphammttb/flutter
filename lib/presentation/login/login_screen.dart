import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nttcs/core/config/app_routes.dart';
import 'package:nttcs/core/app_export.dart';

import 'bloc/auth_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _usernameController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    final _authState = context.read<AuthBloc>().state;
    _usernameController = TextEditingController(
      text: _authState is AuthLoginInitial ? _authState.username : '',
    );
    _passwordController = TextEditingController(
      text: _authState is AuthLoginInitial ? _authState.password : '',
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleGo(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
            AuthLoginStarted(
              username: _usernameController.text,
              password: _passwordController.text,
            ),
          );
    }
  }

  Widget _buildInitialLoginWidget() {
    return AutofillGroup(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            CustomTextFormField(
              controller: _usernameController,
              hintText: 'placeholder_account'.tr,
              hintStyle: CustomTextStyles.bodyMediumSecondary,
              contentPadding: EdgeInsets.all(16.0),
              borderDecoration: TextFormFieldStyleHelper.outLineGray,
              filled: false,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'error_account'.tr;
                }
                return null;
              },
            ),
            SizedBox(height: 24),
            CustomTextFormField(
              controller: _passwordController,
              hintText: 'placeholder_password'.tr,
              hintStyle: CustomTextStyles.bodyMediumSecondary,
              obscureText: true,
              contentPadding: EdgeInsets.all(16.0),
              borderDecoration: TextFormFieldStyleHelper.outLineGray,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'error_password'.tr;
                }
                return null;
              },
            ),
            SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
              ),
              onPressed: () => _handleGo(context),
              child: Text('login'.tr),
            ),
            const SizedBox(height: 24),
          ]
              .animate(
                interval: 50.ms,
              )
              .slideX(
                begin: -0.1,
                end: 0,
                curve: Curves.easeInOutCubic,
                duration: 400.ms,
              )
              .fadeIn(
                curve: Curves.easeInOutCubic,
                duration: 400.ms,
              ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthLoginSuccess) {
            Navigator.of(context).pushNamed(AppRoutes.homeScreen, arguments: state.loginSuccessDto);
          } else if (state is AuthLoginFailure) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        child: SingleChildScrollView(
          child: Container(
            width: double.maxFinite,
            margin: EdgeInsets.only(bottom: 354.v),
            padding: EdgeInsets.symmetric(horizontal: 32.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomImageView(
                  imagePath: ImageConstant.logoLogin,
                  height: 118.v,
                  width: 128.h,
                ),
                Text(
                  'title1'.tr.toUpperCase(),
                  style: CustomTextStyles.titleMediumBlue800,
                ),
                Text(
                  'title2'.tr.toUpperCase(),
                  style: CustomTextStyles.titleSmallBlue800,
                ),
                const SizedBox(height: 24),
                FractionallySizedBox(
                  widthFactor: 0.8,
                  child: _buildInitialLoginWidget(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
