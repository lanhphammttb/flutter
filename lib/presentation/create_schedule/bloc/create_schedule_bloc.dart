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
    on<RemoveSchedulePlaylistTimes>(_onRemoveSchedulePlaylistTimes);
    on<AddTimeLine>(_onAddTimeLine);
    on<AddScheduleDate>(_onAddScheduleDate);
    on<RemoveScheduleDate>(_onRemoveScheduleDate);
    on<ResetCreateSchedule>(_onResetCreateSchedule);
    on<FetchDetailSchedule>(_onFetchDetailSchedule);
    on<ExpandNode>(_onExpandNode);
    on<Del2Schedule>(_onDelSchedule);
    on<Sync2Schedule>(_onSaveAndSyncSchedule);
    on<EditDate>(_onEditDate);
  }

  Future<void> _onCreateSchedule(CreateSchedule event, Emitter<CreateScheduleState> emit) async {
    emit(state.copyWith(status: CreateScheduleStatus.loading));
    List<ScheduleDate> scheduleDates = state.scheduleDates.map((e) {
      return e.copyWith(date: convertDateFormat2(e.date));
    }).toList();
    final result = await authRepository.createSchedule(state.locationId, event.name, scheduleDates, state.devices.map((device) => device.id).toList(), 0);

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
    if (sharedLocationCubit.hasLocations()) {
      List<TreeNode> treeNodes = TreeNode.buildTree(sharedLocationCubit.state);
      emit(state.copyWith(treeNodes: treeNodes, originalTreeNodes: treeNodes, locationStatus: LocationStatus.success));
    } else {
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
    if (event.content != null) {
      final playlist = Playlist(
        id: 0,
        order: state.selectedNews.length,
        mediaProjectId: event.content!.banTinId,
        thoiLuong: event.content!.thoiLuong,
        duration: event.duration ?? event.content!.thoiLuong,
        tieuDe: event.content!.tieuDe,
      );

      emit(state.copyWith(selectedNews: List.from(state.selectedNews)..add(playlist)));
    } else {
      emit(state.copyWith(selectedNews: event.selectedNews));
    }
  }

  FutureOr<void> _onRemovePlaylist(RemovePlaylist event, Emitter<CreateScheduleState> emit) async {
    emit(state.copyWith(delPlaylistStatus: DelPlaylistStatus.loading));
    Playlist playlist = state.selectedNews[event.playlistIndex];
    if (playlist.id != 0) {
      final result = await authRepository.delPlaylist(playlist.id);

      switch (result) {
        case Success(data: final data as SpecificStatusResponse<dynamic>):
          emit(state.copyWith(selectedNews: List.from(state.selectedNews)..removeAt(event.playlistIndex), delPlaylistStatus: DelPlaylistStatus.success));
          break;
        case Failure(message: final error):
          emit(state.copyWith(message: error));
          break;
      }
    } else {
      emit(state.copyWith(selectedNews: List.from(state.selectedNews)..removeAt(event.playlistIndex), delPlaylistStatus: DelPlaylistStatus.success));
    }
  }

  void _onAddTimeLine(AddTimeLine event, Emitter<CreateScheduleState> emit) {
    final newSchedulePlaylistTime = SchedulePlaylistTime(
      id: event.index == -1 ? 0 : state.schedulePlaylistTimes[event.index].id,
      name: event.nameTimeLine,
      start: event.startTime,
      end: event.endTime,
      playlists: state.selectedNews.asMap().entries.map((entry) {
        return Playlist(
          id: 0,
          order: entry.key,
          mediaProjectId: entry.value.mediaProjectId,
          thoiLuong: entry.value.thoiLuong,
          duration: entry.value.duration,
        );
      }).toList(),
    );

    final updatedSchedulePlaylistTimes = List<SchedulePlaylistTime>.from(state.schedulePlaylistTimes);

    if (event.index == -1) {
      updatedSchedulePlaylistTimes.add(newSchedulePlaylistTime);
    } else {
      updatedSchedulePlaylistTimes[event.index] = newSchedulePlaylistTime;
    }

    emit(state.copyWith(schedulePlaylistTimes: updatedSchedulePlaylistTimes));
  }

  void _onAddScheduleDate(AddScheduleDate event, Emitter<CreateScheduleState> emit) {
    final scheduleDate = ScheduleDate(
      id: state.dateIndex == -1 ? 0 : state.scheduleDates[state.dateIndex].id,
      date: state.dateString.isNotEmpty ? state.dateString : DateFormat(Constants.formatDate2).format(DateTime.now()),
      schedulePlaylistTimes: state.schedulePlaylistTimes,
    );

    final updatedScheduleDates = List<ScheduleDate>.from(state.scheduleDates);

    if (state.dateIndex == -1) {
      updatedScheduleDates.add(scheduleDate);
    } else {
      updatedScheduleDates[state.dateIndex] = scheduleDate;
    }

    emit(state.copyWith(
      scheduleDates: updatedScheduleDates,
      schedulePlaylistTimes: [],
      dateString: '',
    ));
  }

  FutureOr<void> _onRemoveScheduleDate(RemoveScheduleDate event, Emitter<CreateScheduleState> emit) async {
    ScheduleDate scheduleDate = state.scheduleDates[event.dateIndex];
    if (scheduleDate.id != 0) {
      final result = await authRepository.delScheduleDate(scheduleDate.id);
      switch (result) {
        case Success(data: final data as SpecificStatusResponse<dynamic>):
          if (data.status) {
            emit(state.copyWith(scheduleDates: List.from(state.scheduleDates)..removeAt(event.dateIndex)));
          } else {
            emit(state.copyWith(message: data.message));
          }
          break;
        case Failure(message: final error):
          emit(state.copyWith(message: error));
          break;
      }
    } else {
      emit(state.copyWith(scheduleDates: List.from(state.scheduleDates)..removeAt(event.dateIndex)));
    }
  }

  void _onCopyDate(CopyDate event, Emitter<CreateScheduleState> emit) {
    final updatedScheduleDates = [
      ...state.scheduleDates,
      ...event.dates.map((date) => ScheduleDate(
            id: 0,
            date: date,
            schedulePlaylistTimes: event.scheduleDate.schedulePlaylistTimes.map((e) {
              return e.resetIds();
            }).toList(),
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
      List<TreeNode> treeNodes = TreeNode.buildTree(sharedLocationCubit.state);
      emit(state.copyWith(
          treeNodes: treeNodes, originalTreeNodes: treeNodes, locationStatus: LocationStatus.success, locationId: event.locationId, locationCode: node.code));
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
    final result = await authRepository.createSchedule(
        state.locationId, event.scheduleName, state.scheduleDates, state.devices.map((device) => device.id).toList(), state.detailSchedule?.id ?? 0);
    switch (result) {
      case Success(data: final data as SpecificStatusResponse<Schedule>):
        emit(state.copyWith(status: CreateScheduleStatus.success, syncStatus: SyncStatus.loading));
        final result = await authRepository.syncSchedule(data.items?.id ?? 0);

        switch (result) {
          case Success(data: final data as SpecificStatusResponse<dynamic>):
            emit(state.copyWith(syncStatus: SyncStatus.success));
            break;
          case Failure(message: final error):
            emit(state.copyWith(syncStatus: SyncStatus.failure, message: error));
            break;
        }
        break;
      case Failure(message: final error):
        emit(state.copyWith(status: CreateScheduleStatus.failure, message: error));
        break;
    }
  }

  void _onEditDate(EditDate event, Emitter<CreateScheduleState> emit) {
    if (event.index == -1) {
      emit(state.copyWith(dateString: '', schedulePlaylistTimes: [], dateIndex: event.index));
      return;
    } else {
      final ScheduleDate scheduleDate = state.scheduleDates[event.index];

      emit(state.copyWith(dateString: scheduleDate.date, schedulePlaylistTimes: scheduleDate.schedulePlaylistTimes, dateIndex: event.index));
    }
  }

  FutureOr<void> _onRemoveSchedulePlaylistTimes(RemoveSchedulePlaylistTimes event, Emitter<CreateScheduleState> emit) async {
    SchedulePlaylistTime schedulePlaylistTime = state.schedulePlaylistTimes[event.index];
    if (schedulePlaylistTime.id != 0) {
      final result = await authRepository.delSchedulePlaylistTime(schedulePlaylistTime.id);

      switch (result) {
        case Success(data: final data as SpecificStatusResponse<dynamic>):
          if (data.status) {
            emit(state.copyWith(schedulePlaylistTimes: List.from(state.schedulePlaylistTimes)..removeAt(event.index)));
          } else {
            emit(state.copyWith(message: data.message));
          }
          break;
        case Failure(message: final error):
          emit(state.copyWith(message: error));
          break;
      }
    } else {
      emit(state.copyWith(schedulePlaylistTimes: List.from(state.schedulePlaylistTimes)..removeAt(event.index)));
    }
  }
}
