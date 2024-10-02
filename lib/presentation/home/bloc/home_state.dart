part of 'home_bloc.dart';

class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

class HomeInitial extends HomeState {}

class LocationsLoading extends HomeState {}

class LocationsSuccess extends HomeState {
  final List<TreeNode> treeNodes;
  final List<TreeNode> originalTreeNodes;
  const LocationsSuccess(this.treeNodes, {required this.originalTreeNodes});

  @override
  List<Object> get props => [treeNodes, originalTreeNodes];
}

class LocationsFailure extends HomeState {
  final String error;

  const LocationsFailure(this.error);

  @override
  List<Object> get props => [error];
}

class TabIndexChanged extends HomeState {  // New state for tab index changes
  final int tabIndex;

  const TabIndexChanged(this.tabIndex);

  @override
  List<Object> get props => [tabIndex];
}

class LocationSelected extends HomeState {
  final String locationName;

  const LocationSelected(this.locationName);

  @override
  List<Object> get props => [locationName];
}