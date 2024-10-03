// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device2.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Device2 _$Device2FromJson(Map<String, dynamic> json) => Device2(
      amLuong: json['AmLuong'] as String? ?? '',
      deviceType: json['DeviceType'] as String? ?? '',
      imei: json['Imei'] as String? ?? '',
      dangPhat: json['DangPhat'] as bool? ?? false,
      dichID: json['DichID'] as String? ?? '',
      isActive: json['IsActive'] as bool? ?? false,
      kinhDo: json['KinhDo'] == null
          ? 0.0
          : Device2._stringToDouble(json['KinhDo']),
      maNhaCungCap: json['MaNhaCungCap'] as String? ?? '',
      maThietBi: json['MaThietBi'] as String? ?? '',
      matKetNoi: json['MatKetNoi'] as bool? ?? false,
      nguonID: json['NguonID'] as String? ?? '',
      noiDungPhat: json['NoiDungPhat'] as String? ?? '',
      phienBanUngDung: json['PhienBanUngDung'] as String? ?? '',
      privateKey: json['PrivateKey'] as String? ?? '',
      speakers: json['Speakers'],
      schedule: json['Schedule'] == null
          ? null
          : Schedule.fromJson(json['Schedule'] as Map<String, dynamic>),
      thoiDiemBatDau: json['ThoiDiemBatDau'] == null
          ? 0
          : Device2._stringToInt(json['ThoiDiemBatDau']),
      tenDich: json['TenDich'] as String? ?? '',
      tenLoaiThietBi: json['TenLoaiThietBi'] as String? ?? '',
      tenNguon: json['TenNguon'] as String? ?? '',
      tenNhaCungCap: json['TenNhaCungCap'] as String? ?? '',
      tenThietBi: json['TenThietBi'] as String? ?? '',
      trangThaiHoatDong: json['TrangThaiHoatDong'] as String? ?? '',
      trangThaiKetNoi: json['TrangThaiKetNoi'] as String? ?? '',
      viDo: json['ViDo'] == null ? 0.0 : Device2._stringToDouble(json['ViDo']),
      thongTinThietBi: json['ThongTinThietBi'] == null
          ? null
          : ThongTinThietBi.fromJson(
              json['ThongTinThietBi'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$Device2ToJson(Device2 instance) => <String, dynamic>{
      'AmLuong': instance.amLuong,
      'DeviceType': instance.deviceType,
      'Imei': instance.imei,
      'DangPhat': instance.dangPhat,
      'DichID': instance.dichID,
      'IsActive': instance.isActive,
      'KinhDo': instance.kinhDo,
      'MaNhaCungCap': instance.maNhaCungCap,
      'MaThietBi': instance.maThietBi,
      'MatKetNoi': instance.matKetNoi,
      'NguonID': instance.nguonID,
      'NoiDungPhat': instance.noiDungPhat,
      'PhienBanUngDung': instance.phienBanUngDung,
      'PrivateKey': instance.privateKey,
      'Speakers': instance.speakers,
      'Schedule': instance.schedule?.toJson(),
      'ThoiDiemBatDau': instance.thoiDiemBatDau,
      'TenDich': instance.tenDich,
      'TenLoaiThietBi': instance.tenLoaiThietBi,
      'TenNguon': instance.tenNguon,
      'TenNhaCungCap': instance.tenNhaCungCap,
      'TenThietBi': instance.tenThietBi,
      'TrangThaiHoatDong': instance.trangThaiHoatDong,
      'TrangThaiKetNoi': instance.trangThaiKetNoi,
      'ViDo': instance.viDo,
      'ThongTinThietBi': instance.thongTinThietBi?.toJson(),
    };

Schedule _$ScheduleFromJson(Map<String, dynamic> json) => Schedule(
      id: json['Id'] as String? ?? '',
      name: json['Name'] as String? ?? '',
    );

Map<String, dynamic> _$ScheduleToJson(Schedule instance) => <String, dynamic>{
      'Id': instance.id,
      'Name': instance.name,
    };

ThongTinThietBi _$ThongTinThietBiFromJson(Map<String, dynamic> json) =>
    ThongTinThietBi(
      congSuat: json['CongSuat'] as String? ?? '',
      duLieuKhac: json['DuLieuKhac'] as String? ?? '',
      dungLuongSuDung: json['DungLuongSuDung'] as String? ?? '',
      nhietDo: json['NhietDo'] as String? ?? '',
    );

Map<String, dynamic> _$ThongTinThietBiToJson(ThongTinThietBi instance) =>
    <String, dynamic>{
      'CongSuat': instance.congSuat,
      'DuLieuKhac': instance.duLieuKhac,
      'DungLuongSuDung': instance.dungLuongSuDung,
      'NhietDo': instance.nhietDo,
    };
