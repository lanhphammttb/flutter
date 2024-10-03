// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'specific_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SpecificResponse<T> _$SpecificResponseFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) =>
    SpecificResponse<T>(
      totalRecord: (json['TotalRecord'] as num).toInt(),
      status: json['Status'] as bool,
      message: json['Message'] as String,
      page: (json['Page'] as num).toInt(),
      size: (json['Size'] as num).toInt(),
      items: (json['Items'] as List<dynamic>).map(fromJsonT).toList(),
    );

Map<String, dynamic> _$SpecificResponseToJson<T>(
  SpecificResponse<T> instance,
  Object? Function(T value) toJsonT,
) =>
    <String, dynamic>{
      'TotalRecord': instance.totalRecord,
      'Status': instance.status,
      'Message': instance.message,
      'Page': instance.page,
      'Size': instance.size,
      'Items': instance.items.map(toJsonT).toList(),
    };
