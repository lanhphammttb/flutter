part of 'home_bloc.dart';
class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

class HomeInitial extends HomeState {}

class SearchLoading extends HomeState {}

class SearchSuccess extends HomeState {
  final List<String> results;

  const SearchSuccess(this.results);

  @override
  List<Object> get props => [results];
}

class SearchFailure extends HomeState {
  final String error;

  const SearchFailure(this.error);

  @override
  List<Object> get props => [error];
}

class ItemSelected extends HomeState {
  final int selectedIndex;

  const ItemSelected(this.selectedIndex);

  @override
  List<Object> get props => [selectedIndex];
}