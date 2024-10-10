part of 'create_schedule_bloc.dart';

 class CreateScheduleState extends Equatable{
  const CreateScheduleState();

  @override
  List<Object> get props => [];
 }

class CreateScheduleInitial extends CreateScheduleState {}

class CreateScheduleLoading extends CreateScheduleState {}

class CreateScheduleLoaded extends CreateScheduleState {
  final SpecificResponse<Schedule> data;

  const CreateScheduleLoaded(this.data);

  @override
  List<Object> get props => [data];
}

class CreateScheduleError extends CreateScheduleState {
  final String message;

  const CreateScheduleError(this.message);

  @override
  List<Object> get props => [message];
}

// Thêm trạng thái cập nhật
class CreateScheduleUpdated extends CreateScheduleState {
  final String location;
  final String device;
  final List<DateTime> selectedDates;

  const CreateScheduleUpdated({
    required this.location,
    required this.device,
    required this.selectedDates,
  });

  @override
  List<Object> get props => [location, device, selectedDates];
}

class SelectLocationState extends CreateScheduleState {
  final int location;

  const SelectLocationState(this.location);

  @override
  List<Object> get props => [location];
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

class LocationsLoading extends CreateScheduleState {}

class LocationsSuccess extends CreateScheduleState {
  final List<TreeNode> treeNodes;
  final List<TreeNode> originalTreeNodes;
  const LocationsSuccess(this.treeNodes, {required this.originalTreeNodes});

  @override
  List<Object> get props => [treeNodes, originalTreeNodes];
}

class LocationsFailure extends CreateScheduleState {
  final String error;

  const LocationsFailure(this.error);

  @override
  List<Object> get props => [error];
}

class LocationSelected extends CreateScheduleState {
  final String locationName;

  const LocationSelected(this.locationName);

  @override
  List<Object> get props => [locationName];
}

class DeviceLoadingState extends CreateScheduleState {}

class DeviceLoadedState extends CreateScheduleState {
  final List<Device> devices;
  final List<int> selectedDeviceIds;
  final bool isAllSelected;

  DeviceLoadedState({required this.devices, required this.selectedDeviceIds, this.isAllSelected = false});
}

class DeviceErrorState extends CreateScheduleState {
  final String error;

  DeviceErrorState(this.error);
}