import 'package:nttcs/core/constants/constants.dart';
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
  int _currentPage = 1;
  int totalPage = 1;

  NewsBloc(this.authRepository) : super(const NewsState()) {
    on<FetchNews>(_onFetchNews);
    on<SearchNews>(_onSearchDevice);
  }

  Future<void> _onFetchNews(FetchNews event, Emitter<NewsState> emit) async {
    if (event.isMoreOrRefresh == 0) {
      emit(state.copyWith(status: NewsStatus.loading, contentType: event.contentType));
    } else {
      if (_currentPage > totalPage || totalPage == 1) {
        return;
      }
      if (state.status == NewsStatus.success) {
        emit(state.copyWith(isMoreOrRefresh: event.isMoreOrRefresh, status: NewsStatus.more, contentType: state.contentType));
      }
    }

    final result = await authRepository.getNews(
        event.contentType ?? state.contentType,
        event.isMoreOrRefresh == 1 ? _currentPage : 1,
        event.isMoreOrRefresh == 1
            ? 1
            : _currentPage > totalPage
                ? totalPage
                : _currentPage);

    switch (result) {
      case Success(data: final data as SpecificResponse<Content>):
        totalPage = (data.totalRecord + Constants.pageSize - 1) ~/ Constants.pageSize;
        if (event.isMoreOrRefresh == 1 || _currentPage == 1) _currentPage++;
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
