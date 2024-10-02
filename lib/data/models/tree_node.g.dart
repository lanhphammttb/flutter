// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tree_node.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TreeNode _$TreeNodeFromJson(Map<String, dynamic> json) => TreeNode(
      parentId: (json['ParentId'] as num?)?.toInt() ?? 0,
      code: json['Code'] as String? ?? '',
      cityCode: json['CityCode'] as String? ?? '',
      codeSearch: json['CodeSearch'] as String? ?? '',
      name: json['Name'] as String? ?? '',
      description: json['Description'] as String? ?? '',
      order: (json['Order'] as num?)?.toInt() ?? 0,
      deleted: json['Deleted'] as bool? ?? false,
      siteId: (json['SiteId'] as num?)?.toInt() ?? 0,
      attributes: (json['Attributes'] as num?)?.toInt() ?? 0,
      level: (json['Level'] as num?)?.toInt() ?? 3,
      levelToText: json['LevelToText'] as String? ?? '',
      longitude: json['Longitude'] as String?,
      latitude: json['Latitude'] as String?,
      totalUsers: (json['TotalUsers'] as num?)?.toInt() ?? 0,
      mediaProjectCategories: json['MediaProjectCategories'] as String?,
      id: (json['Id'] as num?)?.toInt() ?? 0,
      createdTime: json['CreatedTime'] as String?,
      createdUser: json['CreatedUser'] as String? ?? '',
      modifiedTime: json['ModifiedTime'] as String?,
      modifiedUser: json['ModifiedUser'] as String? ?? '',
      children: (json['children'] as List<dynamic>?)
          ?.map((e) => TreeNode.fromJson(e as Map<String, dynamic>))
          .toList(),
      isExpanded: json['isExpanded'] as bool?,
    );

Map<String, dynamic> _$TreeNodeToJson(TreeNode instance) => <String, dynamic>{
      'ParentId': instance.parentId,
      'Code': instance.code,
      'CityCode': instance.cityCode,
      'CodeSearch': instance.codeSearch,
      'Name': instance.name,
      'Description': instance.description,
      'Order': instance.order,
      'Deleted': instance.deleted,
      'SiteId': instance.siteId,
      'Attributes': instance.attributes,
      'Level': instance.level,
      'LevelToText': instance.levelToText,
      'Longitude': instance.longitude,
      'Latitude': instance.latitude,
      'TotalUsers': instance.totalUsers,
      'MediaProjectCategories': instance.mediaProjectCategories,
      'Id': instance.id,
      'CreatedTime': instance.createdTime,
      'CreatedUser': instance.createdUser,
      'ModifiedTime': instance.modifiedTime,
      'ModifiedUser': instance.modifiedUser,
      'children': instance.children.map((e) => e.toJson()).toList(),
      'isExpanded': instance.isExpanded,
    };
