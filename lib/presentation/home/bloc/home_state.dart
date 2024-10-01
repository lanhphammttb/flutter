part of 'home_bloc.dart';
class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

class LocationsLoading extends HomeState {}

class LocationsSuccess extends HomeState {
  final SpecificResponse<Location> locations;

  const LocationsSuccess(this.locations);

  @override
  List<Object> get props => [locations];
}

class LocationsFailure extends HomeState {
  final String error;

  const LocationsFailure(this.error);

  @override
  List<Object> get props => [error];
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