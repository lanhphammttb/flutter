import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  @JsonKey(name: 'Name')
  final String name;

  @JsonKey(name: 'Description')
  final String description;

  @JsonKey(name: 'ParentId')
  final int parentId;

  @JsonKey(name: 'Code')
  final String code;

  @JsonKey(name: 'CityCode')
  final String cityCode;

  @JsonKey(name: 'Type')
  final int type;

  @JsonKey(name: 'LogoURL')
  final String logoURL;

  @JsonKey(name: 'Order')
  final int order;

  @JsonKey(name: 'Deleted')
  final bool deleted;

  @JsonKey(name: 'IsSiteUser')
  final bool isSiteUser;

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

  User({
    required this.name,
    required this.description,
    required this.parentId,
    required this.code,
    required this.cityCode,
    required this.type,
    required this.logoURL,
    required this.order,
    required this.deleted,
    required this.isSiteUser,
    required this.id,
    required this.createdTime,
    required this.createdUser,
    required this.modifiedTime,
    required this.modifiedUser,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
