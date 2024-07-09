class AdditionalInformation {
  final int id;
  final String name;
  final int level;
  final String cityCode;
  final String codeSearch;
  final String code;
  final String levelName;

  AdditionalInformation({
    required this.id,
    required this.name,
    required this.level,
    required this.cityCode,
    required this.codeSearch,
    required this.code,
    required this.levelName,
  });

  factory AdditionalInformation.fromJson(Map<String, dynamic> json) {
    return AdditionalInformation(
      id: json['ID'] as int,
      name: json['Name'] as String,
      level: json['Level'] as int,
      cityCode: json['CityCode'] as String,
      codeSearch: json['CodeSearch'] as String,
      code: json['Code'] as String,
      levelName: json['LevelName'] as String,
    );
  }
}

class Role {
  final String id;
  final String description;
  final String name;

  Role({
    required this.id,
    required this.description,
    required this.name,
  });

  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
      id: json['Id'] as String,
      description: json['Description'] as String,
      name: json['Name'] as String,
    );
  }
}

class Permission {
  final int id;
  final String description;
  final String name;

  Permission({
    required this.id,
    required this.description,
    required this.name,
  });

  factory Permission.fromJson(Map<String, dynamic> json) {
    return Permission(
      id: json['ID'] as int,
      description: json['Description'] as String,
      name: json['Name'] as String,
    );
  }
}

class SiteMap {
  final int id;
  final String description;
  final String name;
  final String cityCode;
  final String codeSearch;
  final int level;
  final String code;

  SiteMap({
    required this.id,
    required this.description,
    required this.name,
    required this.cityCode,
    required this.codeSearch,
    required this.level,
    required this.code,
  });

  factory SiteMap.fromJson(Map<String, dynamic> json) {
    return SiteMap(
      id: json['ID'] as int,
      description: json['Description'] as String,
      name: json['Name'] as String,
      cityCode: json['CityCode'] as String,
      codeSearch: json['CodeSearch'] as String,
      level: json['Level'] as int,
      code: json['Code'] as String,
    );
  }
}

class VideoPlaylist {
  final int id;
  final String privateKey;
  final String name;

  VideoPlaylist({
    required this.id,
    required this.privateKey,
    required this.name,
  });

  factory VideoPlaylist.fromJson(Map<String, dynamic> json) {
    return VideoPlaylist(
      id: json['ID'] as int,
      privateKey: json['PrivateKey'] as String,
      name: json['Name'] as String,
    );
  }
}

class GetUserSuccessDto {
  final String id;
  final String fullName;
  final String email;
  final String avatar;
  final String? phone;
  final String? address;
  final String userName;
  final AdditionalInformation additionalInformation;
  final List<SiteMap> siteMaps;
  final List<Role> roles;
  final List<Permission> permissions;
  final List<VideoPlaylist> videoPlaylists;

  GetUserSuccessDto({
    required this.id,
    required this.fullName,
    required this.email,
    required this.avatar,
    this.phone,
    this.address,
    required this.userName,
    required this.additionalInformation,
    required this.siteMaps,
    required this.roles,
    required this.permissions,
    required this.videoPlaylists,
  });

  factory GetUserSuccessDto.fromJson(Map<String, dynamic> json) {
    return GetUserSuccessDto(
      id: json['Id'] as String,
      fullName: json['FullName'] as String,
      email: json['Email'] as String,
      avatar: json['Avatar'] as String,
      phone: json['Phone'] as String?,
      address: json['Address'] as String?,
      userName: json['UserName'] as String,
      additionalInformation: AdditionalInformation.fromJson(json['AdditionalInfomation']),
      siteMaps: (json['SiteMaps'] as List).map((item) => SiteMap.fromJson(item)).toList(),
      roles: (json['Roles'] as List).map((item) => Role.fromJson(item)).toList(),
      permissions: (json['Permissions'] as List).map((item) => Permission.fromJson(item)).toList(),
      videoPlaylists: (json['VideoPlaylist'] as List).map((item) => VideoPlaylist.fromJson(item)).toList(),
    );
  }
}
