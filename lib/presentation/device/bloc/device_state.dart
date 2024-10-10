part of 'device_bloc.dart';

abstract class DeviceState extends Equatable{
  const DeviceState();
  @override
  List<Object> get props => [];
}

class DeviceInitial extends DeviceState {}

class DeviceLoading extends DeviceState {}

class DeviceLoaded extends DeviceState {
  final List<Device2> data;
  final bool isLoadingMore;
  const DeviceLoaded(this.data , {this.isLoadingMore = false});

  @override
  List<Object> get props => [data, isLoadingMore];
}

class DeviceError extends DeviceState {
  final String message;

  const DeviceError(this.message);

  @override
  List<Object> get props => [message];
}

class DeviceVolumePreview extends DeviceState {
  final int volume;

  const DeviceVolumePreview(this.volume);

  @override
  List<Object> get props => [volume];
}

class DeviceVolumeChangedSuccess extends DeviceState {
  final SpecificResponse<Device2> device;

  const DeviceVolumeChangedSuccess(this.device);

  @override
  List<Object> get props => [device];
}
