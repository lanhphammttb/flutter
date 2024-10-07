import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nttcs/data/models/device2.dart';
import 'package:nttcs/data/models/specific_response.dart';
import 'package:nttcs/data/repositories/auth_repository.dart';
import 'package:nttcs/data/result_type.dart';

part 'device_event.dart';

part 'device_state.dart';

class DeviceBloc extends Bloc<DeviceEvent, DeviceState> {
  final AuthRepository authRepository;
   int _tempVolume = 0;

  DeviceBloc(this.authRepository) : super(DeviceInitial()) {
    on<FetchDevices>(_onFetchDevices);
    on<DeviceVolumeChanged>(_onDeviceVolumeChanged);
    on<CommitVolumeChange>(_onCommitVolumeChange);
  }

  Future<void> _onFetchDevices(
      FetchDevices event, Emitter<DeviceState> emit) async {
    emit(DeviceLoading());

    final result = await authRepository.getDevice2();

    switch (result) {
      case Success(data: final data):
        emit(DeviceLoaded(data as SpecificResponse<Device2>));
        break;
      case Failure(message: final error):
        emit(DeviceError(error));
        break;
    }
  }

  Future<void> _onDeviceVolumeChanged(
      DeviceVolumeChanged event, Emitter<DeviceState> emit) async {
    _tempVolume = event.volume;
    emit(DeviceVolumePreview(_tempVolume));
  }

  // Xử lý khi người dùng bấm vào nút "Âm lượng"
  Future<void> _onCommitVolumeChange(
      CommitVolumeChange event, Emitter<DeviceState> emit) async {
    emit(DeviceLoading());
    final result = await authRepository.controlDevice(0, _tempVolume);

    switch (result) {
      case Success(data: final data):
        emit(DeviceVolumeChangedSuccess(data as SpecificResponse<Device2>)
            as DeviceState);
        break;
      case Failure(message: final error):
        emit(DeviceError(error));
        break;
    }
  }
}
