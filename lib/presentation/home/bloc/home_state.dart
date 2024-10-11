part of 'home_bloc.dart';

enum HomeStatus { initial, loading, success, failure }

class HomeState extends Equatable {
  final String locationName;
  final TreeNode? locationNode;
  final int tabIndex;
  final List<TreeNode> treeNodes;
  final List<TreeNode>? originalTreeNodes;
  final HomeStatus status;
  final String? error;

  const HomeState({
    this.locationName = '',
    this.locationNode,
    this.tabIndex = 0,
    this.treeNodes = const [],
    this.originalTreeNodes,
    this.status = HomeStatus.initial,
    this.error,
  });

  @override
  List<Object?> get props => [locationName, tabIndex, treeNodes, originalTreeNodes, status, error];

  HomeState copyWith({
    String? locationName,
    TreeNode? locationNode,
    int? tabIndex,
    List<TreeNode>? treeNodes,
    List<TreeNode>? originalTreeNodes,
    HomeStatus? status,
    String? error,
  }) {
    return HomeState(
      locationName: locationName ?? this.locationName,
      locationNode: locationNode ?? this.locationNode,
      tabIndex: tabIndex ?? this.tabIndex,
      treeNodes: treeNodes ?? this.treeNodes,
      originalTreeNodes: originalTreeNodes ?? this.originalTreeNodes,
      status: status ?? this.status,
      error: error ?? this.error,
    );
  }
}
