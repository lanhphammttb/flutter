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
  final int volume;

  const DeviceVolumeChanged(this.volume);

  @override
  List<Object> get props => [ volume];
}

class CommitVolumeChange extends DeviceEvent {
  const CommitVolumeChange();
}

class SelectDevice extends DeviceEvent {
  final String deviceId;

  const SelectDevice(this.deviceId);

  @override
  List<Object> get props => [deviceId];
}

class SelectAllDevices extends DeviceEvent {
  const SelectAllDevices();
}

class SearchDevice extends DeviceEvent {
  final String searchQuery;

  const SearchDevice(this.searchQuery);

  @override
  List<Object> get props => [searchQuery];
}

class UpdateFilter extends DeviceEvent {
  final String filter;

  const UpdateFilter(this.filter);

  @override
  List<Object> get props => [filter];
}
