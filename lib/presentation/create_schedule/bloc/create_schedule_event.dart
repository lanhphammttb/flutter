part of 'create_schedule_bloc.dart';

abstract class CreateScheduleEvent {}

class CreateSchedule extends CreateScheduleEvent {}
class InitializeCreateScheduleEvent extends CreateScheduleEvent {}
class SelectLocationEvent extends CreateScheduleEvent {
  final int location;
  SelectLocationEvent(this.location);
}

class SelectDeviceEvent extends CreateScheduleEvent {
  final List<Device> devices;
  SelectDeviceEvent(this.devices);
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
