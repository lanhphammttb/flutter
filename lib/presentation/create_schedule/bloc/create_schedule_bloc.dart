import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nttcs/data/models/device.dart';
import 'package:nttcs/data/models/location.dart';
import 'package:nttcs/data/models/schedule.dart';
import 'package:nttcs/data/models/schedule_date.dart';
import 'package:nttcs/data/models/specific_response.dart';
import 'package:nttcs/data/models/tree_node.dart';
import 'package:nttcs/data/repositories/auth_repository.dart';
import 'package:nttcs/data/result_type.dart';
import 'package:equatable/equatable.dart';

part 'create_schedule_event.dart';

part 'create_schedule_state.dart';

class CreateScheduleBloc
    extends Bloc<CreateScheduleEvent, CreateScheduleState> {
  final AuthRepository authRepository;
  int locationSelected = 0;
  String name = '';
  List<ScheduleDate> scheduleDates = [];
  List<Device> devices = [];
  int id = 0;
  List<int> selectedDeviceIds = [];
  bool isInitialized = false; // Biến cờ để tránh khởi tạo lại khi không cần thiết

  CreateScheduleBloc(this.authRepository) : super(CreateScheduleInitial()) {
    on<CreateSchedule>(_onCreateSchedule);
    on<SelectLocationEvent>(_onSelectLocation);
    on<SelectDeviceEvent>(_onSelectDevice);
    on<AddDateEvent>(_onAddDate);
    on<InitializeCreateScheduleEvent>(_initializeCreateSchedule);
    on<SearchTextChanged>(_onSearchTextChanged);
    on<ExpandNodeEvent>(_onExpandNode);
    on<FetchLocationsEvent>(_onFetchLocations);
    on<FetchDevicesEvent>(_onFetchDevices);
  }

  Future<void> _onCreateSchedule(
      CreateSchedule event, Emitter<CreateScheduleState> emit) async {
    emit(CreateScheduleLoading());
    final result = await authRepository.createSchedule(
        locationSelected, name, scheduleDates, devices, id);

    if (result is Success) {
      emit(
          ScheduleSaved()); // Sau khi lưu, chuyển đến trạng thái 'ScheduleSaved'
    } else if (result is Failure) {
      emit(CreateScheduleError(result.message));
    }
  }

  void _onSelectLocation(
      SelectLocationEvent event, Emitter<CreateScheduleState> emit) async {
    emit(LocationSelected(event.locationName));
    _updateState(emit); // Cập nhật trạng thái
  }

  Future<void> _onSelectDevice(
      SelectDeviceEvent event, Emitter<CreateScheduleState> emit) async {
    final currentState = state;

    if (currentState is DeviceLoadedState) {
      // Nếu thiết bị đã được chọn, xóa nó khỏi danh sách selectedDeviceIds
      if (selectedDeviceIds.contains(event.device.id)) {
        selectedDeviceIds.remove(event.device.id);
      } else {
        // Nếu chưa chọn, thêm nó vào danh sách
        selectedDeviceIds.add(event.device.id);
      }

      emit(DeviceLoadedState(
          devices: currentState.devices, selectedDeviceIds: selectedDeviceIds));
    }
    _updateState(emit); // Cập nhật trạng thái
  }

  Future<void> _onAddDate(
      AddDateEvent event, Emitter<CreateScheduleState> emit) async {
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
    emit(CreateScheduleUpdated(
      location: 'Location ID $locationSelected',
      // Cập nhật tên địa điểm
      device: devices.isNotEmpty ? 'Selected Devices' : 'Toàn bộ địa bàn',
      // Cập nhật thiết bị
      selectedDates: scheduleDates
          .map((d) => DateTime.parse(d.date))
          .toList(), // Cập nhật danh sách ngày phát
    ));
  }

  Future<void> _initializeCreateSchedule(InitializeCreateScheduleEvent event, Emitter<CreateScheduleState> emit) async {
    if (!isInitialized) {
      emit(CreateScheduleLoading());
      // Any initialization logic, such as fetching necessary data
      await Future.delayed(Duration(seconds: 1)); // Simulate a delay for initialization
      emit(CreateScheduleUpdated(
        location: 'Chưa chọn',
        device: 'Toàn bộ địa bàn',
        selectedDates: [],
      ));
      isInitialized = true; // Đánh dấu đã khởi tạo xong
    }
  }
  Future<void> _onFetchLocations(
      FetchLocationsEvent event, Emitter<CreateScheduleState> emit) async {
    emit(LocationsLoading());

    try {
      final result = await authRepository.getLocations();

      if (result is Success) {
        // Assuming result.data contains the location items
        final data = result.data as SpecificResponse<Location>;
        List<TreeNode> treeNodes = TreeNode.buildTree(data.items);

        // Keep the original unfiltered list of nodes in state
        emit(LocationsSuccess(treeNodes, originalTreeNodes: treeNodes));
      } else if (result is Failure) {
        emit(LocationsFailure(result.message));
      }
    } catch (error) {
      emit(LocationsFailure(error.toString()));
    }
  }

  Future<void> _onFetchDevices(
      FetchDevicesEvent event, Emitter<CreateScheduleState> emit) async {
    emit(DeviceLoadingState());

    final result = await authRepository.getDevice(754, 1);
    switch (result) {
      case Success(data: final data as SpecificResponse<Device>):
        devices = data.items as List<Device>;
        emit(DeviceLoadedState(
            devices: devices, selectedDeviceIds: selectedDeviceIds));
        break;
      case Failure(message: final error):
        emit(DeviceErrorState(error));
        break;
    }
  }

  void _onSearchTextChanged(
      SearchTextChanged event, Emitter<CreateScheduleState> emit) {
    final currentState = state;
    if (currentState is LocationsSuccess) {
      final originalNodes = currentState.originalTreeNodes;

      if (event.searchText.isEmpty) {
        emit(LocationsSuccess(originalNodes, originalTreeNodes: originalNodes));
      } else {
        List<TreeNode> filteredNodes =
            TreeNode.trimTreeDFS(originalNodes, event.searchText);
        emit(LocationsSuccess(filteredNodes, originalTreeNodes: originalNodes));
      }
    }
  }

  void _onExpandNode(ExpandNodeEvent event, Emitter<CreateScheduleState> emit) {
    final currentState = state;
    if (currentState is LocationsSuccess) {
      List<TreeNode> updatedNodes = List.from(currentState.treeNodes);
      _toggleExpansion(event.node, updatedNodes);
      emit(LocationsSuccess(updatedNodes,
          originalTreeNodes: currentState
              .originalTreeNodes)); // Ensure the correct state type is emitted
    }
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
}
