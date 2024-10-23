part of 'schedule_bloc.dart';

class ScheduleEvent extends Equatable {
  const ScheduleEvent();

  @override
  List<Object?> get props => [];
}

class FetchSchedule extends ScheduleEvent {
  final int isMoreOrRefresh; // 0: call first, 1: load more, 2: refresh
  final List<int>? locationIds;
  final TreeNode? locationNode;

  const FetchSchedule(this.isMoreOrRefresh, {this.locationIds, this.locationNode});

  @override
  List<Object?> get props => [isMoreOrRefresh, locationIds, locationNode];
}

class SyncSchedule extends ScheduleEvent {
  final int id;

  const SyncSchedule(this.id);

  @override
  List<Object?> get props => [id];
}

class DelSchedule extends ScheduleEvent {
  final int id;

  const DelSchedule(this.id);

  @override
  List<Object?> get props => [id];
}

class CopySchedule extends ScheduleEvent {
  final int id;

  const CopySchedule(this.id);

  @override
  List<Object?> get props => [id];
}

class UpdateFilter extends ScheduleEvent {
  final String filter;

  const UpdateFilter(this.filter);

  @override
  List<Object?> get props => [filter];
}

class SearchSchedule extends ScheduleEvent {
  final String searchQuery;

  const SearchSchedule(this.searchQuery);

  @override
  List<Object?> get props => [searchQuery];
}