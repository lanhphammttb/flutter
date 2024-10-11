part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
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
  final int tabIndex;

  const TabChanged(this.tabIndex);

  @override
  List<Object> get props => [tabIndex];
}

class SelectLocation extends HomeEvent {
  final String? locationName;
  final TreeNode? locationNode;

  const SelectLocation({
    this.locationName,
    this.locationNode,
  });

  @override
  List<Object> get props => [locationName!, locationNode!];
}
