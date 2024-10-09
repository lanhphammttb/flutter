// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Device _$DeviceFromJson(Map<String, dynamic> json) => Device(
      name: json['Name'] as String? ?? '',
      imei: json['IMEI'] as String? ?? '',
      type: (json['Type'] as num?)?.toInt() ?? 0,
      latitude: json['Latitude'] as String? ?? '',
      longitude: json['Longitude'] as String? ?? '',
      sim: json['SIM'] as String? ?? '',
      version: json['Version'] as String? ?? '',
      privateKey: json['PrivateKey'] as String? ?? '',
      sendToProvince: json['SendToProvince'] as bool? ?? false,
      loudspeaker: (json['Loudspeaker'] as num?)?.toInt() ?? 0,
      volume: json['Volume'] as String? ?? '',
      order: (json['Order'] as num?)?.toInt() ?? 0,
      siteMapId: (json['SiteMapId'] as num?)?.toInt() ?? 0,
      siteMapName: json['SiteMapName'] as String? ?? '',
      siteId: (json['SiteId'] as num?)?.toInt() ?? 0,
      deleted: json['Deleted'] as bool? ?? false,
      heartbeatTime: json['HeartbeatTime'] as String? ?? '',
      id: (json['Id'] as num?)?.toInt() ?? 0,
      createdTime: json['CreatedTime'] as String? ?? '',
      createdUser: json['CreatedUser'] as String? ?? '',
      modifiedTime: json['ModifiedTime'] as String? ?? '',
      modifiedUser: json['ModifiedUser'] as String? ?? '',
    );

Map<String, dynamic> _$DeviceToJson(Device instance) => <String, dynamic>{
      'Name': instance.name,
      'IMEI': instance.imei,
      'Type': instance.type,
      'Latitude': instance.latitude,
      'Longitude': instance.longitude,
      'SIM': instance.sim,
      'Version': instance.version,
      'PrivateKey': instance.privateKey,
      'SendToProvince': instance.sendToProvince,
      'Loudspeaker': instance.loudspeaker,
      'Volume': instance.volume,
      'Order': instance.order,
      'SiteMapId': instance.siteMapId,
      'SiteMapName': instance.siteMapName,
      'SiteId': instance.siteId,
      'Deleted': instance.deleted,
      'HeartbeatTime': instance.heartbeatTime,
      'Id': instance.id,
      'CreatedTime': instance.createdTime,
      'CreatedUser': instance.createdUser,
      'ModifiedTime': instance.modifiedTime,
      'ModifiedUser': instance.modifiedUser,
    };
