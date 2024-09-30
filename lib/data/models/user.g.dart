// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      name: json['Name'] as String,
      description: json['Description'] as String,
      parentId: (json['ParentId'] as num).toInt(),
      code: json['Code'] as String,
      cityCode: json['CityCode'] as String, // Thêm trường cityCode
      type: (json['Type'] as num).toInt(), // Đổi 'type' thành 'Type'
      logoURL: json['LogoURL'] as String, // Đổi 'logoURL' thành 'LogoURL'
      order: (json['Order'] as num).toInt(),
      deleted: json['Deleted'] as bool,
      isSiteUser: json['IsSiteUser'] as bool, // Đổi 'isSiteUser' thành 'IsSiteUser'
      id: (json['Id'] as num).toInt(), // Đổi 'id' thành 'Id'
      createdTime: json['CreatedTime'] as String,
      createdUser: json['CreatedUser'] as String,
      modifiedTime: json['ModifiedTime'] as String,
      modifiedUser: json['ModifiedUser'] as String,
);

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'Name': instance.name,
      'Description': instance.description,
      'ParentId': instance.parentId,
      'Code': instance.code,
      'CityCode': instance.cityCode, // Thêm trường cityCode
      'Type': instance.type, // Đổi 'type' thành 'Type'
      'LogoURL': instance.logoURL, // Đổi 'logoURL' thành 'LogoURL'
      'Order': instance.order,
      'Deleted': instance.deleted,
      'IsSiteUser': instance.isSiteUser, // Đổi 'isSiteUser' thành 'IsSiteUser'
      'Id': instance.id, // Đổi 'id' thành 'Id'
      'CreatedTime': instance.createdTime,
      'CreatedUser': instance.createdUser,
      'ModifiedTime': instance.modifiedTime,
      'ModifiedUser': instance.modifiedUser,
};
