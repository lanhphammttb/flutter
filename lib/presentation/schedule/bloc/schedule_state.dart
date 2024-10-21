part of 'schedule_bloc.dart';

enum ScheduleStatus { initial, loading, more, success, failure, failureNews }

enum SyncStatus { initial, loading, success, failure }

class ScheduleState extends Equatable {
  final ScheduleStatus status;
  final List<Schedule> schedules;
  final String message;
  final TreeNode? locationNode;
  final List<int> locationIds;
  final SyncStatus syncStatus;
  final int isMoreOrRefresh;

  const ScheduleState({
    this.status = ScheduleStatus.initial,
    this.schedules = const [],
    this.message = '',
    this.locationNode,
    this.locationIds = const [],
    this.syncStatus = SyncStatus.initial,
    this.isMoreOrRefresh = 0,
  });

  ScheduleState copyWith({
    ScheduleStatus? status,
    List<Schedule>? schedules,
    String? message,
    TreeNode? locationNode,
    List<int>? locationIds,
    SyncStatus? syncStatus,
    int? isMoreOrRefresh,
  }) {
    return ScheduleState(
      status: status ?? this.status,
      schedules: schedules ?? this.schedules,
      message: message ?? this.message,
      locationNode: locationNode ?? this.locationNode,
      locationIds: locationIds ?? this.locationIds,
      syncStatus: syncStatus ?? this.syncStatus,
      isMoreOrRefresh: isMoreOrRefresh ?? this.isMoreOrRefresh,
    );
  }

  @override
  List<Object?> get props => [status, schedules, message, locationNode, locationIds, syncStatus, isMoreOrRefresh];
}
