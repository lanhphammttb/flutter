part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  final String locationName;
  final int tabIndex;

  const HomeEvent({this.locationName = '', this.tabIndex = 0});

  @override
  List<Object> get props => [locationName];
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

class TabChanged extends HomeEvent {
  const TabChanged(int index, String? value) : super(tabIndex: index, locationName: value ?? '');

  @override
  List<Object> get props => [tabIndex, locationName];
}

class SelectLocation extends HomeEvent {
  final TreeNode? location;

  const SelectLocation(String value, {this.location})
      : super(locationName: value);

  @override
  List<Object> get props => [locationName, location ?? ''];
}
