part of 'device_bloc.dart';

abstract class DeviceState {}

class DeviceInitial extends DeviceState {}

class DeviceLoading extends DeviceState {}

class DeviceLoaded extends DeviceState {
  final SpecificResponse<Device2> data;

  DeviceLoaded(this.data);
}

class DeviceError extends DeviceState {
  final String message;

  DeviceError(this.message);
}

class DeviceVolumePreview extends DeviceState {
  final int volume;

  DeviceVolumePreview(this.volume);
}

class DeviceVolumeChangedSuccess extends DeviceState {
  final SpecificResponse<Device2> device;

  DeviceVolumeChangedSuccess(this.device);
}
