// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule_date.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ScheduleDate _$ScheduleDateFromJson(Map<String, dynamic> json) => ScheduleDate(
      id: (json['Id'] as num).toInt(),
      date: json['Date'] as String,
      datesCopy: json['DatesCopy'] as String?,
      schedulePlaylistTimes: (json['SchedulePlaylistTimes'] as List<dynamic>)
          .map((e) => SchedulePlaylistTime.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ScheduleDateToJson(ScheduleDate instance) =>
    <String, dynamic>{
      'Id': instance.id,
      'Date': instance.date,
      'DatesCopy': instance.datesCopy,
      'SchedulePlaylistTimes':
          instance.schedulePlaylistTimes.map((e) => e.toJson()).toList(),
    };

SchedulePlaylistTime _$SchedulePlaylistTimeFromJson(
        Map<String, dynamic> json) =>
    SchedulePlaylistTime(
      id: (json['Id'] as num).toInt(),
      name: json['Name'] as String,
      start: json['Start'] as String,
      end: json['End'] as String,
      playlists: (json['Playlists'] as List<dynamic>)
          .map((e) => Playlist.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SchedulePlaylistTimeToJson(
        SchedulePlaylistTime instance) =>
    <String, dynamic>{
      'Id': instance.id,
      'Name': instance.name,
      'Start': instance.start,
      'End': instance.end,
      'Playlists': instance.playlists.map((e) => e.toJson()).toList(),
    };

Playlist _$PlaylistFromJson(Map<String, dynamic> json) => Playlist(
      id: (json['Id'] as num).toInt(),
      order: (json['Order'] as num).toInt(),
      mediaProjectId: json['MediaProjectId'] as String,
      broadcastRegion: json['BroadcastRegion'] as String?,
      banTinId: json['BanTinId'] as String?,
      tieuDe: json['TieuDe'] as String?,
      loaiLinhVuc: json['LoaiLinhVuc'] as String?,
      loaiBanTin: json['LoaiBanTin'] as String?,
      mucDoUuTien: json['MucDoUuTien'] as String?,
      nguonId: json['NguonId'] as String?,
      noiDung: json['NoiDung'] as String?,
      noiDungTomTat: json['NoiDungTomTat'] as String?,
      thoiLuong: json['ThoiLuong'] as String,
      nguonTin: json['NguonTin'] as String?,
      vungPhat: json['VungPhat'] as String?,
      tacGia: json['TacGia'] == null
          ? null
          : TacGia.fromJson(json['TacGia'] as Map<String, dynamic>),
      duration: json['Duration'] as String?,
    );

Map<String, dynamic> _$PlaylistToJson(Playlist instance) => <String, dynamic>{
      'Id': instance.id,
      'Order': instance.order,
      'MediaProjectId': instance.mediaProjectId,
      'BroadcastRegion': instance.broadcastRegion,
      'BanTinId': instance.banTinId,
      'TieuDe': instance.tieuDe,
      'LoaiLinhVuc': instance.loaiLinhVuc,
      'LoaiBanTin': instance.loaiBanTin,
      'MucDoUuTien': instance.mucDoUuTien,
      'NguonId': instance.nguonId,
      'NoiDung': instance.noiDung,
      'NoiDungTomTat': instance.noiDungTomTat,
      'ThoiLuong': instance.thoiLuong,
      'NguonTin': instance.nguonTin,
      'VungPhat': instance.vungPhat,
      'TacGia': instance.tacGia?.toJson(),
      'Duration': instance.duration,
    };

TacGia _$TacGiaFromJson(Map<String, dynamic> json) => TacGia(
      tenDayDu: json['TenDayDu'] as String,
      tenDangNhap: json['TenDangNhap'] as String,
      email: json['Email'] as String,
      butDanh: json['ButDanh'] as String,
    );

Map<String, dynamic> _$TacGiaToJson(TacGia instance) => <String, dynamic>{
      'TenDayDu': instance.tenDayDu,
      'TenDangNhap': instance.tenDangNhap,
      'Email': instance.email,
      'ButDanh': instance.butDanh,
    };
