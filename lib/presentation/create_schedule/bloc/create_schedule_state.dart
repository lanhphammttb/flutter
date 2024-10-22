part of 'create_schedule_bloc.dart';

enum CreateScheduleStatus { initial, loading, more, success, failure }

enum LocationStatus { initial, loading, more, success, failure }

enum DeviceStatus { initial, loading, more, success, failure }

class CreateScheduleState extends Equatable {
  final SpecificResponse<Schedule>? data;
  final String message;
  final String device;
  final List<DateTime> selectedDates;
  final int locationId;
  final List<int> devicesId;
  final List<DateTime> dates;
  final DateTime? date;
  final List<TreeNode> treeNodes;
  final List<TreeNode> originalTreeNodes;
  final List<Device> devices;
  final List<Content> news;
  final List<int> selectedDeviceIds;
  final List<Content> selectedNews;
  final CreateScheduleStatus status;
  final LocationStatus locationStatus;
  final DeviceStatus deviceStatus;
  final NewsStatus newsStatus;
  final String locationSearchQuery;
  final String deviceSearchQuery;
  final bool isSelectAll;
  final String dateString;
  final int contentType;
  final List<SchedulePlaylistTime> schedulePlaylistTimes;
  final List<ScheduleDate> scheduleDates;
  final String locationName;
  final DetailSchedule? detailSchedule;
  final String scheduleName;
  final String locationCode;
  final DelStatus delStatus;
  final SyncStatus syncStatus;

  const CreateScheduleState({
    this.data,
    this.message = '',
    this.device = '',
    this.selectedDates = const [],
    this.selectedNews = const [],
    this.locationId = 0,
    this.devicesId = const [],
    this.dates = const [],
    this.date,
    this.treeNodes = const [],
    this.originalTreeNodes = const [],
    this.devices = const [],
    this.news = const [],
    this.selectedDeviceIds = const [],
    this.status = CreateScheduleStatus.initial,
    this.locationStatus = LocationStatus.initial,
    this.deviceStatus = DeviceStatus.initial,
    this.newsStatus = NewsStatus.initial,
    this.locationSearchQuery = '',
    this.deviceSearchQuery = '',
    this.isSelectAll = false,
    this.dateString = '',
    this.contentType = 3,
    this.schedulePlaylistTimes = const [],
    this.scheduleDates = const [],
    this.locationName = '',
    this.detailSchedule,
    this.scheduleName = '',
    this.locationCode = '',
    this.delStatus = DelStatus.initial,
    this.syncStatus = SyncStatus.initial,
  });

  CreateScheduleState copyWith({
    SpecificResponse<Schedule>? data,
    String? message,
    String? device,
    List<DateTime>? selectedDates,
    List<Content>? selectedNews,
    int? locationId,
    List<int>? devicesId,
    List<DateTime>? dates,
    DateTime? date,
    List<TreeNode>? treeNodes,
    List<TreeNode>? originalTreeNodes,
    List<Device>? devices,
    List<Content>? news,
    List<int>? selectedDeviceIds,
    bool? isAllSelected,
    CreateScheduleStatus? status,
    LocationStatus? locationStatus,
    DeviceStatus? deviceStatus,
    NewsStatus? newsStatus,
    String? locationSearchQuery,
    String? deviceSearchQuery,
    bool? isSelectAll,
    String? dateString,
    int? contentType,
    List<SchedulePlaylistTime>? schedulePlaylistTimes,
    List<ScheduleDate>? scheduleDates,
    String? locationName,
    DetailSchedule? detailSchedule,
    String? scheduleName,
    String? locationCode,
    DelStatus? delStatus,
    SyncStatus? syncStatus,
  }) {
    return CreateScheduleState(
      data: data ?? this.data,
      message: message ?? this.message,
      device: device ?? this.device,
      selectedDates: selectedDates ?? this.selectedDates,
      selectedNews: selectedNews ?? this.selectedNews,
      locationId: locationId ?? this.locationId,
      devicesId: devicesId ?? this.devicesId,
      dates: dates ?? this.dates,
      date: date ?? this.date,
      treeNodes: treeNodes ?? this.treeNodes,
      originalTreeNodes: originalTreeNodes ?? this.originalTreeNodes,
      devices: devices ?? this.devices,
      news: news ?? this.news,
      selectedDeviceIds: selectedDeviceIds ?? this.selectedDeviceIds,
      status: status ?? this.status,
      locationStatus: locationStatus ?? this.locationStatus,
      deviceStatus: deviceStatus ?? this.deviceStatus,
      newsStatus: newsStatus ?? this.newsStatus,
      locationSearchQuery: locationSearchQuery ?? this.locationSearchQuery,
      deviceSearchQuery: deviceSearchQuery ?? this.deviceSearchQuery,
      isSelectAll: isSelectAll ?? this.isSelectAll,
      dateString: dateString ?? this.dateString,
      contentType: contentType ?? this.contentType,
      schedulePlaylistTimes: schedulePlaylistTimes ?? this.schedulePlaylistTimes,
      scheduleDates: scheduleDates ?? this.scheduleDates,
      locationName: locationName ?? this.locationName,
      detailSchedule: detailSchedule ?? this.detailSchedule,
      scheduleName: scheduleName ?? this.scheduleName,
      locationCode: locationCode ?? this.locationCode,
      delStatus: delStatus ?? this.delStatus,
      syncStatus: syncStatus ?? this.syncStatus,
    );
  }

  @override
  List<Object?> get props => [
        data,
        message,
        device,
        selectedDates,
        selectedNews,
        locationId,
        devicesId,
        dates,
        date,
        treeNodes,
        originalTreeNodes,
        devices,
        news,
        selectedDeviceIds,
        status,
        locationStatus,
        deviceStatus,
        newsStatus,
        locationSearchQuery,
        deviceSearchQuery,
        isSelectAll,
        dateString,
        contentType,
        schedulePlaylistTimes,
        scheduleDates,
        locationName,
        detailSchedule,
        scheduleName,
        locationCode,
        delStatus,
        syncStatus,
      ];
}
