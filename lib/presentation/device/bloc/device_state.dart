part of 'device_bloc.dart';

enum DeviceStatus { initial, loading, more,  success, failure }

class DeviceState extends Equatable {
  final List<Device2> data;
  final int isMoreOrRefresh;
  final DeviceStatus status;
  final  String message;
  final int volumePreview;
  final List<String> selectedItems;
  final bool isSelectAll;
  final String filter;
  final String searchQuery;

  const DeviceState({
    this.data = const [],
    this.isMoreOrRefresh = 0,
    this.status = DeviceStatus.initial,
    this.message = '',
    this.volumePreview = 0,
    this.selectedItems = const [],
    this.isSelectAll = false,
    this.filter = 'all',
    this.searchQuery = '',
  });

  DeviceState copyWith({
    List<Device2>? data,
    int? isMoreOrRefresh,
    DeviceStatus? status,
    String? message,
    int? volumePreview,
    List<String>? selectedItems,
    bool? isSelectAll,
    String? filter,
    String? searchQuery,
  }) {
    return DeviceState(
      data: data ?? this.data,
      isMoreOrRefresh: isMoreOrRefresh ?? this.isMoreOrRefresh,
      status: status ?? this.status,
      message: message ?? this.message,
      volumePreview: volumePreview ?? this.volumePreview,
      selectedItems: selectedItems ?? this.selectedItems,
      isSelectAll: isSelectAll ?? this.isSelectAll,
      filter: filter ?? this.filter,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object?> get props => [data, isMoreOrRefresh, status, message, volumePreview, selectedItems, isSelectAll, filter, searchQuery];
}

