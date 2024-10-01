part of 'home_bloc.dart';

class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class FetchLocations extends HomeEvent {}

class SearchTextChanged extends HomeEvent {
  final String searchText;

  const SearchTextChanged(this.searchText);

  @override
  List<Object> get props => [searchText];
}

class ItemTapped extends HomeEvent {
  final int index;

  const ItemTapped(this.index);

  @override
  List<Object> get props => [index];
}