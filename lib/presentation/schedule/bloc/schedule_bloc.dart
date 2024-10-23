import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nttcs/core/constants/constants.dart';
import 'package:nttcs/core/utils/functions.dart';
import 'package:nttcs/data/models/detail_schedule.dart';
import 'package:nttcs/data/models/schedule.dart';
import 'package:nttcs/data/models/schedule_date.dart';
import 'package:nttcs/data/models/specific_response.dart';
import 'package:nttcs/data/models/specific_status_reponse.dart';
import 'package:nttcs/data/models/tree_node.dart';
import 'package:nttcs/data/repositories/auth_repository.dart';
import 'package:nttcs/data/result_type.dart';

part 'schedule_event.dart';

part 'schedule_state.dart';

class ScheduleBloc extends Bloc<ScheduleEvent, ScheduleState> {
  final AuthRepository authRepository;
  int _currentPage = 1;
  int totalPage = 1;

  ScheduleBloc(this.authRepository) : super(const ScheduleState()) {
    on<FetchSchedule>(_onFetchSchedule);
    on<SyncSchedule>(_onSyncSchedule);
    on<UpdateFilter>(_onUpdateFilter);
    on<SearchSchedule>(_onSearchSchedule);
    on<DelSchedule>(_onDelSchedule);
    on<CopySchedule>(_onCopySchedule);
  }

  void _emitLoadingStateDelayed(Emitter<ScheduleState> emit) {
    Future.delayed(const Duration(milliseconds: 1500)).then((_) {
      if (emit.isDone) return;
      emit(state.copyWith(status: ScheduleStatus.loading));
    });
  }

  Future<void> _onFetchSchedule(FetchSchedule event, Emitter<ScheduleState> emit) async {
    if (event.locationNode != null && event.locationIds != null) {
      emit(state.copyWith(locationNode: event.locationNode, locationIds: event.locationIds));
    }
    if (event.isMoreOrRefresh == 0) {
      _emitLoadingStateDelayed(emit);
    }

    if (event.isMoreOrRefresh == 0) {
      emit(state.copyWith(isMoreOrRefresh: event.isMoreOrRefresh));
    } else {
      if (_currentPage > totalPage || totalPage == 1) {
        return;
      }
      if (state.status == ScheduleStatus.success) {
        emit(state.copyWith(isMoreOrRefresh: event.isMoreOrRefresh, status: ScheduleStatus.more));
      }
    }

    final result = await authRepository.getSchedules(
        state.locationIds,
        event.isMoreOrRefresh == 1 ? _currentPage : 1,
        event.isMoreOrRefresh == 1
            ? 1
            : _currentPage > totalPage
                ? totalPage
                : _currentPage);

    switch (result) {
      case Success(data: final data as SpecificResponse<Schedule>):
        totalPage = (data.totalRecord + Constants.pageSize - 1) ~/ Constants.pageSize;
        if (event.isMoreOrRefresh == 1 || _currentPage == 1) _currentPage++;
        final newSchedules = event.isMoreOrRefresh == 1 ? state.schedules + data.items : data.items;
        emit(state.copyWith(status: ScheduleStatus.success, schedules: newSchedules));
        break;
      case Failure(message: final error):
        emit(state.copyWith(status: ScheduleStatus.failure, message: error));
        break;
    }
  }

  Future<void> _onSyncSchedule(SyncSchedule event, Emitter<ScheduleState> emit) async {
    emit(state.copyWith(syncStatus: SyncStatus.loading));
    final result = await authRepository.syncSchedule(event.id);

    switch (result) {
      case Success(data: final data as SpecificStatusResponse<dynamic>):
        emit(state.copyWith(syncStatus: SyncStatus.success));

        add(const FetchSchedule(0));
        break;
      case Failure(message: final error):
        emit(state.copyWith(syncStatus: SyncStatus.failure, message: error));
        break;
    }
  }

  Future<void> _onDelSchedule(DelSchedule event, Emitter<ScheduleState> emit) async {
    emit(state.copyWith(delStatus: DelStatus.loading));
    final result = await authRepository.delSchedule(event.id);

    switch (result) {
      case Success(data: final data as SpecificStatusResponse<dynamic>):
        emit(state.copyWith(delStatus: DelStatus.success));

        add(const FetchSchedule(0));
        break;
      case Failure(message: final error):
        emit(state.copyWith(delStatus: DelStatus.failure, message: error));
        break;
    }
  }

  void _onUpdateFilter(UpdateFilter event, Emitter<ScheduleState> emit) {
    emit(state.copyWith(filter: event.filter));
  }

  void _onSearchSchedule(SearchSchedule event, Emitter<ScheduleState> emit) {
    emit(state.copyWith(searchQuery: event.searchQuery));
  }

  Future<void> _onCopySchedule(CopySchedule event, Emitter<ScheduleState> emit) async {
    final result = await authRepository.getDetailSchedule(event.id);

    switch (result) {
      case Success(data: final data as SpecificStatusResponse<DetailSchedule>):
        List<ScheduleDate>? scheduleDates = data.items?.scheduleDates.map((e) {
          return e.resetIds();
        }).toList();

        final result = await authRepository.createSchedule(data.items!.siteMapId, data.items!.name, scheduleDates!, data.items!.devices, 0);

        switch (result) {
          case Success(data: final data as SpecificStatusResponse<dynamic>):
            emit(state.copyWith(copyStatus: CopyStatus.success));
            add(const FetchSchedule(0));
            break;
          case Failure(message: final error):
            emit(state.copyWith(copyStatus: CopyStatus.failure, message: error));
            break;
        }
        break;
      case Failure(message: final error):
        emit(state.copyWith(message: error));
        break;
    }
  }
}
