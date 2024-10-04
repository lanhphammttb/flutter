// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'specific_status_reponse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SpecificStatusResponse<T> _$SpecificStatusResponseFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) =>
    SpecificStatusResponse<T>(
      status: json['Status'] as bool? ?? false,
      message: json['Message'] as String? ?? '',
      totalRecord: (json['TotalRecord'] as num?)?.toInt() ?? 0,
      page: (json['Page'] as num?)?.toInt() ?? 1,
      size: (json['Size'] as num?)?.toInt() ?? 10,
      items: _$nullableGenericFromJson(json['Items'], fromJsonT),
    );

Map<String, dynamic> _$SpecificStatusResponseToJson<T>(
  SpecificStatusResponse<T> instance,
  Object? Function(T value) toJsonT,
) =>
    <String, dynamic>{
      'TotalRecord': instance.totalRecord,
      'Status': instance.status,
      'Message': instance.message,
      'Page': instance.page,
      'Size': instance.size,
      'Items': _$nullableGenericToJson(instance.items, toJsonT),
    };

T? _$nullableGenericFromJson<T>(
  Object? input,
  T Function(Object? json) fromJson,
) =>
    input == null ? null : fromJson(input);

Object? _$nullableGenericToJson<T>(
  T? input,
  Object? Function(T value) toJson,
) =>
    input == null ? null : toJson(input);
