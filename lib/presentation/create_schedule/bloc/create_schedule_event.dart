part of 'create_schedule_bloc.dart';

 class CreateScheduleEvent extends Equatable{
  const CreateScheduleEvent();

  @override
  List<Object> get props => [];
 }

class CreateSchedule extends CreateScheduleEvent {}
class InitializeCreateScheduleEvent extends CreateScheduleEvent {}
class SelectLocationEvent extends CreateScheduleEvent {
  final String locationName;
  SelectLocationEvent(this.locationName);
}

class SelectDeviceEvent extends CreateScheduleEvent {
  final Device device;

  SelectDeviceEvent(this.device);
}

class ToggleSelectAllDevicesEvent extends CreateScheduleEvent {
  final bool selectAll;

  ToggleSelectAllDevicesEvent(this.selectAll);
}
class AddDateEvent extends CreateScheduleEvent {
  final DateTime date;
  AddDateEvent(this.date);
}

class AddPlaylist extends CreateScheduleEvent {
  final int dateIndex;
  AddPlaylist(this.dateIndex);
}

class RemovePlaylist extends CreateScheduleEvent {
  final int dateIndex;
  final int timeIndex;
  RemovePlaylist(this.dateIndex, this.timeIndex);
}

class UpdatePlaylist extends CreateScheduleEvent {
  final int dateIndex;
  final int timeIndex;
  final String time;
  UpdatePlaylist(this.dateIndex, this.timeIndex, this.time);
}

class FetchLocationsEvent extends CreateScheduleEvent {}

class SearchTextChanged extends CreateScheduleEvent {
  final String searchText;

  const SearchTextChanged(this.searchText);

  @override
  List<Object> get props => [searchText];
}

class ExpandNodeEvent extends CreateScheduleEvent {
  final TreeNode node;

  const ExpandNodeEvent(this.node);

  @override
  List<Object> get props => [node];
}

class FetchDevicesEvent extends CreateScheduleEvent{}