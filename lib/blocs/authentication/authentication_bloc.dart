import 'package:bloc/bloc.dart';
import 'authentication_event.dart';
import 'authentication_state.dart';
import '../../data/shared_preferences_helper.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc() : super(AuthenticationInitial());

  @override
  Stream<AuthenticationState> mapEventToState(AuthenticationEvent event) async* {
    if (event is LoginRequested) {
      yield AuthenticationLoading();

      try {
        // Giả lập quá trình đăng nhập và lấy token
        await Future.delayed(Duration(seconds: 2));
        String token = "sample_token";  // Giả lập token từ API
        String username = "sample_user";  // Giả lập username

        // Lưu thông tin đăng nhập vào SharedPreferences
        await SharedPreferencesHelper.saveLoginData(token, username);

        yield AuthenticationAuthenticated();
      } catch (e) {
        yield AuthenticationUnauthenticated();
      }
    } else if (event is LogoutRequested) {
      // Xóa dữ liệu khi người dùng đăng xuất
      await SharedPreferencesHelper.clearLoginData();
      yield AuthenticationUnauthenticated();
    }
  }
}
