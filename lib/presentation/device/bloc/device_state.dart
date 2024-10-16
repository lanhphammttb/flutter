part of 'device_bloc.dart';

enum DeviceStatus { initial, loading, more, success, failure, failureNews }

class DeviceState extends Equatable {
  final List<Device2> data;
  final DeviceStatus status;
  final NewsStatus newsStatus;
  final String message;
  final int volumePreview;
  final List<String> selectedItems;
  final bool isSelectAll;
  final String filter;
  final String searchQuery;
  final int contentType;
  final List<Content> newsData;
  final Content? selectedContent;

  const DeviceState({
    this.data = const [],
    this.status = DeviceStatus.initial,
    this.newsStatus = NewsStatus.initial,
    this.message = '',
    this.volumePreview = 0,
    this.selectedItems = const [],
    this.isSelectAll = false,
    this.filter = 'all',
    this.searchQuery = '',
    this.contentType = 3,
    this.newsData = const [],
    this.selectedContent,
  });

  DeviceState copyWith({
    List<Device2>? data,
    int? isMoreOrRefresh,
    DeviceStatus? status,
    NewsStatus? newsStatus,
    String? message,
    int? volumePreview,
    List<String>? selectedItems,
    bool? isSelectAll,
    String? filter,
    String? searchQuery,
    int? contentType,
    List<Content>? newsData,
    Content? selectedContent,
  }) {
    return DeviceState(
      data: data ?? this.data,
      status: status ?? this.status,
      newsStatus: newsStatus ?? this.newsStatus,
      message: message ?? this.message,
      volumePreview: volumePreview ?? this.volumePreview,
      selectedItems: selectedItems ?? this.selectedItems,
      isSelectAll: isSelectAll ?? this.isSelectAll,
      filter: filter ?? this.filter,
      searchQuery: searchQuery ?? this.searchQuery,
      contentType: contentType ?? this.contentType,
      newsData: newsData ?? this.newsData,
      selectedContent: selectedContent,
    );
  }

  @override
  List<Object?> get props => [data, status, message, volumePreview, selectedItems, isSelectAll, filter, searchQuery, contentType, newsData, newsStatus, selectedContent];
}
