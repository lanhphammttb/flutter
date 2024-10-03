// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_success_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginSuccessDto _$LoginSuccessDtoFromJson(Map<String, dynamic> json) =>
    LoginSuccessDto(
      code: (json['Code'] as num).toInt(),
      userName: json['Username'] as String,
      userId: (json['UserId'] as num).toInt(),
      token: json['Token'] as String,
      isGoogleAuth: json['IsGoogleAuth'] as bool,
      message: json['Message'] as String,
    );

Map<String, dynamic> _$LoginSuccessDtoToJson(LoginSuccessDto instance) =>
    <String, dynamic>{
      'Code': instance.code,
      'Username': instance.userName,
      'UserId': instance.userId,
      'Token': instance.token,
      'IsGoogleAuth': instance.isGoogleAuth,
      'Message': instance.message,
    };
