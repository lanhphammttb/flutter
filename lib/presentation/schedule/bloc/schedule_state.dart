part of 'schedule_bloc.dart';
class ScheduleState extends Equatable {
  const ScheduleState();

  @override
  List<Object> get props => [];
}

class ScheduleInitial extends ScheduleState {}

class ScheduleLoading extends ScheduleState {}

class ScheduleLoaded extends ScheduleState {
  final SpecificResponse<Schedule> data;

  ScheduleLoaded(this.data);

  @override
  List<Object> get props => [data];
}

class ScheduleError extends ScheduleState {
  final String message;

  ScheduleError(this.message);

  @override
  List<Object> get props => [message];
}
