// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'res_overview.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResOverview _$ResOverviewFromJson(Map<String, dynamic> json) => ResOverview(
      total: (json['Total'] as num?)?.toInt() ?? 0,
      total1: (json['Total1'] as num?)?.toInt() ?? 0,
      code: json['Code'] as String? ?? '',
      lat: json['Lat'] == null ? 0.0 : ResOverview._stringToDouble(json['Lat']),
      level: (json['Level'] as num?)?.toInt() ?? 0,
      lng: json['Lng'] == null ? 0.0 : ResOverview._stringToDouble(json['Lng']),
      modifyDate: (json['ModifyDate'] as num?)?.toInt() ?? 0,
      name: json['Name'] as String? ?? '',
      off: (json['Off'] as num?)?.toInt() ?? 0,
      off1: (json['Off1'] as num?)?.toInt() ?? 0,
      on: (json['On'] as num?)?.toInt() ?? 0,
      on1: (json['On1'] as num?)?.toInt() ?? 0,
      parentId: json['ParentId'] as String? ?? '',
      play: (json['Play'] as num?)?.toInt() ?? 0,
      play1: (json['Play1'] as num?)?.toInt() ?? 0,
      totalPlayed: (json['TotalPlayed'] as num?)?.toInt() ?? 0,
      totalPlayed1: (json['TotalPlayed1'] as num?)?.toInt() ?? 0,
      playlistId: json['PlaylistId'] as String? ?? '',
      privateKey: json['PrivateKey'] as String? ?? '',
      ipRadioStatusByPlaylist: IpRadioStatusByPlaylist.fromJson(
          json['IpRadioStatusByPlaylist'] as Map<String, dynamic>),
      ditialStatusByPlaylist: DitialStatusByPlaylist.fromJson(
          json['DitialStatusByPlaylist'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ResOverviewToJson(ResOverview instance) =>
    <String, dynamic>{
      'Total': instance.total,
      'Total1': instance.total1,
      'Code': instance.code,
      'Lat': instance.lat,
      'Level': instance.level,
      'Lng': instance.lng,
      'ModifyDate': instance.modifyDate,
      'Name': instance.name,
      'Off': instance.off,
      'Off1': instance.off1,
      'On': instance.on,
      'On1': instance.on1,
      'ParentId': instance.parentId,
      'Play': instance.play,
      'Play1': instance.play1,
      'TotalPlayed': instance.totalPlayed,
      'TotalPlayed1': instance.totalPlayed1,
      'PlaylistId': instance.playlistId,
      'PrivateKey': instance.privateKey,
      'IpRadioStatusByPlaylist': instance.ipRadioStatusByPlaylist,
      'DitialStatusByPlaylist': instance.ditialStatusByPlaylist,
    };

IpRadioStatusByPlaylist _$IpRadioStatusByPlaylistFromJson(
        Map<String, dynamic> json) =>
    IpRadioStatusByPlaylist(
      total: (json['Total'] as num?)?.toInt() ?? 0,
      playlist: (json['Playlist'] as num?)?.toInt() ?? 0,
      cancel: (json['Cancel'] as num?)?.toInt() ?? 0,
      none: (json['None'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$IpRadioStatusByPlaylistToJson(
        IpRadioStatusByPlaylist instance) =>
    <String, dynamic>{
      'Total': instance.total,
      'Playlist': instance.playlist,
      'Cancel': instance.cancel,
      'None': instance.none,
    };

DitialStatusByPlaylist _$DitialStatusByPlaylistFromJson(
        Map<String, dynamic> json) =>
    DitialStatusByPlaylist(
      total: (json['Total'] as num?)?.toInt() ?? 0,
      playlist: (json['Playlist'] as num?)?.toInt() ?? 0,
      cancel: (json['Cancel'] as num?)?.toInt() ?? 0,
      none: (json['None'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$DitialStatusByPlaylistToJson(
        DitialStatusByPlaylist instance) =>
    <String, dynamic>{
      'Total': instance.total,
      'Playlist': instance.playlist,
      'Cancel': instance.cancel,
      'None': instance.none,
    };
