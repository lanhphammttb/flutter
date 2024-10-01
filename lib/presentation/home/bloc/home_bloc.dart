import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nttcs/data/models/location.dart';
import 'package:nttcs/data/models/specific_response.dart';
import 'package:nttcs/data/repositories/auth_repository.dart';
import 'package:nttcs/data/result_type.dart';

part 'home_event.dart';

part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final AuthRepository authRepository;

  HomeBloc(this.authRepository) : super(HomeInitial()) {
    on<FetchLocations>(_onFetchLocations);
    on<SearchTextChanged>(_onSearchTextChanged);
    on<ItemTapped>(_onItemTapped);
  }

  Future<void> _onFetchLocations(
      FetchLocations event, Emitter<HomeState> emit) async {
    emit(LocationsLoading());
    final locations = await authRepository.getLocations();

    switch (locations) {
      case Success(data: final data):
        emit(LocationsSuccess(data as SpecificResponse<Location>));
        break;
      case Failure(message: final error):
        emit(LocationsFailure(error));
        break;
    }
  }

  Future<void> _onSearchTextChanged(
      SearchTextChanged event, Emitter<HomeState> emit) async {
    emit(SearchLoading());
    try {
      // Simulate a search operation with a delay
      await Future.delayed(const Duration(seconds: 1));
      // Example search result
      List<String> results = ["Item 1", "Item 2", "Item 3"]
          .where((item) => item.contains(event.searchText))
          .toList();
      emit(SearchSuccess(results));
    } catch (error) {
      emit(SearchFailure(error.toString()));
    }
  }

  void _onItemTapped(ItemTapped event, Emitter<HomeState> emit) {
    emit(ItemSelected(event.index));
  }
}
