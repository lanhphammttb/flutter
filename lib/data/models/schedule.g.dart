// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Schedule _$ScheduleFromJson(Map<String, dynamic> json) => Schedule(
      name: json['Name'] as String? ?? '',
      attributes: (json['Attributes'] as num?)?.toInt() ?? 0,
      status: (json['Status'] as num?)?.toInt() ?? 0,
      deleted: json['Deleted'] as bool? ?? false,
      siteId: (json['SiteId'] as num?)?.toInt() ?? 0,
      siteMapId: (json['SiteMapId'] as num?)?.toInt() ?? 0,
      siteMapName: json['SiteMapName'] as String? ?? '',
      privateKey: json['PrivateKey'] as String? ?? '',
      scheduleDates: (json['ScheduleDates'] as List<dynamic>?)
              ?.map((e) => ScheduleDates.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      wState: (json['WState'] as num?)?.toInt() ?? 0,
      wStatus: (json['WStatus'] as num?)?.toInt() ?? 0,
      approved: json['Approved'] as bool? ?? false,
      id: (json['Id'] as num?)?.toInt() ?? 0,
      createdTime: json['CreatedTime'] as String? ?? '',
      createdUser: json['CreatedUser'] as String? ?? '',
      modifiedTime: json['ModifiedTime'] as String? ?? '',
      modifiedUser: json['ModifiedUser'] as String? ?? '',
      devices: (json['Devices'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );

Map<String, dynamic> _$ScheduleToJson(Schedule instance) => <String, dynamic>{
      'Name': instance.name,
      'Attributes': instance.attributes,
      'Status': instance.status,
      'Deleted': instance.deleted,
      'SiteId': instance.siteId,
      'SiteMapId': instance.siteMapId,
      'SiteMapName': instance.siteMapName,
      'PrivateKey': instance.privateKey,
      'ScheduleDates': instance.scheduleDates,
      'WState': instance.wState,
      'WStatus': instance.wStatus,
      'Approved': instance.approved,
      'Id': instance.id,
      'CreatedTime': instance.createdTime,
      'CreatedUser': instance.createdUser,
      'ModifiedTime': instance.modifiedTime,
      'ModifiedUser': instance.modifiedUser,
      'Devices': instance.devices,
    };

ScheduleDates _$ScheduleDatesFromJson(Map<String, dynamic> json) =>
    ScheduleDates(
      name: json['Name'] as String? ?? '',
      scheduleId: (json['ScheduleId'] as num?)?.toInt() ?? 0,
      siteId: (json['SiteId'] as num?)?.toInt() ?? 0,
      siteMapId: (json['SiteMapId'] as num?)?.toInt() ?? 0,
      attributes: (json['Attributes'] as num?)?.toInt() ?? 0,
      statementDate: json['StatementDate'] as String? ?? '',
      deleted: json['Deleted'] as bool? ?? false,
      id: (json['Id'] as num?)?.toInt() ?? 0,
      createdTime: json['CreatedTime'] as String? ?? '',
      createdUser: json['CreatedUser'] as String? ?? '',
      modifiedTime: json['ModifiedTime'] as String? ?? '',
      modifiedUser: json['ModifiedUser'] as String? ?? '',
    );

Map<String, dynamic> _$ScheduleDatesToJson(ScheduleDates instance) =>
    <String, dynamic>{
      'Name': instance.name,
      'ScheduleId': instance.scheduleId,
      'SiteId': instance.siteId,
      'SiteMapId': instance.siteMapId,
      'Attributes': instance.attributes,
      'StatementDate': instance.statementDate,
      'Deleted': instance.deleted,
      'Id': instance.id,
      'CreatedTime': instance.createdTime,
      'CreatedUser': instance.createdUser,
      'ModifiedTime': instance.modifiedTime,
      'ModifiedUser': instance.modifiedUser,
    };
