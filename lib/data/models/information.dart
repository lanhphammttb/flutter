import 'package:json_annotation/json_annotation.dart';

part 'information.g.dart';

@JsonSerializable(explicitToJson: true)
class Information {
  @JsonKey(name: 'UserName', defaultValue: '')
  final String userName;

  @JsonKey(name: 'FullName', defaultValue: '')
  final String fullName;

  @JsonKey(name: 'Email', defaultValue: '')
  final String email;

  @JsonKey(name: 'Phone', defaultValue: '')
  final String phone;

  @JsonKey(name: 'Address', defaultValue: '')
  final String address;

  @JsonKey(name: 'Id', defaultValue: 0)
  final int id;

  @JsonKey(name: 'IsGoolge', defaultValue: false)
  final bool isGoogle;

  @JsonKey(name: 'QrCode', defaultValue: '')
  final String qrCode;

  @JsonKey(name: 'Locations', defaultValue: [])
  final List<LocationInfor> locations;

  Information({
    required this.userName,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.address,
    required this.id,
    required this.isGoogle,
    required this.qrCode,
    required this.locations,
  });

  factory Information.fromJson(Map<String, dynamic> json) => _$InformationFromJson(json);
  Map<String, dynamic> toJson() => _$InformationToJson(this);
}

@JsonSerializable()
class LocationInfor {
  @JsonKey(name: 'fullName', defaultValue: '')
  final String fullName;

  @JsonKey(name: 'userName', defaultValue: '')
  final String userName;

  @JsonKey(name: 'provinceCode', defaultValue: '')
  final String provinceCode;

  @JsonKey(name: 'password', defaultValue: '')
  final String password;

  @JsonKey(name: 'tags', defaultValue: [])
  final List<Tag> tags;

      LocationInfor({
    required this.fullName,
    required this.userName,
    required this.provinceCode,
    required this.password,
    required this.tags,
  });

  factory LocationInfor.fromJson(Map<String, dynamic> json) => _$LocationInforFromJson(json);
  Map<String, dynamic> toJson() => _$LocationInforToJson(this);
}

@JsonSerializable()
class Tag {
  @JsonKey(name: 'name', defaultValue: '')
  final String name;

  Tag({
    required this.name,
  });

  factory Tag.fromJson(Map<String, dynamic> json) => _$TagFromJson(json);
  Map<String, dynamic> toJson() => _$TagToJson(this);
}