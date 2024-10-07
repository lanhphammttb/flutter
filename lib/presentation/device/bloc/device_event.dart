part of 'device_bloc.dart';

abstract class DeviceEvent {}

class FetchDevices extends DeviceEvent {}

class DeviceVolumeChanged extends DeviceEvent {
  final String deviceId;
  final int volume;

  DeviceVolumeChanged(this.deviceId, this.volume);
}

class DeviceVolumeChangedSuccess extends DeviceEvent {
  final SpecificResponse<Device2> device;

  DeviceVolumeChangedSuccess(this.device);
}

class DeviceVolumeChangedError extends DeviceEvent {
  final String message;

  DeviceVolumeChangedError(this.message);
}

class CommitVolumeChange extends DeviceEvent {
  final String deviceId;
  CommitVolumeChange(this.deviceId);
}
