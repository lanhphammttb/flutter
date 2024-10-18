import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:nttcs/data/models/content.dart';
import 'package:nttcs/data/models/device.dart';
import 'package:nttcs/data/models/location.dart';
import 'package:nttcs/data/models/schedule.dart';
import 'package:nttcs/data/models/schedule_date.dart';
import 'package:nttcs/data/models/specific_response.dart';
import 'package:nttcs/data/models/tree_node.dart';
import 'package:nttcs/data/repositories/auth_repository.dart';
import 'package:nttcs/data/result_type.dart';
import 'package:equatable/equatable.dart';
import 'package:nttcs/presentation/news/bloc/news_bloc.dart';

part 'create_schedule_event.dart';

part 'create_schedule_state.dart';

class CreateScheduleBloc extends Bloc<CreateScheduleEvent, CreateScheduleState> {
  final AuthRepository authRepository;
  int locationSelected = 0;
  String name = '';
  List<ScheduleDate> scheduleDates = [];
  List<Device> devices = [];
  int id = 0;
  bool isInitialized = false; // Biến cờ để tránh khởi tạo lại khi không cần thiết

  CreateScheduleBloc(this.authRepository) : super(const CreateScheduleState()) {
    on<CreateSchedule>(_onCreateSchedule);
    on<SelectLocationEvent>(_onSelectLocation);
    on<SelectDevice>(_onSelectDevice);
    on<SelectAllDevices>(_onSelectAllDevices);
    on<AddDateEvent>(_onAddDate);
    on<InitializeCreateScheduleEvent>(_initializeCreateSchedule);
    on<SearchTextChanged>(_onSearchTextChanged);
    on<DeviceSearchTextChanged>(_onDeviceSearchTextChanged);
    on<ExpandNodeEvent>(_onExpandNode);
    on<FetchLocations>(_onFetchLocations);
    on<FetchDevices>(_onFetchDevices);
    on<DateStringChanged>(_onDateStringChanged);
    on<FetchNews3>(_onFetchNews);
    on<SelectNews>(_onSelectNews);
    on<RemovePlaylist>(_onRemovePlaylist);
    on<AddTimeLine>(_onAddTimeLine);
  }

  Future<void> _onCreateSchedule(CreateSchedule event, Emitter<CreateScheduleState> emit) async {
    // emit(CreateScheduleLoading());
    // final result = await authRepository.createSchedule(
    //     locationSelected, name, scheduleDates, devices, id);
    //
    // if (result is Success) {
    //   emit(
    //       ScheduleSaved()); // Sau khi lưu, chuyển đến trạng thái 'ScheduleSaved'
    // } else if (result is Failure) {
    //   emit(CreateScheduleError(result.message));
    // }
  }

  void _onSelectLocation(SelectLocationEvent event, Emitter<CreateScheduleState> emit) async {
    emit(state.copyWith(location: event.locationName));
    _updateState(emit); // Cập nhật trạng thái
  }

  void _onSelectDevice(SelectDevice event, Emitter<CreateScheduleState> emit) async {
    if (state.deviceStatus == DeviceStatus.success) {
      final updatedSelectedItems = Set<int>.from(state.selectedDeviceIds);
      if (!updatedSelectedItems.add(event.deviceId)) {
        updatedSelectedItems.remove(event.deviceId);
      }
      emit(state.copyWith(selectedDeviceIds: updatedSelectedItems.toList()));
    }
    _updateState(emit); // Cập nhật trạng thái
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
    _updateState(emit); // Cập nhật trạng thái
  }

  Future<void> _onAddDate(AddDateEvent event, Emitter<CreateScheduleState> emit) async {
    scheduleDates.add(ScheduleDate(
      id: 0,
      date: event.date.toIso8601String(),
      datesCopy: '',
      schedulePlaylistTimes: [],
    ));
    _updateState(emit); // Cập nhật trạng thái
  }

  // Hàm dùng để cập nhật trạng thái CreateScheduleUpdated
  void _updateState(Emitter<CreateScheduleState> emit) {
    // emit(CreateScheduleUpdated(
    //   location: 'Location ID $locationSelected',
    //   // Cập nhật tên địa điểm
    //   device: devices.isNotEmpty ? 'Selected Devices' : 'Toàn bộ địa bàn',
    //   // Cập nhật thiết bị
    //   selectedDates: scheduleDates.map((d) => DateTime.parse(d.date)).toList(), // Cập nhật danh sách ngày phát
    // ));
  }

  Future<void> _initializeCreateSchedule(InitializeCreateScheduleEvent event, Emitter<CreateScheduleState> emit) async {
    // if (!isInitialized) {
    //   emit(CreateScheduleLoading());
    //   // Any initialization logic, such as fetching necessary data
    //   await Future.delayed(Duration(seconds: 1)); // Simulate a delay for initialization
    //   emit(CreateScheduleUpdated(
    //     location: 'Chưa chọn',
    //     device: 'Toàn bộ địa bàn',
    //     selectedDates: [],
    //   ));
    //   isInitialized = true; // Đánh dấu đã khởi tạo xong
    // }
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
        List<TreeNode> treeNodes = TreeNode.buildTree(data.items);
        emit(state.copyWith(locationStatus: LocationStatus.success, treeNodes: treeNodes, originalTreeNodes: treeNodes));
        break;
      case Failure(message: final error):
        emit(state.copyWith(locationStatus: LocationStatus.failure, message: error));
        break;
    }
  }

  Future<void> _onFetchDevices(FetchDevices event, Emitter<CreateScheduleState> emit) async {
    emit(state.copyWith(deviceStatus: DeviceStatus.loading));

    final result = await authRepository.getDevice(754, 1);
    switch (result) {
      case Success(data: final data as SpecificResponse<Device>):
        devices = data.items;
        emit(state.copyWith(deviceStatus: DeviceStatus.success, devices: devices));
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

  void _onExpandNode(ExpandNodeEvent event, Emitter<CreateScheduleState> emit) {
    // final currentState = state;
    // if (currentState is LocationsSuccess) {
    //   List<TreeNode> updatedNodes = List.from(currentState.treeNodes);
    //   _toggleExpansion(event.node, updatedNodes);
    //   emit(LocationsSuccess(updatedNodes, originalTreeNodes: currentState.originalTreeNodes)); // Ensure the correct state type is emitted
    // }
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
    final result = await authRepository.getNews(event.contentType, 1, 1);

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
      playlists: state.selectedNews.map((content) => Playlist(id: 0, order: state.selectedNews.indexOf(content), mediaProjectId: content.banTinId, thoiLuong: content.thoiLuong)).toList(),
    );

    final updatedScheduleDates = List<ScheduleDate>.from(state.schedulePlaylistTimes)..add(ScheduleDate(
      id: 0,
      date: DateFormat('yyyy-MM-dd').format(DateTime.now()),
      datesCopy: '',
      schedulePlaylistTimes: [schedulePlaylistTime],
    ));

    emit(state.copyWith(schedulePlaylistTimes: updatedScheduleDates));
  }
}
