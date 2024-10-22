part of 'schedule_bloc.dart';

enum ScheduleStatus { initial, loading, more, success, failure, failureNews }

enum SyncStatus { initial, loading, success, failure }

enum DelStatus { initial, loading, success, failure }

class ScheduleState extends Equatable {
  final ScheduleStatus status;
  final List<Schedule> schedules;
  final String message;
  final TreeNode? locationNode;
  final List<int> locationIds;
  final SyncStatus syncStatus;
  final DelStatus delStatus;
  final int isMoreOrRefresh;
  final String searchQuery;
  final String filter;

  const ScheduleState({
    this.status = ScheduleStatus.initial,
    this.schedules = const [],
    this.message = '',
    this.locationNode,
    this.locationIds = const [],
    this.syncStatus = SyncStatus.initial,
    this.delStatus = DelStatus.initial,
    this.isMoreOrRefresh = 0,
    this.searchQuery = '',
    this.filter = 'all',
  });

  ScheduleState copyWith({
    ScheduleStatus? status,
    List<Schedule>? schedules,
    String? message,
    TreeNode? locationNode,
    List<int>? locationIds,
    SyncStatus? syncStatus,
    DelStatus? delStatus,
    int? isMoreOrRefresh,
    String? searchQuery,
    String? filter,
  }) {
    return ScheduleState(
      status: status ?? this.status,
      schedules: schedules ?? this.schedules,
      message: message ?? this.message,
      locationNode: locationNode ?? this.locationNode,
      locationIds: locationIds ?? this.locationIds,
      syncStatus: syncStatus ?? this.syncStatus,
      delStatus: delStatus ?? this.delStatus,
      isMoreOrRefresh: isMoreOrRefresh ?? this.isMoreOrRefresh,
      searchQuery: searchQuery ?? this.searchQuery,
      filter: filter ?? this.filter,
    );
  }

  @override
  List<Object?> get props => [status, schedules, message, locationNode, locationIds, syncStatus, delStatus, isMoreOrRefresh, searchQuery, filter];
}
