part of 'news_bloc.dart';
sealed class NewsEvent extends Equatable {
  const NewsEvent();

  @override
  List<Object> get props => [];
}

class FetchNews extends NewsEvent {
  final int isMoreOrRefresh; // 0: call first, 1: load more, 2: refresh

  const FetchNews(this.isMoreOrRefresh);

  @override
  List<Object> get props => [isMoreOrRefresh];
}

class SearchNews extends NewsEvent {
  final String searchQuery;
  const SearchNews(this.searchQuery);

  @override
  List<Object> get props => [searchQuery];
}