import 'get_user_success_dto.dart';

class LoginSuccessDto {
  final int code;
  final String message;
  final String dataCode;
  final String app;
  final String token;
  final GetUserSuccessDto? getUserSuccessDto;

  LoginSuccessDto({
    required this.code,
    required this.message,
    required this.dataCode,
    required this.app,
    required this.token,
    this.getUserSuccessDto,
  });

  factory LoginSuccessDto.fromJson(Map<String, dynamic> json) {
    return LoginSuccessDto(
      code: json['Code'] as int,
      message: json['Message'] as String,
      dataCode: json['Data']['Code'] as String,
      app: json['Data']['App'] as String,
      token: json['Data']['Token'] as String,
    );
  }

  factory LoginSuccessDto.withUserData(LoginSuccessDto loginDto, GetUserSuccessDto userDto) {
    return LoginSuccessDto(
      code: loginDto.code,
      message: loginDto.message,
      dataCode: loginDto.dataCode,
      app: loginDto.app,
      token: loginDto.token,
      getUserSuccessDto: userDto,
    );
  }

  bool get isSuccess => code == 1;
}
