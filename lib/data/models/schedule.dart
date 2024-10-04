import 'package:json_annotation/json_annotation.dart';

part 'schedule.g.dart';

@JsonSerializable()
class Schedule {
  @JsonKey(name: 'Name', defaultValue: "")
  final String name;

  @JsonKey(name: 'Attributes', defaultValue: 0)
  final int attributes;

  @JsonKey(name: 'Status', defaultValue: 0)
  final int status;

  @JsonKey(name: 'Deleted', defaultValue: false)
  final bool deleted;

  @JsonKey(name: 'SiteId', defaultValue: 0)
  final int siteId;

  @JsonKey(name: 'SiteMapId', defaultValue: 0)
  final int siteMapId;

  @JsonKey(name: 'SiteMapName', defaultValue: "")
  final String siteMapName;

  @JsonKey(name: 'PrivateKey', defaultValue: "")
  final String? privateKey;  // Có thể null

  @JsonKey(name: 'ScheduleDates', defaultValue: [])
  final List<ScheduleDates> scheduleDates;

  @JsonKey(name: 'WState', defaultValue: 0)
  final int wState;

  @JsonKey(name: 'WStatus', defaultValue: 0)
  final int wStatus;

  @JsonKey(name: 'Approved', defaultValue: false)
  final bool approved;

  @JsonKey(name: 'Id', defaultValue: 0)
  final int id;

  @JsonKey(name: 'CreatedTime', defaultValue: "")
  final String? createdTime; // Có thể null hoặc là String/int

  @JsonKey(name: 'CreatedUser', defaultValue: "")
  final String createdUser;

  @JsonKey(name: 'ModifiedTime', defaultValue: "")
  final String? modifiedTime; // Có thể null hoặc là String/int

  @JsonKey(name: 'ModifiedUser', defaultValue: "")
  final String modifiedUser;

  @JsonKey(name: 'Devices', defaultValue: [])
  final List<String> devices;

  Schedule({
    required this.name,
    required this.attributes,
    required this.status,
    required this.deleted,
    required this.siteId,
    required this.siteMapId,
    required this.siteMapName,
    required this.privateKey,
    required this.scheduleDates,
    required this.wState,
    required this.wStatus,
    required this.approved,
    required this.id,
    required this.createdTime,
    required this.createdUser,
    required this.modifiedTime,
    required this.modifiedUser,
    required this.devices,
  });

  factory Schedule.fromJson(Map<String, dynamic> json) => _$ScheduleFromJson(json);
  Map<String, dynamic> toJson() => _$ScheduleToJson(this);
}

@JsonSerializable()
class ScheduleDates {
  @JsonKey(name: 'Name', defaultValue: "")
  final String name;

  @JsonKey(name: 'ScheduleId', defaultValue: 0)
  final int scheduleId;

  @JsonKey(name: 'SiteId', defaultValue: 0)
  final int siteId;

  @JsonKey(name: 'SiteMapId', defaultValue: 0)
  final int siteMapId;

  @JsonKey(name: 'Attributes', defaultValue: 0)
  final int attributes;

  @JsonKey(name: 'StatementDate', defaultValue: "")
  final String? statementDate; // Có thể null hoặc là String/int

  @JsonKey(name: 'Deleted', defaultValue: false)
  final bool deleted;

  @JsonKey(name: 'Id', defaultValue: 0)
  final int id;

  @JsonKey(name: 'CreatedTime', defaultValue: "")
  final String? createdTime; // Có thể null hoặc là String/int

  @JsonKey(name: 'CreatedUser', defaultValue: "")
  final String createdUser;

  @JsonKey(name: 'ModifiedTime', defaultValue: "")
  final String? modifiedTime; // Có thể null hoặc là String/int

  @JsonKey(name: 'ModifiedUser', defaultValue: "")
  final String modifiedUser;

  ScheduleDates({
    required this.name,
    required this.scheduleId,
    required this.siteId,
    required this.siteMapId,
    required this.attributes,
    required this.statementDate,
    required this.deleted,
    required this.id,
    required this.createdTime,
    required this.createdUser,
    required this.modifiedTime,
    required this.modifiedUser,
  });

  factory ScheduleDates.fromJson(Map<String, dynamic> json) => _$ScheduleDatesFromJson(json);
  Map<String, dynamic> toJson() => _$ScheduleDatesToJson(this);
}
