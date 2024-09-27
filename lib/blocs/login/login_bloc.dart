import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:nttcs/utils/constants.dart';

import '../../data/repositories/user_repository.dart';

// Các sự kiện của LoginBloc
part 'login_event.dart';
part 'login_state.dart';

// Bloc để xử lý đăng nhập
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final UserRepository userRepository;

  LoginBloc(this.userRepository) : super(LoginState()) {
    on<LoginUsernameChanged>(_onUsernameChanged);
    on<LoginPasswordChanged>(_onPasswordChanged);
    on<LoginSubmitted>(_onSubmitted);
  }
  void _onUsernameChanged(LoginUsernameChanged event, Emitter<LoginState> emit) async {
    final isValidUsername = event.username.isNotEmpty;
    emit(state.copyWith(username: event.username, isValidUsername: isValidUsername));
  }

  void _onPasswordChanged(LoginPasswordChanged event, Emitter<LoginState> emit) async {
    final isValidPassword = event.password.isNotEmpty;
    emit(state.copyWith(password: event.password, isValidPassword: isValidPassword));
  }

  void _onSubmitted(LoginSubmitted event, Emitter<LoginState> emit) async {
    emit(state.copyWith(isSubmitting: true));
    try {
      final isSuccess = await userRepository.login(
        username: state.username,
        password: state.password,
        otp: '',
      );
      if (isSuccess) {
        emit(state.copyWith(isSubmitting: false, isSuccess: true));
      } else {
        emit(state.copyWith(isSubmitting: false, isFailure: true));
      }
    } catch (_) {
      emit(state.copyWith(isSubmitting: false, isFailure: true));
    }
  }
}
