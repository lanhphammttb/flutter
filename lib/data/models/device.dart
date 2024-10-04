import 'package:json_annotation/json_annotation.dart';

part 'device.g.dart';

@JsonSerializable()
class Device {
  @JsonKey(name: 'Name')
  final String name;

  @JsonKey(name: 'IMEI')
  final String imei;

  @JsonKey(name: 'Type')
  final int type;

  @JsonKey(name: 'Latitude')
  final String latitude;

  @JsonKey(name: 'Longitude')
  final String longitude;

  @JsonKey(name: 'SIM')
  final String sim;

  @JsonKey(name: 'Version')
  final String version;

  @JsonKey(name: 'PrivateKey')
  final String privateKey;

  @JsonKey(name: 'SendToProvince')
  final bool sendToProvince;

  @JsonKey(name: 'Loudspeaker')
  final int loudspeaker;

  @JsonKey(name: 'Volume')
  final String volume;

  @JsonKey(name: 'Order')
  final int order;

  @JsonKey(name: 'SiteMapId')
  final int siteMapId;

  @JsonKey(name: 'SiteMapName')
  final String siteMapName;

  @JsonKey(name: 'SiteId')
  final int siteId;

  @JsonKey(name: 'Deleted')
  final bool deleted;

  @JsonKey(name: 'HeartbeatTime')
  final String heartbeatTime;

  @JsonKey(name: 'Id')
  final int id;

  @JsonKey(name: 'CreatedTime')
  final String createdTime;

  @JsonKey(name: 'CreatedUser')
  final String createdUser;

  @JsonKey(name: 'ModifiedTime')
  final String modifiedTime;

  @JsonKey(name: 'ModifiedUser')
  final String modifiedUser;

  Device({
    required this.name,
    required this.imei,
    required this.type,
    required this.latitude,
    required this.longitude,
    required this.sim,
    required this.version,
    required this.privateKey,
    required this.sendToProvince,
    required this.loudspeaker,
    required this.volume,
    required this.order,
    required this.siteMapId,
    required this.siteMapName,
    required this.siteId,
    required this.deleted,
    required this.heartbeatTime,
    required this.id,
    required this.createdTime,
    required this.createdUser,
    required this.modifiedTime,
    required this.modifiedUser,
  });

  factory Device.fromJson(Map<String, dynamic> json) => _$DeviceFromJson(json);
  Map<String, dynamic> toJson() => _$DeviceToJson(this);
}