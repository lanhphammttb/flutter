import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nttcs/core/constants/constants.dart';
import 'package:nttcs/data/models/device2.dart';
import 'package:nttcs/data/models/specific_response.dart';
import 'package:nttcs/data/repositories/auth_repository.dart';
import 'package:nttcs/data/result_type.dart';
import 'package:equatable/equatable.dart';

part 'device_event.dart';

part 'device_state.dart';

class DeviceBloc extends Bloc<DeviceEvent, DeviceState> {
  final AuthRepository authRepository;
  int _tempVolume = 0;
  int _currentPage = 1;
  int totalPage = 1;

  DeviceBloc(this.authRepository) : super(DeviceInitial()) {
    on<FetchDevices>(_onFetchDevices);
    on<DeviceVolumeChanged>(_onDeviceVolumeChanged);
    on<CommitVolumeChange>(_onCommitVolumeChange);
  }

  Future<void> _onFetchDevices(FetchDevices event, Emitter<DeviceState> emit) async {
    if (event.isLoadMore) {
      if (_currentPage > totalPage || state is DeviceLoading ) {
        return;
      }
      if (state is DeviceLoaded) {
        final currentState = state as DeviceLoaded;
        emit(DeviceLoaded(currentState.data, isLoadingMore: true));
      }
    } else {
      _currentPage = 1;
      emit(DeviceLoading());
    }
    final result = await authRepository.getDevice2(_currentPage);
    switch (result) {
      case Success(data: final data as SpecificResponse<Device2>):
        totalPage = (data.totalRecord + Constants.pageSize - 1) ~/ Constants.pageSize;
        _currentPage++;
        List<Device2> currentDevices = [];
        if (state is DeviceLoaded) {
          currentDevices = (state as DeviceLoaded).data;
        }

        List<Device2> newDevices = List<Device2>.from(currentDevices)..addAll(data.items);

        emit(DeviceLoaded(newDevices));
        break;
      case Failure(message: final error):
        emit(DeviceError(error));
        break;
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
