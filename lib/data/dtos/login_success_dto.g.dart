// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_success_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginSuccessDto _$LoginSuccessDtoFromJson(Map<String, dynamic> json) =>
    LoginSuccessDto(
      code: (json['Code']).toInt() as int,
      userName: json['UserName'] as String? ?? '',
      userId: json['UserId'] as int? ?? 0,
      token: json['Token'] as String? ?? '',
      isGoogleAuth: json['IsGoogleAuth'] as bool? ?? false,
      message: json['Message'] as String? ?? '',
    );

Map<String, dynamic> _$LoginSuccessDtoToJson(LoginSuccessDto instance) =>
    <String, dynamic>{
      'Code': instance.code,
      'UserName': instance.userName,
      'UserId': instance.userId,
      'Token': instance.token,
      'IsGoogleAuth': instance.isGoogleAuth,
      'Message': instance.message,
    };
