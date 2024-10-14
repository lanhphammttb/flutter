part of 'news_bloc.dart';

enum NewsStatus { initial, loading, more,  success, failure }

class NewsState extends Equatable {
  final List<Content> data;
  final int isMoreOrRefresh;
  final NewsStatus status;
  final String? message;
  final String filter;
  final String searchQuery;

  const NewsState({
    this.data = const [],
    this.isMoreOrRefresh = 0,
    this.status = NewsStatus.initial,
    this.message,
    this.filter = 'all',
    this.searchQuery = '',
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
  }) {
    return NewsState(
      data: data ?? this.data,
      isMoreOrRefresh: isMoreOrRefresh ?? this.isMoreOrRefresh,
      status: status ?? this.status,
      message: message ?? this.message,
      filter: filter ?? this.filter,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object?> get props => [data, isMoreOrRefresh, status, message, filter, searchQuery];
}
