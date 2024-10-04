import 'package:json_annotation/json_annotation.dart';

part 'schedule_date.g.dart';

@JsonSerializable(explicitToJson: true)
class ScheduleDate {
  @JsonKey(name: 'Id')
  int id;

  @JsonKey(name: 'Date')
  String date;

  @JsonKey(name: 'DatesCopy')
  String? datesCopy;

  @JsonKey(name: 'SchedulePlaylistTimes')
  List<SchedulePlaylistTime> schedulePlaylistTimes;

  ScheduleDate({
    required this.id,
    required this.date,
    this.datesCopy,
    required this.schedulePlaylistTimes,
  });

  void resetIds() {
    id = 0;
    for (var playlistTime in schedulePlaylistTimes) {
      playlistTime.id = 0;
      for (var playlist in playlistTime.playlists) {
        playlist.id = 0;
      }
    }
  }

  ScheduleDate clone() {
    return ScheduleDate(
      id: id,
      date: date,
      datesCopy: datesCopy,
      schedulePlaylistTimes: List.from(schedulePlaylistTimes),
    );
  }

  factory ScheduleDate.fromJson(Map<String, dynamic> json) =>
      _$ScheduleDateFromJson(json);

  Map<String, dynamic> toJson() => _$ScheduleDateToJson(this);
}

@JsonSerializable(explicitToJson: true)
class SchedulePlaylistTime {
  @JsonKey(name: 'Id')
  int id;

  @JsonKey(name: 'Name')
  String name;

  @JsonKey(name: 'Start')
  String start;

  @JsonKey(name: 'End')
  String end;

  @JsonKey(name: 'Playlists')
  List<Playlist> playlists;

  SchedulePlaylistTime({
    required this.id,
    required this.name,
    required this.start,
    required this.end,
    required this.playlists,
  });

  factory SchedulePlaylistTime.fromJson(Map<String, dynamic> json) =>
      _$SchedulePlaylistTimeFromJson(json);

  Map<String, dynamic> toJson() => _$SchedulePlaylistTimeToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Playlist {
  @JsonKey(name: 'Id')
  int id;

  @JsonKey(name: 'Order')
  int order;

  @JsonKey(name: 'MediaProjectId')
  String mediaProjectId;

  @JsonKey(name: 'BroadcastRegion')
  String? broadcastRegion;

  @JsonKey(name: 'BanTinId')
  String? banTinId;

  @JsonKey(name: 'TieuDe')
  String? tieuDe;

  @JsonKey(name: 'LoaiLinhVuc')
  String? loaiLinhVuc;

  @JsonKey(name: 'LoaiBanTin')
  String? loaiBanTin;

  @JsonKey(name: 'MucDoUuTien')
  String? mucDoUuTien;

  @JsonKey(name: 'NguonId')
  String? nguonId;

  @JsonKey(name: 'NoiDung')
  String? noiDung;

  @JsonKey(name: 'NoiDungTomTat')
  String? noiDungTomTat;

  @JsonKey(name: 'ThoiLuong')
  String thoiLuong;

  @JsonKey(name: 'NguonTin')
  String? nguonTin;

  @JsonKey(name: 'VungPhat')
  String? vungPhat;

  @JsonKey(name: 'TacGia')
  TacGia? tacGia;

  @JsonKey(name: 'Duration')
  String? duration;

  Playlist({
    required this.id,
    required this.order,
    required this.mediaProjectId,
    this.broadcastRegion,
    this.banTinId,
    this.tieuDe,
    this.loaiLinhVuc,
    this.loaiBanTin,
    this.mucDoUuTien,
    this.nguonId,
    this.noiDung,
    this.noiDungTomTat,
    required this.thoiLuong,
    this.nguonTin,
    this.vungPhat,
    this.tacGia,
    this.duration,
  });

  factory Playlist.fromJson(Map<String, dynamic> json) =>
      _$PlaylistFromJson(json);

  Map<String, dynamic> toJson() => _$PlaylistToJson(this);
}

@JsonSerializable()
class TacGia {
  @JsonKey(name: 'TenDayDu')
  String tenDayDu;

  @JsonKey(name: 'TenDangNhap')
  String tenDangNhap;

  @JsonKey(name: 'Email')
  String email;

  @JsonKey(name: 'ButDanh')
  String butDanh;

  TacGia({
    required this.tenDayDu,
    required this.tenDangNhap,
    required this.email,
    required this.butDanh,
  });

  factory TacGia.fromJson(Map<String, dynamic> json) => _$TacGiaFromJson(json);

  Map<String, dynamic> toJson() => _$TacGiaToJson(this);
}
