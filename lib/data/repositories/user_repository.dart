import '../../core/api/api_service.dart';
import '../auth_local_data_source.dart';
import '../dtos/login_dto.dart';
import '../dtos/login_success_dto.dart';
import '../result_type.dart';

class UserRepository {
  final AuthApiClient authApiClient;
  final AuthLocalDataSource authLocalDataSource;

  UserRepository({
    required this.authApiClient,
    required this.authLocalDataSource,
  });

  Future<Result<void>> login(
      {required String username,
      required String password,
      required String otp}) async {
    try {
      LoginSuccessDto loginSuccessDto = await authApiClient.login(
        LoginDto(username: username, password: password, otp: otp),
      );

      await authLocalDataSource.saveToken(loginSuccessDto.token);

      return Success(loginSuccessDto);
    } catch (e) {
      return Failure('$e');
    }
  }
}
