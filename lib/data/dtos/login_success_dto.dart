import 'package:json_annotation/json_annotation.dart';

part 'login_success_dto.g.dart';

@JsonSerializable()
class LoginSuccessDto {
  @JsonKey(name: 'Code')
  final int code;

  @JsonKey(name: 'Username')
  final String userName;

  @JsonKey(name: 'UserId')
  final int userId;

  @JsonKey(name: 'Token')
  final String token;

  @JsonKey(name: 'IsGoogleAuth')
  final bool isGoogleAuth;

  @JsonKey(name: 'Message')
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
