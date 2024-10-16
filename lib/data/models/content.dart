import 'package:json_annotation/json_annotation.dart';

part 'content.g.dart';

@JsonSerializable(explicitToJson: true)
class Content {
  @JsonKey(name: 'BanTinId', defaultValue: '')
  final String banTinId;

  @JsonKey(name: 'TieuDe', defaultValue: '')
  final String tieuDe;

  @JsonKey(name: 'LoaiLinhVuc', defaultValue: '')
  final String loaiLinhVuc;

  @JsonKey(name: 'LoaiBanTin', defaultValue: '')
  final String loaiBanTin;

  @JsonKey(name: 'MucDoUuTien', defaultValue: '')
  final String mucDoUuTien;

  @JsonKey(name: 'NguonId', defaultValue: '')
  final String nguonId;

  @JsonKey(name: 'NoiDung', defaultValue: '')
  final String noiDung;

  @JsonKey(name: 'NoiDungTomTat', defaultValue: '')
  final String noiDungTomTat;

  @JsonKey(name: 'ThoiLuong', defaultValue: '')
  final String thoiLuong;

  @JsonKey(name: 'NguonTin', defaultValue: '')
  final String nguonTin;

  @JsonKey(name: 'CreatedUser', defaultValue: '')
  final String createdUser;

  @JsonKey(name: 'CreatedTime', defaultValue: '')
  final String createdTime;

  @JsonKey(name: 'VungPhatThietBi', defaultValue: '')
  final String vungPhatThietBi;

  @JsonKey(name: 'TacGia')
  final TacGia tacGia;

  Content({
    required this.banTinId,
    required this.tieuDe,
    required this.loaiLinhVuc,
    required this.loaiBanTin,
    required this.mucDoUuTien,
    required this.nguonId,
    required this.noiDung,
    required this.noiDungTomTat,
    required this.thoiLuong,
    required this.nguonTin,
    required this.createdUser,
    required this.createdTime,
    required this.vungPhatThietBi,
    required this.tacGia,
  });

  factory Content.fromJson(Map<String, dynamic> json) => _$ContentFromJson(json);

  Map<String, dynamic> toJson() => _$ContentToJson(this);
}

@JsonSerializable()
class TacGia {
  @JsonKey(name: 'TenDayDu', defaultValue: '')
  final String tenDayDu;

  @JsonKey(name: 'TenDangNhap', defaultValue: '')
  final String tenDangNhap;

  @JsonKey(name: 'Email', defaultValue: '')
  final String email;

  @JsonKey(name: 'ButDanh', defaultValue: '')
  final String butDanh;

  TacGia({
    required this.tenDayDu,
    required this.tenDangNhap,
    required this.email,
    required this.butDanh,
  });

  factory TacGia.fromJson(Map<String, dynamic> json) => _$TacGiaFromJson(json);

  Map<String, dynamic> toJson() => _$TacGiaToJson(this);
}
