import 'package:flutter/material.dart';
import 'package:nttcs/core/app_export.dart';
import 'package:nttcs/core/config/app_routes.dart';

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
  bool _isPasswordVisible = false;

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
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            'username'.tr,
            style: CustomTextStyles.titleSmallInter,
          ),
          CustomTextFormField(
            controller: _usernameController,
            hintText: 'placeholder_account'.tr,
            hintStyle: CustomTextStyles.bodyMediumSecondary,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            borderDecoration: TextFormFieldStyleHelper.outLineGray,
            filled: false,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'error_account'.tr;
              }
              return null;
            },
          ),
          const SizedBox(height: 24),
          Text(
            'password'.tr,
            style: CustomTextStyles.titleSmallInter,
          ),
          CustomTextFormField(
            controller: _passwordController,
            hintText: 'placeholder_password'.tr,
            suffix: IconButton(
              icon: Icon(
                _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                color: Colors.grey,
              ),
              onPressed: () {
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible;
                });
              },
            ),
            hintStyle: CustomTextStyles.bodyMediumSecondary,
            obscureText: _isPasswordVisible,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            borderDecoration: TextFormFieldStyleHelper.outLineGray,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'error_password'.tr;
              }
              return null;
            },
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(8.0),
                ),
              ),
              onPressed: () => _handleGo(context),
              child: Text('login'.tr),
            ),
          ),
          const SizedBox(height: 24),
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: BlocListener<AuthBloc, AuthState>(
                    listener: (context, state) {
                      if (state is AuthLoginSuccess) {
                        Navigator.of(context).pushNamed(AppRoutes.homeScreen,
                            arguments: state.status);
                      } else if (state is AuthLoginFailure) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(state.message)));
                      }
                    },
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Center(
                            child: CustomImageView(
                              imagePath: ImageConstant.logoLogin,
                              height: 180.v,
                              width: 200.h,
                            ),
                          ),
                          Center(
                            child: Column(
                              children: [
                                Text(
                                  'title1'.tr.toUpperCase(),
                                  style: CustomTextStyles.titleMediumBlue800,
                                ),
                                Text(
                                  'title2'.tr.toUpperCase(),
                                  style: CustomTextStyles.titleSmallBlue800,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          FractionallySizedBox(
                            widthFactor: 1.0,
                            child: _buildInitialLoginWidget(),
                          ),
                        ],
                      ),
                    )))));
  }
}
