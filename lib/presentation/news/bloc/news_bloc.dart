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

  NewsBloc(this.authRepository) : super(NewsInitial()) {
    on<FetchNews>(_onFetchNews);
  }

  Future<void> _onFetchNews(FetchNews event, Emitter<NewsState> emit) async {
    emit(NewsLoading());
    final result = await authRepository.getNews();

    switch (result) {
      case Success(data: final data):
        emit(NewsLoaded(data as SpecificResponse<Content>));
        break;
      case Failure(message: final error):
        emit(NewsError(error));
        break;
    }
  }
}