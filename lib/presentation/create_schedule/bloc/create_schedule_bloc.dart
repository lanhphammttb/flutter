import 'dart:async';
import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:nttcs/core/constants/constants.dart';
import 'package:nttcs/core/utils/functions.dart';
import 'package:nttcs/data/models/content.dart';
import 'package:nttcs/data/models/detail_schedule.dart';
import 'package:nttcs/data/models/device.dart';
import 'package:nttcs/data/models/location.dart';
import 'package:nttcs/data/models/schedule.dart';
import 'package:nttcs/data/models/schedule_date.dart';
import 'package:nttcs/data/models/specific_response.dart';
import 'package:nttcs/data/models/specific_status_reponse.dart';
import 'package:nttcs/data/models/tree_node.dart';
import 'package:nttcs/data/repositories/auth_repository.dart';
import 'package:nttcs/data/result_type.dart';
import 'package:nttcs/presentation/news/bloc/news_bloc.dart';
import 'package:nttcs/presentation/schedule/bloc/schedule_bloc.dart';
import 'package:nttcs/shared/shared_bloc.dart';

part 'create_schedule_event.dart';

part 'create_schedule_state.dart';

class CreateScheduleBloc extends Bloc<CreateScheduleEvent, CreateScheduleState> {
  final AuthRepository authRepository;
  final SharedLocationCubit sharedLocationCubit;

  CreateScheduleBloc(this.authRepository, this.sharedLocationCubit) : super(const CreateScheduleState()) {
    on<CreateSchedule>(_onCreateSchedule);
    on<SelectLocation>(_onSelectLocation);
    on<SelectDevice>(_onSelectDevice);
    on<SelectAllDevices>(_onSelectAllDevices);
    on<CopyDate>(_onCopyDate);
    on<SearchTextChanged>(_onSearchTextChanged);
    on<DeviceSearchTextChanged>(_onDeviceSearchTextChanged);
    on<FetchLocations>(_onFetchLocations);
    on<FetchDevices>(_onFetchDevices);
    on<DateStringChanged>(_onDateStringChanged);
    on<FetchNews3>(_onFetchNews);
    on<SelectNews>(_onSelectNews);
    on<RemovePlaylist>(_onRemovePlaylist);
    on<AddTimeLine>(_onAddTimeLine);
    on<AddScheduleDate>(_onAddScheduleDate);
    on<RemoveScheduleDate>(_onRemoveScheduleDate);
    on<ResetCreateSchedule>(_onResetCreateSchedule);
    on<FetchDetailSchedule>(_onFetchDetailSchedule);
    on<ExpandNode>(_onExpandNode);
    on<Del2Schedule>(_onDelSchedule);
    on<Sync2Schedule>(_onSaveAndSyncSchedule);
  }

  Future<void> _onCreateSchedule(CreateSchedule event, Emitter<CreateScheduleState> emit) async {
    emit(state.copyWith(status: CreateScheduleStatus.loading));
    final result = await authRepository.createSchedule(state.locationId, event.name, state.scheduleDates, state.devices, 0);

    if (result is Success) {
      emit(state.copyWith(status: CreateScheduleStatus.success));
    } else if (result is Failure) {
      emit(state.copyWith(status: CreateScheduleStatus.failure, message: result.message));
    }
  }

  void _onSelectLocation(SelectLocation event, Emitter<CreateScheduleState> emit) async {
    if (event.scheduleName != null) {
      emit(state.copyWith(locationName: event.locationName, locationId: event.locationId, scheduleName: event.scheduleName, locationCode: event.locationCode));
    } else {
      emit(state.copyWith(locationName: event.locationName, locationId: event.locationId));
    }
  }

  void _onSelectDevice(SelectDevice event, Emitter<CreateScheduleState> emit) async {
    if (state.deviceStatus == DeviceStatus.success) {
      final updatedSelectedItems = Set<int>.from(state.selectedDeviceIds);
      if (!updatedSelectedItems.add(event.deviceId)) {
        updatedSelectedItems.remove(event.deviceId);
      }
      emit(state.copyWith(selectedDeviceIds: updatedSelectedItems.toList()));
    }
  }

  void _onSelectAllDevices(SelectAllDevices event, Emitter<CreateScheduleState> emit) {
    if (state.deviceStatus == DeviceStatus.success) {
      if (state.isSelectAll) {
        emit(state.copyWith(selectedDeviceIds: [], isSelectAll: false));
      } else {
        final allDeviceIds = state.devices.map((device) => device.id).toList();
        emit(state.copyWith(selectedDeviceIds: allDeviceIds, isSelectAll: true));
      }
    }
  }

  void _emitLoadingStateDelayed(Emitter<CreateScheduleState> emit) {
    Future.delayed(const Duration(milliseconds: 1500)).then((_) {
      if (emit.isDone) return;
      emit(state.copyWith(locationStatus: LocationStatus.loading));
    });
  }

  Future<void> _onFetchLocations(FetchLocations event, Emitter<CreateScheduleState> emit) async {
    _emitLoadingStateDelayed(emit);

    final result = await authRepository.getLocations();

    switch (result) {
      case Success(data: final data as SpecificResponse<Location>):
        sharedLocationCubit.setLocations(data.items);
        List<TreeNode> treeNodes = TreeNode.buildTree(data.items);
        Location node = data.items.firstWhere((element) => element.id == state.locationId);
        emit(state.copyWith(locationStatus: LocationStatus.success, treeNodes: treeNodes, originalTreeNodes: treeNodes, locationCode: node.code));
        break;
      case Failure(message: final error):
        emit(state.copyWith(locationStatus: LocationStatus.failure, message: error));
        break;
    }
  }

  Future<void> _onFetchDevices(FetchDevices event, Emitter<CreateScheduleState> emit) async {
    emit(state.copyWith(deviceStatus: DeviceStatus.loading));

    final result = await authRepository.getDevice(state.locationId, 1);
    switch (result) {
      case Success(data: final data as SpecificResponse<Device>):
        emit(state.copyWith(deviceStatus: DeviceStatus.success, devices: data.items));
        break;
      case Failure(message: final error):
        emit(state.copyWith(deviceStatus: DeviceStatus.failure, message: error));
        break;
    }
  }

  void _onSearchTextChanged(SearchTextChanged event, Emitter<CreateScheduleState> emit) {
    if (state.locationStatus == LocationStatus.success) {
      final originalNodes = state.originalTreeNodes;

      if (event.searchText.isEmpty) {
        emit(state.copyWith(treeNodes: originalNodes, locationSearchQuery: event.searchText));
      } else {
        List<TreeNode> filteredNodes = TreeNode.trimTreeDFS(originalNodes, event.searchText);
        emit(state.copyWith(treeNodes: filteredNodes, locationSearchQuery: event.searchText));
      }
    }
  }

  void _onDeviceSearchTextChanged(DeviceSearchTextChanged event, Emitter<CreateScheduleState> emit) {
    if (state.deviceStatus == DeviceStatus.success) {
      emit(state.copyWith(deviceSearchQuery: event.searchText));
    }
  }

  void _onDateStringChanged(DateStringChanged event, Emitter<CreateScheduleState> emit) {
    emit(state.copyWith(dateString: event.dateString));
  }

  Future<void> _onFetchNews(FetchNews3 event, Emitter<CreateScheduleState> emit) async {
    emit(state.copyWith(contentType: event.contentType));
    final result = await authRepository.getNews(event.contentType, state.locationCode, 1, 1);

    switch (result) {
      case Success(data: final data as SpecificResponse<Content>):
        emit(state.copyWith(newsStatus: NewsStatus.success, news: data.items));
        break;
      case Failure(message: final error):
        emit(state.copyWith(newsStatus: NewsStatus.failure, message: error));
        break;
    }
  }

  void _onSelectNews(SelectNews event, Emitter<CreateScheduleState> emit) {
    emit(state.copyWith(selectedNews: state.selectedNews + [event.content]));
  }

  void _onRemovePlaylist(RemovePlaylist event, Emitter<CreateScheduleState> emit) {
    final updatedSelectedItems = List<Content>.from(state.selectedNews)..removeAt(event.playlistIndex);

    emit(state.copyWith(selectedNews: updatedSelectedItems));
  }

  void _onAddTimeLine(AddTimeLine event, Emitter<CreateScheduleState> emit) {
    SchedulePlaylistTime schedulePlaylistTime = SchedulePlaylistTime(
      id: 0,
      name: event.nameTimeLine,
      start: event.startTime,
      end: event.endTime,
      playlists: state.selectedNews.asMap().entries.map((entry) {
        final index = entry.key;
        final content = entry.value;
        return Playlist(
          id: 0,
          order: index,
          mediaProjectId: content.banTinId,
          thoiLuong: content.thoiLuong,
        );
      }).toList(),
    );

    final updatedScheduleDates = List<SchedulePlaylistTime>.from(state.schedulePlaylistTimes)..add(schedulePlaylistTime);

    emit(state.copyWith(schedulePlaylistTimes: updatedScheduleDates, selectedNews: []));
  }

  void _onAddScheduleDate(AddScheduleDate event, Emitter<CreateScheduleState> emit) {
    ScheduleDate scheduleDate = ScheduleDate(
      id: 0,
      date: state.dateString == '' ? DateFormat(Constants.formatDate).format(DateTime.now()) : state.dateString,
      schedulePlaylistTimes: state.schedulePlaylistTimes,
    );

    final updatedScheduleDates = List<ScheduleDate>.from(state.scheduleDates)..add(scheduleDate);

    emit(state.copyWith(scheduleDates: updatedScheduleDates, schedulePlaylistTimes: []));
  }

  void _onRemoveScheduleDate(RemoveScheduleDate event, Emitter<CreateScheduleState> emit) {
    final updatedScheduleDates = List<ScheduleDate>.from(state.scheduleDates)..removeAt(event.dateIndex);

    emit(state.copyWith(scheduleDates: updatedScheduleDates));
  }

  void _onCopyDate(CopyDate event, Emitter<CreateScheduleState> emit) {
    final updatedScheduleDates = [
      ...state.scheduleDates,
      ...event.dates.map((date) => ScheduleDate(
            id: 0,
            date: date,
            schedulePlaylistTimes: List.from(event.scheduleDate.schedulePlaylistTimes),
          )),
    ];

    emit(state.copyWith(scheduleDates: updatedScheduleDates));
  }

  void _onResetCreateSchedule(ResetCreateSchedule event, Emitter<CreateScheduleState> emit) {
    emit(const CreateScheduleState());
  }

  Future<void> _onFetchDetailSchedule(FetchDetailSchedule event, Emitter<CreateScheduleState> emit) async {
    emit(state.copyWith(scheduleName: event.scheduleName, locationName: event.locationName, locationId: event.locationId));

    if (sharedLocationCubit.hasLocations()) {
      Location node = sharedLocationCubit.state.firstWhere((element) => element.id == event.locationId);
      log('node: $node');
      emit(state.copyWith(
          treeNodes: TreeNode.buildTree(sharedLocationCubit.state),
          originalTreeNodes: TreeNode.buildTree(sharedLocationCubit.state),
          locationStatus: LocationStatus.success,
          locationId: event.locationId,
          locationCode: node.code));
    } else {
      add(FetchLocations());
    }

    final result = await authRepository.getDetailSchedule(event.scheduleId);

    switch (result) {
      case Success(data: final data as SpecificStatusResponse<DetailSchedule>):
        List<ScheduleDate>? scheduleDates = data.items?.scheduleDates.map((e) {
          return e.copyWith(date: convertDateFormat(e.date));
        }).toList();

        emit(state.copyWith(detailSchedule: data.items, selectedDeviceIds: data.items?.devices, scheduleDates: scheduleDates));
        break;
      case Failure(message: final error):
        emit(state.copyWith(message: error));
        break;
    }
  }

  void _onExpandNode(ExpandNode event, Emitter<CreateScheduleState> emit) {
    List<TreeNode> updatedNodes = List.from(state.treeNodes);
    _toggleExpansion(event.node, updatedNodes);
    emit(state.copyWith(treeNodes: updatedNodes));
  }

  void _toggleExpansion(TreeNode node, List<TreeNode> nodes) {
    for (var n in nodes) {
      if (n == node) {
        n.isExpanded = !n.isExpanded;
        break;
      } else if (n.hasChildren()) {
        _toggleExpansion(node, n.children);
      }
    }
  }

  Future<void> _onDelSchedule(Del2Schedule event, Emitter<CreateScheduleState> emit) async {
    emit(state.copyWith(delStatus: DelStatus.loading));
    final result = await authRepository.delSchedule(state.detailSchedule?.id ?? 0);

    switch (result) {
      case Success(data: final data as SpecificStatusResponse<dynamic>):
        emit(state.copyWith(delStatus: DelStatus.success));
        break;
      case Failure(message: final error):
        emit(state.copyWith(delStatus: DelStatus.failure, message: error));
        break;
    }
  }

  Future<void> _onSaveAndSyncSchedule(Sync2Schedule event, Emitter<CreateScheduleState> emit) async {
    emit(state.copyWith(status: CreateScheduleStatus.loading));
    final result = await authRepository.createSchedule(state.locationId, event.scheduleName, state.scheduleDates, state.devices, state.detailSchedule?.id ?? 0);

    if (result is Success) {
      emit(state.copyWith(status: CreateScheduleStatus.success, syncStatus: SyncStatus.loading));
      final result = await authRepository.syncSchedule(state.detailSchedule?.id ?? 0);

      switch (result) {
        case Success(data: final data as SpecificStatusResponse<dynamic>):
          emit(state.copyWith(syncStatus: SyncStatus.success));
          break;
        case Failure(message: final error):
          emit(state.copyWith(syncStatus: SyncStatus.failure, message: error));
          break;
      }
    } else if (result is Failure) {
      emit(state.copyWith(status: CreateScheduleStatus.failure, message: result.message));
    }
  }
}
