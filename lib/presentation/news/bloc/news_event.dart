part of 'news_bloc.dart';

sealed class NewsEvent extends Equatable {
  const NewsEvent();

  @override
  List<Object?> get props => [];
}

class FetchNews extends NewsEvent {
  final int isMoreOrRefresh; // 0: call first, 1: load more, 2: refresh
  final int? contentType;
  final String? code;
  const FetchNews(this.isMoreOrRefresh, {this.contentType, this.code});

  @override
  List<Object?> get props => [isMoreOrRefresh, contentType, code];
}

class SearchNews extends NewsEvent {
  final String searchQuery;

  const SearchNews(this.searchQuery);

  @override
  List<Object> get props => [searchQuery];
}
