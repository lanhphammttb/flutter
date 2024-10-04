// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ScheduleRequest _$ScheduleRequestFromJson(Map<String, dynamic> json) =>
    ScheduleRequest(
      name: json['Name'] as String? ?? '',
      id: (json['Id'] as num?)?.toInt() ?? 0,
      attributes: json['Attributes'] as String? ?? '',
      siteId: (json['SiteId'] as num?)?.toInt() ?? 0,
      siteMapId: (json['SiteMapId'] as num?)?.toInt() ?? 0,
      scheduleDates: (json['ScheduleDates'] as List<dynamic>?)
              ?.map((e) => ScheduleDate.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      devices: (json['Devices'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          [],
    );

Map<String, dynamic> _$ScheduleRequestToJson(ScheduleRequest instance) =>
    <String, dynamic>{
      'Name': instance.name,
      'Id': instance.id,
      'Attributes': instance.attributes,
      'SiteId': instance.siteId,
      'SiteMapId': instance.siteMapId,
      'ScheduleDates': instance.scheduleDates,
      'Devices': instance.devices,
    };
