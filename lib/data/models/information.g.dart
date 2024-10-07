// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'information.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Information _$InformationFromJson(Map<String, dynamic> json) => Information(
      userName: json['UserName'] as String? ?? '',
      fullName: json['FullName'] as String? ?? '',
      email: json['Email'] as String? ?? '',
      phone: json['Phone'] as String? ?? '',
      address: json['Address'] as String? ?? '',
      id: (json['Id'] as num?)?.toInt() ?? 0,
      isGoogle: json['IsGoolge'] as bool? ?? false,
      qrCode: json['QrCode'] as String? ?? '',
      locations: (json['Locations'] as List<dynamic>?)
              ?.map((e) => LocationInfor.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$InformationToJson(Information instance) =>
    <String, dynamic>{
      'UserName': instance.userName,
      'FullName': instance.fullName,
      'Email': instance.email,
      'Phone': instance.phone,
      'Address': instance.address,
      'Id': instance.id,
      'IsGoolge': instance.isGoogle,
      'QrCode': instance.qrCode,
      'Locations': instance.locations.map((e) => e.toJson()).toList(),
    };

LocationInfor _$LocationInforFromJson(Map<String, dynamic> json) =>
    LocationInfor(
      fullName: json['fullName'] as String? ?? '',
      userName: json['userName'] as String? ?? '',
      provinceCode: json['provinceCode'] as String? ?? '',
      password: json['password'] as String? ?? '',
      tags: (json['tags'] as List<dynamic>?)
              ?.map((e) => Tag.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$LocationInforToJson(LocationInfor instance) =>
    <String, dynamic>{
      'fullName': instance.fullName,
      'userName': instance.userName,
      'provinceCode': instance.provinceCode,
      'password': instance.password,
      'tags': instance.tags,
    };

Tag _$TagFromJson(Map<String, dynamic> json) => Tag(
      name: json['name'] as String? ?? '',
    );

Map<String, dynamic> _$TagToJson(Tag instance) => <String, dynamic>{
      'name': instance.name,
    };
