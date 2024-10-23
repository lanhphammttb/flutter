import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nttcs/core/constants/constants.dart';
import 'package:nttcs/data/models/content.dart';
import 'package:nttcs/data/models/device2.dart';
import 'package:nttcs/data/models/specific_response.dart';
import 'package:nttcs/data/models/specific_status_reponse.dart';
import 'package:nttcs/data/repositories/auth_repository.dart';
import 'package:nttcs/data/result_type.dart';
import 'package:equatable/equatable.dart';
import 'package:nttcs/presentation/news/bloc/news_bloc.dart';

part 'device_event.dart';

part 'device_state.dart';

class DeviceBloc extends Bloc<DeviceEvent, DeviceState> {
  final AuthRepository authRepository;
  int _currentPage = 1;
  int totalPage = 1;
  int _currentPageNews = 1;
  int totalPageNews = 1;

  DeviceBloc(this.authRepository) : super(const DeviceState()) {
    on<FetchDevices>(_onFetchDevices);
    on<DeviceVolumeChanged>(_onDeviceVolumeChanged);
    on<CommitVolumeChange>(_onCommitVolumeChange);
    on<SelectDevice>(_onSelectDevice);
    on<SelectAllDevices>(_onSelectAllDevices);
    on<SearchDevice>(_onSearchDevice);
    on<UpdateFilter>(_onUpdateFilter);
    on<FetchNews2>(_onFetchNews2);
    on<SelectNews>(_onSelectNews);
    on<PlayNow>(_onPlayNow);
    Timer.periodic(const Duration(minutes: 1), (timer) {
      add(const FetchDevices(2));
    });
  }

  Future<void> _onFetchDevices(FetchDevices event, Emitter<DeviceState> emit) async {
    switch (event.isMoreOrRefresh) {
      case 0:
        emit(state.copyWith(status: DeviceStatus.loading));

        if (event.code != null) {
          emit(state.copyWith(code: event.code));
        }
        break;
      case 1:
        if (_currentPage > totalPage || totalPage == 1) {
          return;
        }
        if (state.status == DeviceStatus.success) {
          emit(state.copyWith(status: DeviceStatus.more));
        }
        break;
      case 2:
        if (state.status != DeviceStatus.success) {
          return;
        }
        break;
    }

    final result = await authRepository.getDevice2(
        event.isMoreOrRefresh == 1 ? _currentPage : 1,
        event.isMoreOrRefresh == 1
            ? 1
            : _currentPage > totalPage
                ? totalPage
                : _currentPage);
    switch (result) {
      case Success(data: final data as SpecificResponse<Device2>):
        totalPage = (data.totalRecord + Constants.pageSize - 1) ~/ Constants.pageSize;
        if (event.isMoreOrRefresh == 1 || _currentPage == 1) _currentPage++;
        final newDevices = event.isMoreOrRefresh == 1 ? state.data + data.items : data.items;

        emit(state.copyWith(
          data: newDevices,
          status: DeviceStatus.success,
          message: '',
        ));
        break;
      case Failure(message: final error):
        emit(state.copyWith(status: DeviceStatus.failure, message: error));
        break;
    }
  }

  Future<void> _onDeviceVolumeChanged(DeviceVolumeChanged event, Emitter<DeviceState> emit) async {
    emit(state.copyWith(volumePreview: event.volume));
  }

  Future<void> _onCommitVolumeChange(CommitVolumeChange event, Emitter<DeviceState> emit) async {
    final result = await authRepository.controlDevice(event.maLenh, event.thamSo, state.selectedItems);
    switch (result) {
      case Success(data: final data as SpecificStatusResponse<dynamic>):
        if (data.status) {
          emit(state.copyWith(
            status: DeviceStatus.success,
            message: 'Phát lệnh điều khiển thành công',
          ));
        } else {
          emit(state.copyWith(
            status: DeviceStatus.failure,
            message: data.message ?? 'Phát lệnh điều khiển thất bại',
          ));
        }
        break;
      case Failure(message: final error):
        emit(state.copyWith(status: DeviceStatus.failure, message: error));
        break;
    }
  }

  void _onSelectDevice(SelectDevice event, Emitter<DeviceState> emit) {
    final updatedSelectedItems = List<String>.from(state.selectedItems);
    if (updatedSelectedItems.contains(event.deviceId)) {
      updatedSelectedItems.remove(event.deviceId);
    } else {
      updatedSelectedItems.add(event.deviceId);
    }

    emit(state.copyWith(selectedItems: updatedSelectedItems));
  }

  void _onSelectAllDevices(SelectAllDevices event, Emitter<DeviceState> emit) {
    if (state.isSelectAll) {
      // Bỏ chọn tất cả
      emit(state.copyWith(selectedItems: [], isSelectAll: false));
    } else {
      final allDeviceIds = state.data
          .where((device) {
            final matchesSearch = device.tenThietBi.toLowerCase().contains(state.searchQuery.toLowerCase()) ?? true;

            switch (state.filter) {
              case 'all':
              case 'connected':
                return matchesSearch && !device.matKetNoi;
              case 'playing':
                return matchesSearch && device.dangPhat;
              case 'disconnected':
                return false;
              default:
                return matchesSearch;
            }
          })
          .map((device) => device.maThietBi)
          .toList();

      emit(state.copyWith(selectedItems: allDeviceIds, isSelectAll: true));
    }
  }

  void _onSearchDevice(SearchDevice event, Emitter<DeviceState> emit) {
    emit(state.copyWith(searchQuery: event.searchQuery));
  }

  void _onUpdateFilter(UpdateFilter event, Emitter<DeviceState> emit) {
    emit(state.copyWith(filter: event.filter));
  }

  void _emitLoadingStateDelayed(Emitter<DeviceState> emit) {
    Future.delayed(const Duration(milliseconds: 1500)).then((_) {
      if (emit.isDone) return;
      emit(state.copyWith(newsStatus: NewsStatus.loading));
    });
  }

  Future<void> _onFetchNews2(FetchNews2 event, Emitter<DeviceState> emit) async {
    if (event.isMoreOrRefresh == 0) {
      _emitLoadingStateDelayed(emit);
    }

    if (event.isMoreOrRefresh == 0) {
      emit(state.copyWith(contentType: event.contentType));
    } else {
      if (_currentPageNews > totalPageNews || totalPageNews == 1) {
        return;
      }
      if (state.newsStatus == NewsStatus.success) {
        emit(state.copyWith(
            newsStatus: NewsStatus.more, contentType: state.contentType, selectedContent: event.isMoreOrRefresh == 1 ? state.selectedContent : null));
      }
    }

    final result = await authRepository.getNews(
        event.contentType ?? state.contentType,
        state.code,
        event.isMoreOrRefresh == 1 ? _currentPage : 1,
        event.isMoreOrRefresh == 1
            ? 1
            : _currentPage > totalPage
                ? totalPage
                : _currentPage);

    switch (result) {
      case Success(data: final data as SpecificResponse<Content>):
        totalPageNews = (data.totalRecord + Constants.pageSize - 1) ~/ Constants.pageSize;
        if (event.isMoreOrRefresh == 1 || _currentPageNews == 1) _currentPageNews++;
        final newDevices = event.isMoreOrRefresh == 1 ? state.newsData + data.items : data.items;
        emit(state.copyWith(newsStatus: NewsStatus.success, newsData: newDevices, selectedContent: state.selectedContent));
        break;
      case Failure(message: final error):
        emit(state.copyWith(newsStatus: NewsStatus.failure, message: error));
        break;
    }
  }

  void _onSelectNews(SelectNews event, Emitter<DeviceState> emit) {
    emit(state.copyWith(selectedContent: event.content));
  }

  Future<void> _onPlayNow(PlayNow event, Emitter<DeviceState> emit) async {
    final result = await authRepository.playNow(state.selectedItems, state.selectedContent!);
    switch (result) {
      case Success(data: final data as SpecificStatusResponse<dynamic>):
        if (data.status) {
          emit(state.copyWith(
            status: DeviceStatus.success,
            message: 'Phát khẩn cấp thành công',
          ));
        } else {
          emit(state.copyWith(
            status: DeviceStatus.failure,
            message: data.message ?? 'Phát khẩn cấp thất bại',
          ));
        }
        break;
      case Failure(message: final error):
        emit(state.copyWith(status: DeviceStatus.failure, message: error));
        break;
    }
  }
}
