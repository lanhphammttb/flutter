import 'package:json_annotation/json_annotation.dart';
import 'schedule_date.dart';

part 'schedule_request.g.dart';

@JsonSerializable()
class ScheduleRequest {
  @JsonKey(name: 'Name', defaultValue: "")
  final String name;

  @JsonKey(name: 'Id', defaultValue: 0)
  final int id;

  @JsonKey(name: 'Attributes', defaultValue: "")
  final String attributes;

  @JsonKey(name: 'SiteId', defaultValue: 0)
  final int siteId;

  @JsonKey(name: 'SiteMapId', defaultValue: 0)
  final int siteMapId;

  @JsonKey(name: 'ScheduleDates', defaultValue: [])
  final List<ScheduleDate> scheduleDates;

  @JsonKey(name: 'Devices', defaultValue: [])
  final List<int> devices;

  ScheduleRequest({
    required this.name,
    required this.id,
    required this.attributes,
    required this.siteId,
    required this.siteMapId,
    required this.scheduleDates,
    required this.devices,
  });

  factory ScheduleRequest.fromJson(Map<String, dynamic> json) => _$ScheduleRequestFromJson(json);
  Map<String, dynamic> toJson() => _$ScheduleRequestToJson(this);
}