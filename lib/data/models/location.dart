import 'package:json_annotation/json_annotation.dart';

part 'location.g.dart';

@JsonSerializable(explicitToJson: true)
class Location {
  @JsonKey(name: 'ParentId', defaultValue: 0)
  final int parentId;

  @JsonKey(name: 'Code', defaultValue: "")
  final String code;

  @JsonKey(name: 'CityCode', defaultValue: "")
  final String cityCode;

  @JsonKey(name: 'CodeSearch', defaultValue: "")
  final String codeSearch;

  @JsonKey(name: 'Name', defaultValue: "")
  final String name;

  @JsonKey(name: 'Description', defaultValue: "")
  final String description;

  @JsonKey(name: 'Order', defaultValue: 0)
  final int order;

  @JsonKey(name: 'Deleted', defaultValue: false)
  final bool deleted;

  @JsonKey(name: 'SiteId', defaultValue: 0)
  final int siteId;

  @JsonKey(name: 'Attributes', defaultValue: 0)
  final int attributes;

  @JsonKey(name: 'Level', defaultValue: 0)
  final int level;

  @JsonKey(name: 'LevelToText', defaultValue: "")
  final String levelToText;

  @JsonKey(name: 'Longitude', defaultValue: "")
  final String longitude;

  @JsonKey(name: 'Latitude', defaultValue: "")
  final String latitude;

  @JsonKey(name: 'TotalUsers', defaultValue: 0)
  final int totalUsers;

  @JsonKey(name: 'MediaProjectCategories', defaultValue: "")
  final String mediaProjectCategories;

  @JsonKey(name: 'Id', defaultValue: 0)
  final int id;

  @JsonKey(name: 'CreatedTime', defaultValue: "")
  final String createdTime;

  @JsonKey(name: 'CreatedUser', defaultValue: "")
  final String createdUser;

  @JsonKey(name: 'ModifiedTime', defaultValue: "")
  final String modifiedTime;

  @JsonKey(name: 'ModifiedUser', defaultValue: "")
  final String modifiedUser;

  Location({
    required this.parentId,
    required this.code,
    required this.cityCode,
    required this.codeSearch,
    required this.name,
    required this.description,
    required this.order,
    required this.deleted,
    required this.siteId,
    required this.attributes,
    required this.level,
    required this.levelToText,
    required this.longitude,
    required this.latitude,
    required this.totalUsers,
    required this.mediaProjectCategories,
    required this.id,
    required this.createdTime,
    required this.createdUser,
    required this.modifiedTime,
    required this.modifiedUser,
  });

  factory Location.fromJson(Map<String, dynamic> json) => _$LocationFromJson(json);
  Map<String, dynamic> toJson() => _$LocationToJson(this);
}