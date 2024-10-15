part of 'news_bloc.dart';

enum NewsStatus { initial, loading, more,  success, failure }

class NewsState extends Equatable {
  final List<Content> data;
  final int isMoreOrRefresh;
  final NewsStatus status;
  final String? message;
  final String searchQuery;
  final int contentType;

  const NewsState({
    this.data = const [],
    this.isMoreOrRefresh = 0,
    this.status = NewsStatus.initial,
    this.message,
    this.searchQuery = '',
    this.contentType = 3,
  });

  NewsState copyWith({
    List<Content>? data,
    int? isMoreOrRefresh,
    NewsStatus? status,
    String? message,
    int? volumePreview,
    List<String>? selectedItems,
    bool? isSelectAll,
    String? filter,
    String? searchQuery,
    int? contentType,
  }) {
    return NewsState(
      data: data ?? this.data,
      isMoreOrRefresh: isMoreOrRefresh ?? this.isMoreOrRefresh,
      status: status ?? this.status,
      message: message ?? this.message,
      searchQuery: searchQuery ?? this.searchQuery,
      contentType: contentType ?? this.contentType,
    );
  }

  @override
  List<Object?> get props => [data, isMoreOrRefresh, status, message, searchQuery, contentType];
}
