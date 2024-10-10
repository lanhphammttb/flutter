part of 'device_bloc.dart';

abstract class DeviceEvent extends Equatable{
  const DeviceEvent();
  @override
  List<Object> get props => [];
}

class FetchDevices extends DeviceEvent {
  final bool isLoadMore;

  const FetchDevices({this.isLoadMore = false});

  @override
  List<Object> get props => [isLoadMore];
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
