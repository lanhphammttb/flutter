// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'content.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Content _$ContentFromJson(Map<String, dynamic> json) => Content(
      banTinId: json['BanTinId'] as String? ?? '',
      tieuDe: json['TieuDe'] as String? ?? '',
      loaiLinhVuc: json['LoaiLinhVuc'] as String? ?? '',
      loaiBanTin: json['LoaiBanTin'] as String? ?? '',
      mucDoUuTien: json['MucDoUuTien'] as String? ?? '',
      nguonId: json['NguonId'] as String? ?? '',
      noiDung: json['NoiDung'] as String? ?? '',
      noiDungTomTat: json['NoiDungTomTat'] as String? ?? '',
      thoiLuong: json['ThoiLuong'] as String? ?? '',
      nguonTin: json['NguonTin'] as String? ?? '',
      createdUser: json['CreatedUser'] as String? ?? '',
      createdTime: json['CreatedTime'] as String? ?? '',
      vungPhatThietBi: json['VungPhatThietBi'] as String? ?? '',
      tacGia: TacGia.fromJson(json['TacGia'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ContentToJson(Content instance) => <String, dynamic>{
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
      'CreatedUser': instance.createdUser,
      'CreatedTime': instance.createdTime,
      'VungPhatThietBi': instance.vungPhatThietBi,
      'TacGia': instance.tacGia.toJson(),
    };

TacGia _$TacGiaFromJson(Map<String, dynamic> json) => TacGia(
      tenDayDu: json['TenDayDu'] as String? ?? '',
      tenDangNhap: json['TenDangNhap'] as String? ?? '',
      email: json['Email'] as String? ?? '',
      butDanh: json['ButDanh'] as String? ?? '',
    );

Map<String, dynamic> _$TacGiaToJson(TacGia instance) => <String, dynamic>{
      'TenDayDu': instance.tenDayDu,
      'TenDangNhap': instance.tenDangNhap,
      'Email': instance.email,
      'ButDanh': instance.butDanh,
    };
