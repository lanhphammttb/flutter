import 'package:json_annotation/json_annotation.dart';

part 'device.g.dart';

@JsonSerializable()
class Device {
  @JsonKey(name: 'Name', defaultValue: '')
  final String name;

  @JsonKey(name: 'IMEI', defaultValue: '')
  final String imei;

  @JsonKey(name: 'Type', defaultValue: 0)
  final int type;

  @JsonKey(name: 'Latitude', defaultValue: '')
  final String latitude;

  @JsonKey(name: 'Longitude', defaultValue: '')
  final String longitude;

  @JsonKey(name: 'SIM', defaultValue: '')
  final String sim;

  @JsonKey(name: 'Version', defaultValue: '')
  final String version;

  @JsonKey(name: 'PrivateKey', defaultValue: '')
  final String privateKey;

  @JsonKey(name: 'SendToProvince', defaultValue: false)
  final bool sendToProvince;

  @JsonKey(name: 'Loudspeaker', defaultValue: 0)
  final int loudspeaker;

  @JsonKey(name: 'Volume', defaultValue: '')
  final String volume;

  @JsonKey(name: 'Order', defaultValue: 0)
  final int order;

  @JsonKey(name: 'SiteMapId', defaultValue: 0)
  final int siteMapId;

  @JsonKey(name: 'SiteMapName', defaultValue: '')
  final String siteMapName;

  @JsonKey(name: 'SiteId', defaultValue: 0)
  final int siteId;

  @JsonKey(name: 'Deleted', defaultValue: false)
  final bool deleted;

  @JsonKey(name: 'HeartbeatTime', defaultValue: '')
  final String heartbeatTime;

  @JsonKey(name: 'Id', defaultValue: 0)
  final int id;

  @JsonKey(name: 'CreatedTime', defaultValue: '')
  final String createdTime;

  @JsonKey(name: 'CreatedUser', defaultValue: '')
  final String createdUser;

  @JsonKey(name: 'ModifiedTime', defaultValue: '')
  final String modifiedTime;

  @JsonKey(name: 'ModifiedUser', defaultValue: '')
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