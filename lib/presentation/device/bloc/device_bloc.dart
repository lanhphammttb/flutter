import 'dart:async';

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

  DeviceBloc(this.authRepository) : super(const DeviceState()) {
    on<FetchDevices>(_onFetchDevices);
    on<DeviceVolumeChanged>(_onDeviceVolumeChanged);
    on<CommitVolumeChange>(_onCommitVolumeChange);

    Timer.periodic(const Duration(minutes: 1), (timer) {
      add(const FetchDevices(2));
    });
  }

  Future<void> _onFetchDevices(FetchDevices event, Emitter<DeviceState> emit) async {
    switch (event.isMoreOrRefresh) {
      case 0:
        emit(state.copyWith(status: DeviceStatus.loading));
        break;
      case 1:
        if (_currentPage > totalPage || totalPage == 1 || state.status == DeviceStatus.loading) {
          return;
        }
        if (state.status == DeviceStatus.success) {
          emit(state.copyWith(
            isMoreOrRefresh: event.isMoreOrRefresh,
            status: DeviceStatus.success,
          ));
        }
        break;
      case 2:
        break;
    }

    final result = await authRepository.getDevice2(event.isMoreOrRefresh == 1 ? _currentPage : 1, event.isMoreOrRefresh == 1 ? 1 : _currentPage);
    switch (result) {
      case Success(data: final data as SpecificResponse<Device2>):
        totalPage = (data.totalRecord + Constants.pageSize - 1) ~/ Constants.pageSize;
        if (event.isMoreOrRefresh == 1 || _currentPage == 1) _currentPage++;
        final newDevices = event.isMoreOrRefresh == 1 ? state.data + data.items : data.items;

        emit(state.copyWith(
          data: newDevices,
          isMoreOrRefresh: event.isMoreOrRefresh,
          status: DeviceStatus.success,
        ));
        break;
      case Failure(message: final error):
        emit(state.copyWith(status: DeviceStatus.failure, message: error));
        break;
    }
  }

  Future<void> _onDeviceVolumeChanged(DeviceVolumeChanged event, Emitter<DeviceState> emit) async {
    if (event.deviceId.isNotEmpty) {
      _tempVolume = event.volume;
      emit(state.copyWith(volumePreview: event.volume));
    } else {
      emit(state.copyWith(
        status: DeviceStatus.failure,
        message: 'Failed to fetch devices',
      ));
    }
  }

  Future<void> _onCommitVolumeChange(CommitVolumeChange event, Emitter<DeviceState> emit) async {
    emit(state.copyWith(status: DeviceStatus.loading));

    final result = await authRepository.controlDevice(0, _tempVolume);
    if (result is Success) {
      emit(state.copyWith(
        status: DeviceStatus.success,
        message: 'Volume change committed',
      ));
    } else if (result is Failure) {
      emit(state.copyWith(
        status: DeviceStatus.failure,
        message: 'Failed to commit volume change',
      ));
    }
  }
}
