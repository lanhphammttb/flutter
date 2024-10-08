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

  Future<void> _onFetchDevices(FetchDevices event, Emitter<DeviceState> emit) async {
    emit(DeviceLoading());

    final result = await authRepository.getDevice2();

    if (result is Success) {
      emit(DeviceLoaded(result.data as SpecificResponse<Device2>));
    } else if (result is Failure) {
      emit(DeviceError(result.message));
    }
  }

  Future<void> _onDeviceVolumeChanged(DeviceVolumeChanged event, Emitter<DeviceState> emit) async {
    if (event.deviceId.isNotEmpty) {
      _tempVolume = event.volume;
      emit(DeviceVolumePreview(_tempVolume));
    } else {
      emit(DeviceError('Thiết bị không xác định'));
    }
  }

  Future<void> _onCommitVolumeChange(CommitVolumeChange event, Emitter<DeviceState> emit) async {
    emit(DeviceLoading());

    final result = await authRepository.controlDevice(0, _tempVolume);

    if (result is Success) {
      emit(DeviceVolumeChangedSuccess(result.data as SpecificResponse<Device2>));
    } else if (result is Failure) {
      emit(DeviceError(result.message));
    }
  }
}
