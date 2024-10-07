part of 'news_bloc.dart';

class NewsState extends Equatable {
  const NewsState();

  @override
  List<Object> get props => [];
}

class NewsInitial extends NewsState {}

class NewsLoading extends NewsState {}

class NewsLoaded extends NewsState {
  final SpecificResponse<Content> data;

  NewsLoaded(this.data);

  @override
  List<Object> get props => [data];
}

class NewsError extends NewsState {
  final String message;

  NewsError(this.message);

  @override
  List<Object> get props => [message];
}

