import 'package:json_annotation/json_annotation.dart';

part 'res_overview.g.dart';

@JsonSerializable()
class ResOverview {
  @JsonKey(name: 'Total', defaultValue: 0)
  final int total;

  @JsonKey(name: 'Total1', defaultValue: 0)
  final int total1;

  @JsonKey(name: 'Code', defaultValue: "")
  final String code;

  @JsonKey(name: 'Lat', fromJson: _stringToDouble, defaultValue: 0.0)
  final double lat;

  @JsonKey(name: 'Level', defaultValue: 0)
  final int level;

  @JsonKey(name: 'Lng', fromJson: _stringToDouble, defaultValue: 0.0)
  final double lng;

  @JsonKey(name: 'ModifyDate', defaultValue: 0)
  final int modifyDate;

  @JsonKey(name: 'Name', defaultValue: "")
  final String name;

  @JsonKey(name: 'Off', defaultValue: 0)
  final int off;

  @JsonKey(name: 'Off1', defaultValue: 0)
  final int off1;

  @JsonKey(name: 'On', defaultValue: 0)
  final int on;

  @JsonKey(name: 'On1', defaultValue: 0)
  final int on1;

  @JsonKey(name: 'ParentId', defaultValue: "")
  final String parentId;

  @JsonKey(name: 'Play', defaultValue: 0)
  final int play;

  @JsonKey(name: 'Play1', defaultValue: 0)
  final int play1;

  @JsonKey(name: 'TotalPlayed', defaultValue: 0)
  final int totalPlayed;

  @JsonKey(name: 'TotalPlayed1', defaultValue: 0)
  final int totalPlayed1;

  @JsonKey(name: 'PlaylistId', defaultValue: "")
  final String playlistId;

  @JsonKey(name: 'PrivateKey', defaultValue: "")
  final String privateKey;

  @JsonKey(name: 'IpRadioStatusByPlaylist')
  final IpRadioStatusByPlaylist ipRadioStatusByPlaylist;

  @JsonKey(name: 'DitialStatusByPlaylist')
  final DitialStatusByPlaylist ditialStatusByPlaylist;

  ResOverview({
    required this.total,
    required this.total1,
    required this.code,
    required this.lat,
    required this.level,
    required this.lng,
    required this.modifyDate,
    required this.name,
    required this.off,
    required this.off1,
    required this.on,
    required this.on1,
    required this.parentId,
    required this.play,
    required this.play1,
    required this.totalPlayed,
    required this.totalPlayed1,
    required this.playlistId,
    required this.privateKey,
    required this.ipRadioStatusByPlaylist,
    required this.ditialStatusByPlaylist,
  });

  factory ResOverview.fromJson(Map<String, dynamic> json) => _$ResOverviewFromJson(json);
  Map<String, dynamic> toJson() => _$ResOverviewToJson(this);

  // Xử lý trường hợp giá trị là String thay vì num hoặc null
  static double _stringToDouble(dynamic value) {
    if (value == null || value == "") {
      return 0.0;
    }
    if (value is String) {
      return double.tryParse(value) ?? 0.0;
    } else if (value is num) {
      return value.toDouble();
    }
    return 0.0;
  }
}

@JsonSerializable()
class IpRadioStatusByPlaylist {
  @JsonKey(name: 'Total', defaultValue: 0)
  final int total;

  @JsonKey(name: 'Playlist', defaultValue: 0)
  final int playlist;

  @JsonKey(name: 'Cancel', defaultValue: 0)
  final int cancel;

  @JsonKey(name: 'None', defaultValue: 0)
  final int none;

  IpRadioStatusByPlaylist({
    required this.total,
    required this.playlist,
    required this.cancel,
    required this.none,
  });

  factory IpRadioStatusByPlaylist.fromJson(Map<String, dynamic> json) =>
      _$IpRadioStatusByPlaylistFromJson(json);
  Map<String, dynamic> toJson() => _$IpRadioStatusByPlaylistToJson(this);
}

@JsonSerializable()
class DitialStatusByPlaylist {
  @JsonKey(name: 'Total', defaultValue: 0)
  final int total;

  @JsonKey(name: 'Playlist', defaultValue: 0)
  final int playlist;

  @JsonKey(name: 'Cancel', defaultValue: 0)
  final int cancel;

  @JsonKey(name: 'None', defaultValue: 0)
  final int none;

  DitialStatusByPlaylist({
    required this.total,
    required this.playlist,
    required this.cancel,
    required this.none,
  });

  factory DitialStatusByPlaylist.fromJson(Map<String, dynamic> json) =>
      _$DitialStatusByPlaylistFromJson(json);
  Map<String, dynamic> toJson() => _$DitialStatusByPlaylistToJson(this);
}
