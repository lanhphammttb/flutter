part of 'device_bloc.dart';

abstract class DeviceEvent extends Equatable {
  const DeviceEvent();
  @override
  List<Object> get props => [];
}

class FetchDevices extends DeviceEvent {
  final int isMoreOrRefresh; // 0: call first, 1: load more, 2: refresh

  const FetchDevices(this.isMoreOrRefresh);

  @override
  List<Object> get props => [isMoreOrRefresh];
}

class DeviceVolumeChanged extends DeviceEvent {
  final String deviceId;
  final int volume;

  const DeviceVolumeChanged(this.deviceId, this.volume);

  @override
  List<Object> get props => [deviceId, volume];
}

class CommitVolumeChange extends DeviceEvent {
  final String deviceId;

  const CommitVolumeChange(this.deviceId);

  @override
  List<Object> get props => [deviceId];
}
