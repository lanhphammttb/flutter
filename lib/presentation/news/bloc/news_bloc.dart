import 'package:nttcs/data/models/content.dart';
import 'package:nttcs/data/models/specific_response.dart';
import 'package:nttcs/data/repositories/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nttcs/data/result_type.dart';
part 'news_event.dart';
part 'news_state.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  final AuthRepository authRepository;

  NewsBloc(this.authRepository) : super(const NewsState()) {
    on<FetchNews>(_onFetchNews);
    on<SearchNews>(_onSearchDevice);
  }

  Future<void> _onFetchNews(FetchNews event, Emitter<NewsState> emit) async {
    emit(state.copyWith(status: NewsStatus.loading));
    final result = await authRepository.getNews();

    switch (result) {
      case Success(data: final data as SpecificResponse<Content>):
        final newDevices = event.isMoreOrRefresh == 1 ? state.data + data.items : data.items;
        emit(state.copyWith(status: NewsStatus.success, data: newDevices));
        break;
      case Failure(message: final error):
        emit(state.copyWith(status: NewsStatus.failure, message: error));
        break;
    }
  }

  void _onSearchDevice(SearchNews event, Emitter<NewsState> emit) {
    emit(state.copyWith(searchQuery: event.searchQuery));
  }

}