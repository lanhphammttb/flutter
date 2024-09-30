import 'package:json_annotation/json_annotation.dart';

part 'login_success_dto.g.dart';

@JsonSerializable()
class LoginSuccessDto {
  final int code;
  final String userName;
  final int userId;
  final String token;
  final bool isGoogleAuth;
  final String message;

  LoginSuccessDto({
    required this.code,
    required this.userName,
    required this.userId,
    required this.token,
    required this.isGoogleAuth,
    required this.message,
  });

  factory LoginSuccessDto.fromJson(Map<String, dynamic> json) =>
      _$LoginSuccessDtoFromJson(json);

  Map<String, dynamic> toJson() => _$LoginSuccessDtoToJson(this);
}
