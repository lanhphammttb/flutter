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
      cityCode: json['CityCode'] as String,
      type: (json['Type'] as num).toInt(),
      logoURL: json['LogoURL'] as String,
      order: (json['Order'] as num).toInt(),
      deleted: json['Deleted'] as bool,
      isSiteUser: json['IsSiteUser'] as bool,
      id: (json['Id'] as num).toInt(),
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
      'CityCode': instance.cityCode,
      'Type': instance.type,
      'LogoURL': instance.logoURL,
      'Order': instance.order,
      'Deleted': instance.deleted,
      'IsSiteUser': instance.isSiteUser,
      'Id': instance.id,
      'CreatedTime': instance.createdTime,
      'CreatedUser': instance.createdUser,
      'ModifiedTime': instance.modifiedTime,
      'ModifiedUser': instance.modifiedUser,
    };
