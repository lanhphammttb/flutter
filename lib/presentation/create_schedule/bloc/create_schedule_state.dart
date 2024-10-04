part of 'create_schedule_bloc.dart';

abstract class CreateScheduleState {}

class CreateScheduleInitial extends CreateScheduleState {}

class CreateScheduleLoading extends CreateScheduleState {}

class CreateScheduleLoaded extends CreateScheduleState {
  final SpecificResponse<Schedule> data;

  CreateScheduleLoaded(this.data);
}

class CreateScheduleError extends CreateScheduleState {
  final String message;

  CreateScheduleError(this.message);
}

// Thêm trạng thái cập nhật
class CreateScheduleUpdated extends CreateScheduleState {
  final String location;
  final String device;
  final List<DateTime> selectedDates;

  CreateScheduleUpdated({
    required this.location,
    required this.device,
    required this.selectedDates,
  });
}

class SelectLocationState extends CreateScheduleState {
  final int location;

  SelectLocationState(this.location);
}

class SelectDeviceState extends CreateScheduleState {
  final List<int> devices;

  SelectDeviceState(this.devices);
}

class SelectDateState extends CreateScheduleState {
  final List<DateTime> dates;

  SelectDateState(this.dates);
}

class AddDateState extends CreateScheduleState {
  final DateTime date;

  AddDateState(this.date);
}

class RemoveDateState extends CreateScheduleState {
  final DateTime date;

  RemoveDateState(this.date);
}

class ScheduleSaved extends CreateScheduleState {}
