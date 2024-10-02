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

class ExpandNode extends HomeEvent {
  final TreeNode node;

  const ExpandNode(this.node);

  @override
  List<Object> get props => [node];
}

class TabChanged extends HomeEvent {  // New event for tab changes
  final int tabIndex;

  const TabChanged(this.tabIndex);

  @override
  List<Object> get props => [tabIndex];
}

class SelectLocation extends HomeEvent {  // New event for selecting a location
  final String locationName;

  const SelectLocation(this.locationName);

  @override
  List<Object> get props => [locationName];
}
