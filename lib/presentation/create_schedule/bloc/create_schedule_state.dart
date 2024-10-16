part of 'create_schedule_bloc.dart';

enum CreateScheduleStatus { initial, loading, more, success, failure }

enum LocationStatus { initial, loading, more, success, failure }

enum DeviceStatus { initial, loading, more, success, failure }

class CreateScheduleState extends Equatable {
  final SpecificResponse<Schedule>? data;
  final String message;
  final String location;
  final String device;
  final List<DateTime> selectedDates;
  final int locationId;
  final List<int> devicesId;
  final List<DateTime> dates;
  final DateTime? date;
  final List<TreeNode> treeNodes;
  final List<TreeNode> originalTreeNodes;
  final String locationName;
  final List<Device> devices;
  final List<int> selectedDeviceIds;
  final bool isAllSelected;
  final CreateScheduleStatus status;
  final LocationStatus locationStatus;
  final DeviceStatus deviceStatus;
  final String locationSearchQuery;
  final String? deviceSearchQuery;

  const CreateScheduleState({
    this.data,
    this.message = '',
    this.location = '',
    this.device = '',
    this.selectedDates = const [],
    this.locationId = 0,
    this.devicesId = const [],
    this.dates = const [],
    this.date,
    this.treeNodes = const [],
    this.originalTreeNodes = const [],
    this.locationName = '',
    this.devices = const [],
    this.selectedDeviceIds = const [],
    this.isAllSelected = false,
    this.status = CreateScheduleStatus.initial,
    this.locationStatus = LocationStatus.initial,
    this.deviceStatus = DeviceStatus.initial,
    this.locationSearchQuery = '',
    this.deviceSearchQuery,
  });

  CreateScheduleState copyWith({
    SpecificResponse<Schedule>? data,
    String? message,
    String? location,
    String? device,
    List<DateTime>? selectedDates,
    int? locationId,
    List<int>? devicesId,
    List<DateTime>? dates,
    DateTime? date,
    List<TreeNode>? treeNodes,
    List<TreeNode>? originalTreeNodes,
    String? locationName,
    List<Device>? devices,
    List<int>? selectedDeviceIds,
    bool? isAllSelected,
    CreateScheduleStatus? status,
    LocationStatus? locationStatus,
    DeviceStatus? deviceStatus,
    String? locationSearchQuery,
    String? deviceSearchQuery,
  }) {
    return CreateScheduleState(
      data: data ?? this.data,
      message: message ?? this.message,
      location: location ?? this.location,
      device: device ?? this.device,
      selectedDates: selectedDates ?? this.selectedDates,
      locationId: locationId ?? this.locationId,
      devicesId: devicesId ?? this.devicesId,
      dates: dates ?? this.dates,
      date: date ?? this.date,
      treeNodes: treeNodes ?? this.treeNodes,
      originalTreeNodes: originalTreeNodes ?? this.originalTreeNodes,
      locationName: locationName ?? this.locationName,
      devices: devices ?? this.devices,
      selectedDeviceIds: selectedDeviceIds ?? this.selectedDeviceIds,
      isAllSelected: isAllSelected ?? this.isAllSelected,
      status: status ?? this.status,
      locationStatus: locationStatus ?? this.locationStatus,
      deviceStatus: deviceStatus ?? this.deviceStatus,
      locationSearchQuery: locationSearchQuery ?? this.locationSearchQuery,
      deviceSearchQuery: deviceSearchQuery ?? this.deviceSearchQuery,
    );
  }

  @override
  List<Object?> get props => [
        data,
        message,
        location,
        device,
        selectedDates,
        locationId,
        devicesId,
        dates,
        date,
        treeNodes,
        originalTreeNodes,
        locationName,
        devices,
        selectedDeviceIds,
        isAllSelected,
        status,
        locationStatus,
        deviceStatus,
        locationSearchQuery,
        deviceSearchQuery,
      ];
}
