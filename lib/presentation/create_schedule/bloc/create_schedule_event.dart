part of 'create_schedule_bloc.dart';

class CreateScheduleEvent extends Equatable {
  const CreateScheduleEvent();

  @override
  List<Object> get props => [];
}

class CreateSchedule extends CreateScheduleEvent {}

class InitializeCreateScheduleEvent extends CreateScheduleEvent {}

class SelectLocationEvent extends CreateScheduleEvent {
  final String locationName;

  const SelectLocationEvent(this.locationName);
}

class SelectDevice extends CreateScheduleEvent {
  final int deviceId;

  const SelectDevice(this.deviceId);

  @override
  List<Object> get props => [deviceId];
}

class SelectAllDevices extends CreateScheduleEvent {
  const SelectAllDevices();
}

class AddDateEvent extends CreateScheduleEvent {
  final DateTime date;

  const AddDateEvent(this.date);
}

class AddPlaylist extends CreateScheduleEvent {
  final int dateIndex;

  const AddPlaylist(this.dateIndex);
}

class RemovePlaylist extends CreateScheduleEvent {
  final int playlistIndex;

  const RemovePlaylist(this.playlistIndex);

  @override
  List<Object> get props => [playlistIndex];
}

class UpdatePlaylist extends CreateScheduleEvent {
  final int dateIndex;
  final int timeIndex;
  final String time;

  const UpdatePlaylist(this.dateIndex, this.timeIndex, this.time);
}

class FetchLocations extends CreateScheduleEvent {}

class SearchTextChanged extends CreateScheduleEvent {
  final String searchText;

  const SearchTextChanged(this.searchText);

  @override
  List<Object> get props => [searchText];
}

class DeviceSearchTextChanged extends SearchTextChanged {
  const DeviceSearchTextChanged(super.searchText);

  @override
  List<Object> get props => [searchText];
}

class ExpandNodeEvent extends CreateScheduleEvent {
  final TreeNode node;

  const ExpandNodeEvent(this.node);

  @override
  List<Object> get props => [node];
}

class FetchDevices extends CreateScheduleEvent {}

class DateStringChanged extends CreateScheduleEvent {
  final String dateString;

  const DateStringChanged(this.dateString);

  @override
  List<Object> get props => [dateString];
}

class FetchNews3 extends CreateScheduleEvent {
  final int contentType;

  const FetchNews3(this.contentType);

  @override
  List<Object> get props => [contentType];
}

class SelectNews extends CreateScheduleEvent {
  final Content content;

  const SelectNews(this.content);

  @override
  List<Object> get props => [content];
}

class AddTimeLine extends CreateScheduleEvent {
  final String nameTimeLine;
  final String startTime;
  final String endTime;

  const AddTimeLine(this.nameTimeLine, this.startTime, this.endTime);

  @override
  List<Object> get props => [nameTimeLine, startTime, endTime];
}

class AddScheduleDate extends CreateScheduleEvent {
  const AddScheduleDate();
}

class RemoveScheduleDate extends CreateScheduleEvent {
  final int dateIndex;

  const RemoveScheduleDate(this.dateIndex);

  @override
  List<Object> get props => [dateIndex];
}