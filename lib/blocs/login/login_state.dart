part of 'login_bloc.dart';

class LoginState {
  final String username;
  final String password;
  final bool isValidUsername;
  final bool isValidPassword;
  final bool isSubmitting;
  final bool isSuccess;
  final bool isFailure;

  LoginState({
    this.username = '',
    this.password = '',
    this.isValidUsername = false,
    this.isValidPassword = false,
    this.isSubmitting = false,
    this.isSuccess = false,
    this.isFailure = false,
  });

  LoginState copyWith({
    String? username,
    String? password,
    bool? isValidUsername,
    bool? isValidPassword,
    bool? isSubmitting,
    bool? isSuccess,
    bool? isFailure,
  }) {
    return LoginState(
      username: username ?? this.username,
      password: password ?? this.password,
      isValidUsername: isValidUsername ?? this.isValidUsername,
      isValidPassword: isValidPassword ?? this.isValidPassword,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      isFailure: isFailure ?? this.isFailure,
    );
  }
}
