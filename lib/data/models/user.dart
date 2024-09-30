import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  final String name;
  final String description;
  final int parentId;
  final String code;
  final String cityCode;
  final int type;
  final String logoURL;
  final int order;
  final bool deleted;
  final bool isSiteUser;
  final int id;
  final String createdTime;
  final String createdUser;
  final String modifiedTime;
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
