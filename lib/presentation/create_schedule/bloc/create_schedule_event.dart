part of 'create_schedule_bloc.dart';

class CreateScheduleEvent extends Equatable {
  const CreateScheduleEvent();

  @override
  List<Object?> get props => [];
}

class CreateSchedule extends CreateScheduleEvent {
  final String name;

  const CreateSchedule(this.name);

  @override
  List<Object> get props => [name];
}

class SelectLocation extends CreateScheduleEvent {
  final String locationName;
  final int locationId;
  final String? scheduleName;
  final String? locationCode;

  const SelectLocation(this.locationName, this.locationId, {this.scheduleName, this.locationCode});

  @override
  List<Object?> get props => [locationName, locationId, scheduleName, locationCode];
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

class CopyDate extends CreateScheduleEvent {
  final ScheduleDate scheduleDate;
  final List<String> dates;

  const CopyDate(this.scheduleDate, this.dates);

  @override
  List<Object> get props => [scheduleDate, dates];
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

class ExpandNode extends CreateScheduleEvent {
  final TreeNode node;

  const ExpandNode(this.node);

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

class Del2Schedule extends CreateScheduleEvent {}

class Sync2Schedule extends CreateScheduleEvent {
  final String scheduleName;

  const Sync2Schedule(this.scheduleName);

  @override
  List<Object> get props => [scheduleName];
}

class ResetCreateSchedule extends CreateScheduleEvent {}

class FetchDetailSchedule extends CreateScheduleEvent {
  final int scheduleId;
  final String locationName;
  final int locationId;
  final String scheduleName;

  const FetchDetailSchedule(this.scheduleId, this.locationName, this.locationId, this.scheduleName);

  @override
  List<Object> get props => [scheduleId, locationName, locationId, scheduleName];
}
