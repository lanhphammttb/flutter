part of 'device_bloc.dart';

enum DeviceStatus { initial, loading, success, failure }

class DeviceState extends Equatable {
  final List<Device2> data;
  final int isMoreOrRefresh;
  final DeviceStatus status;
  final String? message;
  final int? volumePreview;

  const DeviceState({
    this.data = const [],
    this.isMoreOrRefresh = 0,
    this.status = DeviceStatus.initial,
    this.message,
    this.volumePreview,
  });

  // Phương thức copyWith giúp dễ dàng cập nhật các thuộc tính
  DeviceState copyWith({
    List<Device2>? data,
    int? isMoreOrRefresh,
    DeviceStatus? status,
    String? message,
    int? volumePreview,
  }) {
    return DeviceState(
      data: data ?? this.data,
      isMoreOrRefresh: isMoreOrRefresh ?? this.isMoreOrRefresh,
      status: status ?? this.status,
      message: message ?? this.message,
      volumePreview: volumePreview ?? this.volumePreview,
    );
  }

  @override
  List<Object?> get props => [data, isMoreOrRefresh, status, message, volumePreview];
}
