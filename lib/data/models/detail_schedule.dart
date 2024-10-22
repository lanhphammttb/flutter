import 'package:json_annotation/json_annotation.dart';
import 'package:nttcs/data/models/schedule_date.dart';
import 'package:nttcs/core/utils/functions.dart';

part 'detail_schedule.g.dart';

@JsonSerializable()
class DetailSchedule {
  @JsonKey(name: 'BroadcastRegion')
  final int broadcastRegion;

  @JsonKey(name: 'WorkflowStateName')
  final String workflowStateName;

  @JsonKey(name: 'ModifiedTime', fromJson: fromJsonToString)
  final String modifiedTime;

  @JsonKey(name: 'CreatedTime', fromJson: fromJsonToString)
  final String createdTime;

  @JsonKey(name: 'Devices')
  final List<int> devices;

  @JsonKey(name: 'Id')
  final int id;

  @JsonKey(name: 'Name')
  final String name;

  @JsonKey(name: 'PrivateKey')
  final String privateKey;

  @JsonKey(name: 'Attributes')
  final int attributes;

  @JsonKey(name: 'Status')
  final int status;

  @JsonKey(name: 'SiteId')
  final int siteId;

  @JsonKey(name: 'SiteMapId')
  final int siteMapId;

  @JsonKey(name: 'ScheduleDates')
  final List<ScheduleDate> scheduleDates;

  DetailSchedule({
    required this.broadcastRegion,
    required this.workflowStateName,
    required this.modifiedTime,
    required this.createdTime,
    required this.devices,
    required this.id,
    required this.name,
    required this.privateKey,
    required this.attributes,
    required this.status,
    required this.siteId,
    required this.siteMapId,
    required this.scheduleDates,
  });

  factory DetailSchedule.fromJson(Map<String, dynamic> json) => _$DetailScheduleFromJson(json);
  Map<String, dynamic> toJson() => _$DetailScheduleToJson(this);
}
