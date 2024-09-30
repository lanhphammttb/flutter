// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'base_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BaseResponse _$BaseResponseFromJson(Map<String, dynamic> json) => BaseResponse(
      totalRecord: (json['TotalRecord'] as num).toInt(),
      status: json['Status'] as bool,
      message: json['Message'] as String,
      page: (json['Page'] as num).toInt(),
      size: (json['Size'] as num).toInt(),
    );

Map<String, dynamic> _$BaseResponseToJson(BaseResponse instance) =>
    <String, dynamic>{
      'TotalRecord': instance.totalRecord,
      'Status': instance.status,
      'Message': instance.message,
      'Page': instance.page,
      'Size': instance.size,
    };
