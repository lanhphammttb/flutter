import 'package:json_annotation/json_annotation.dart';

part 'device2.g.dart';

@JsonSerializable(explicitToJson: true)
class Device2 {
  @JsonKey(name: 'AmLuong', defaultValue: "")
  final String amLuong;

  @JsonKey(name: 'DeviceType', defaultValue: "")
  final String deviceType;

  @JsonKey(name: 'Imei', defaultValue: "")
  final String imei;

  @JsonKey(name: 'DangPhat', defaultValue: false)
  final bool dangPhat;

  @JsonKey(name: 'DichID', defaultValue: "")
  final String dichID;

  @JsonKey(name: 'IsActive', defaultValue: false)
  final bool isActive;

  @JsonKey(name: 'KinhDo', fromJson: _stringToDouble, defaultValue: 0.0)
  final double kinhDo;

  @JsonKey(name: 'MaNhaCungCap', defaultValue: "")
  final String maNhaCungCap;

  @JsonKey(name: 'MaThietBi', defaultValue: "")
  final String maThietBi;

  @JsonKey(name: 'MatKetNoi', defaultValue: false)
  final bool matKetNoi;

  @JsonKey(name: 'NguonID', defaultValue: "")
  final String nguonID;

  @JsonKey(name: 'NoiDungPhat', defaultValue: "")
  final String noiDungPhat;

  @JsonKey(name: 'PhienBanUngDung', defaultValue: "")
  final String phienBanUngDung;

  @JsonKey(name: 'PrivateKey', defaultValue: "")
  final String privateKey;

  @JsonKey(name: 'Speakers', defaultValue: null)
  final dynamic speakers;

  @JsonKey(name: 'Schedule', defaultValue: null)
  final DeviceSchedule? schedule;

  @JsonKey(name: 'ThoiDiemBatDau', fromJson: _stringToInt, defaultValue: 0)
  final int thoiDiemBatDau;

  @JsonKey(name: 'TenDich', defaultValue: "")
  final String tenDich;

  @JsonKey(name: 'TenLoaiThietBi', defaultValue: "")
  final String tenLoaiThietBi;

  @JsonKey(name: 'TenNguon', defaultValue: "")
  final String tenNguon;

  @JsonKey(name: 'TenNhaCungCap', defaultValue: "")
  final String tenNhaCungCap;

  @JsonKey(name: 'TenThietBi', defaultValue: "")
  final String tenThietBi;

  @JsonKey(name: 'TrangThaiHoatDong', defaultValue: "")
  final String trangThaiHoatDong;

  @JsonKey(name: 'TrangThaiKetNoi', defaultValue: "")
  final String trangThaiKetNoi;

  @JsonKey(name: 'ViDo', fromJson: _stringToDouble, defaultValue: 0.0)
  final double viDo;

  @JsonKey(name: 'ThongTinThietBi', defaultValue: null)
  final ThongTinThietBi? thongTinThietBi;

  Device2({
    required this.amLuong,
    required this.deviceType,
    required this.imei,
    required this.dangPhat,
    required this.dichID,
    required this.isActive,
    required this.kinhDo,
    required this.maNhaCungCap,
    required this.maThietBi,
    required this.matKetNoi,
    required this.nguonID,
    required this.noiDungPhat,
    required this.phienBanUngDung,
    required this.privateKey,
    this.speakers,
    this.schedule,
    required this.thoiDiemBatDau,
    required this.tenDich,
    required this.tenLoaiThietBi,
    required this.tenNguon,
    required this.tenNhaCungCap,
    required this.tenThietBi,
    required this.trangThaiHoatDong,
    required this.trangThaiKetNoi,
    required this.viDo,
    this.thongTinThietBi,
  });

  // Phương thức tự động sinh ra từ json_annotation
  factory Device2.fromJson(Map<String, dynamic> json) => _$Device2FromJson(json);
  Map<String, dynamic> toJson() => _$Device2ToJson(this);

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

  // Xử lý trường hợp giá trị là String thay vì int hoặc null
  static int _stringToInt(dynamic value) {
    if (value == null || value == "") {
      return 0;
    }
    if (value is String) {
      return int.tryParse(value) ?? 0;
    } else if (value is num) {
      return value.toInt();
    }
    return 0;
  }
}

@JsonSerializable()
class DeviceSchedule {
  @JsonKey(name: 'Id', defaultValue: "")
  final String id;

  @JsonKey(name: 'Name', defaultValue: "")
  final String name;

  DeviceSchedule({
    required this.id,
    required this.name,
  });

  // Phương thức tự động sinh ra từ json_annotation
  factory DeviceSchedule.fromJson(Map<String, dynamic> json) => _$DeviceScheduleFromJson(json);
  Map<String, dynamic> toJson() => _$DeviceScheduleToJson(this);
}

@JsonSerializable()
class ThongTinThietBi {
  @JsonKey(name: 'CongSuat', defaultValue: "")
  final String congSuat;

  @JsonKey(name: 'DuLieuKhac', defaultValue: "")
  final String duLieuKhac;

  @JsonKey(name: 'DungLuongSuDung', defaultValue: "")
  final String dungLuongSuDung;

  @JsonKey(name: 'NhietDo', defaultValue: "")
  final String nhietDo;

  ThongTinThietBi({
    required this.congSuat,
    required this.duLieuKhac,
    required this.dungLuongSuDung,
    required this.nhietDo,
  });

  // Phương thức tự động sinh ra từ json_annotation
  factory ThongTinThietBi.fromJson(Map<String, dynamic> json) => _$ThongTinThietBiFromJson(json);
  Map<String, dynamic> toJson() => _$ThongTinThietBiToJson(this);
}
