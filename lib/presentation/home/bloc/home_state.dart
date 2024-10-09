part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  final String locationName;
  final int tabIndex;
  final List<TreeNode> treeNodes;

  const HomeState({this.locationName = '', this.tabIndex = 0, this.treeNodes = const []});

  @override
  List<Object> get props => [locationName, tabIndex, treeNodes];
}

class HomeInitial extends HomeState {
  @override
  List<Object> get props => [];
}

class LocationsLoading extends HomeState {
  const LocationsLoading(String value, int index, List<TreeNode> tree)
      : super(locationName: value, tabIndex: index, treeNodes: tree);

  @override
  List<Object> get props => [locationName, tabIndex, treeNodes];
}

class LocationsSuccess extends HomeState {
  final List<TreeNode> treeNodes;
  final List<TreeNode> originalTreeNodes;

  const LocationsSuccess(String value, int index,
      {required this.treeNodes, required this.originalTreeNodes})
      : super(locationName: value, tabIndex: index, treeNodes: treeNodes);

  @override
  List<Object> get props =>
      [treeNodes, originalTreeNodes, locationName, tabIndex, treeNodes];
}

class LocationsFailure extends HomeState {
  final String error;

  const LocationsFailure(this.error);

  @override
  List<Object> get props => [error];
}

class TabIndexChanged extends HomeState {
  const TabIndexChanged(int index, String value, List<TreeNode> tree)
      : super(tabIndex: index, locationName: value, treeNodes: tree);

  @override
  List<Object> get props => [tabIndex, locationName, treeNodes];
}

class LocationSelected extends HomeState {
  const LocationSelected(String value, int index, List<TreeNode> tree)
      : super(locationName: value, tabIndex: index, treeNodes: tree);

  @override
  List<Object> get props => [locationName, tabIndex, treeNodes];
}
