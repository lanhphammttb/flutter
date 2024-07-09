import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<SearchTextChanged>(_onSearchTextChanged);
    on<ItemTapped>(_onItemTapped);
  }

  Future<void> _onSearchTextChanged(SearchTextChanged event, Emitter<HomeState> emit) async {
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

