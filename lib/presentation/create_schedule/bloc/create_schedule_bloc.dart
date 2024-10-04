import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nttcs/data/models/device.dart';
import 'package:nttcs/data/models/schedule.dart';
import 'package:nttcs/data/models/schedule_date.dart';
import 'package:nttcs/data/models/specific_response.dart';
import 'package:nttcs/data/repositories/auth_repository.dart';
import 'package:nttcs/data/result_type.dart';

part 'create_schedule_event.dart';
part 'create_schedule_state.dart';

class CreateScheduleBloc extends Bloc<CreateScheduleEvent, CreateScheduleState> {
  final AuthRepository authRepository;
  int locationSelected = 0;
  String name = '';
  List<ScheduleDate> scheduleDates = [];
  List<Device> devices = [];
  int id = 0;

  CreateScheduleBloc(this.authRepository) : super(CreateScheduleInitial()) {
    on<CreateSchedule>(_onCreateSchedule);
    on<SelectLocationEvent>(_onSelectLocation);
    on<SelectDeviceEvent>(_onSelectDevice);
    on<AddDateEvent>(_onAddDate);
    on<InitializeCreateScheduleEvent>(_initializeCreateSchedule);
  }

  Future<void> _onCreateSchedule(CreateSchedule event, Emitter<CreateScheduleState> emit) async {
    emit(CreateScheduleLoading());
    final result = await authRepository.createSchedule(
        locationSelected, name, scheduleDates, devices, id);

    if (result is Success) {
      emit(ScheduleSaved()); // Sau khi lưu, chuyển đến trạng thái 'ScheduleSaved'
    } else if (result is Failure) {
      emit(CreateScheduleError(result.message));
    }
  }

  Future<void> _onSelectLocation(SelectLocationEvent event, Emitter<CreateScheduleState> emit) async {
    locationSelected = event.location;
    _updateState(emit); // Cập nhật trạng thái
  }

  Future<void> _onSelectDevice(SelectDeviceEvent event, Emitter<CreateScheduleState> emit) async {
    devices = event.devices;
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
    emit(CreateScheduleUpdated(
      location: 'Location ID $locationSelected', // Cập nhật tên địa điểm
      device: devices.isNotEmpty ? 'Selected Devices' : 'Toàn bộ địa bàn', // Cập nhật thiết bị
      selectedDates: scheduleDates.map((d) => DateTime.parse(d.date)).toList(), // Cập nhật danh sách ngày phát
    ));
  }

  Future<void> _initializeCreateSchedule(InitializeCreateScheduleEvent event, Emitter<CreateScheduleState> emit) async {
    emit(CreateScheduleUpdated(
      location: 'Chưa chọn',
      device: 'Toàn bộ địa bàn',
      selectedDates: [],
    ));
  }
}

