part of 'device_bloc.dart';

enum DeviceStatus { initial, loading, loadingNews, more, moreNews, success, successNews, failure, failureNews }

class DeviceState extends Equatable {
  final List<Device2> data;
  final DeviceStatus status;
  final String message;
  final int volumePreview;
  final List<String> selectedItems;
  final bool isSelectAll;
  final String filter;
  final String searchQuery;
  final int contentType;
  final List<Content> newsData;

  const DeviceState({
    this.data = const [],
    this.status = DeviceStatus.initial,
    this.message = '',
    this.volumePreview = 0,
    this.selectedItems = const [],
    this.isSelectAll = false,
    this.filter = 'all',
    this.searchQuery = '',
    this.contentType = 3,
    this.newsData = const [],
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
    int? contentType,
    List<Content>? newsData,
  }) {
    return DeviceState(
      data: data ?? this.data,
      status: status ?? this.status,
      message: message ?? this.message,
      volumePreview: volumePreview ?? this.volumePreview,
      selectedItems: selectedItems ?? this.selectedItems,
      isSelectAll: isSelectAll ?? this.isSelectAll,
      filter: filter ?? this.filter,
      searchQuery: searchQuery ?? this.searchQuery,
      contentType: contentType ?? this.contentType,
      newsData: newsData ?? this.newsData,
    );
  }

  @override
  List<Object?> get props => [data, status, message, volumePreview, selectedItems, isSelectAll, filter, searchQuery, contentType, newsData];
}
