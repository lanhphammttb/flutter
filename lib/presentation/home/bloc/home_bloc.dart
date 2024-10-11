import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nttcs/data/models/location.dart';
import 'package:nttcs/data/models/specific_response.dart';
import 'package:nttcs/data/models/tree_node.dart';
import 'package:nttcs/data/repositories/auth_repository.dart';
import 'package:nttcs/data/result_type.dart';

part 'home_event.dart';

part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final AuthRepository authRepository;

  HomeBloc(this.authRepository) : super(const HomeState()) {
    on<FetchLocations>(_onFetchLocations);
    on<SearchTextChanged>(_onSearchTextChanged);
    on<ExpandNode>(_onExpandNode);
    on<TabChanged>(_onTabChanged);
    on<SelectLocation>(_onSelectLocation);
  }

  Future<void> _onFetchLocations(FetchLocations event, Emitter<HomeState> emit) async {
    emit(state.copyWith(status: HomeStatus.loading));

    try {
      final result = await authRepository.getLocations();
      if (result is Success) {
        final data = result.data as SpecificResponse<Location>;
        List<TreeNode> treeNodes = TreeNode.buildTree(data.items);
        emit(state.copyWith(
          status: HomeStatus.success,
          treeNodes: treeNodes,
          originalTreeNodes: treeNodes,
        ));
      } else if (result is Failure) {
        emit(state.copyWith(status: HomeStatus.failure, error: result.message));
      }
    } catch (error) {
      emit(state.copyWith(status: HomeStatus.failure, error: error.toString()));
    }
  }

  void _onSearchTextChanged(SearchTextChanged event, Emitter<HomeState> emit) {
    if (state.originalTreeNodes != null) {
      final filteredNodes = event.searchText.isEmpty ? state.originalTreeNodes! : TreeNode.trimTreeDFS(state.originalTreeNodes!, event.searchText);
      emit(state.copyWith(treeNodes: filteredNodes));
    }
  }

  void _onExpandNode(ExpandNode event, Emitter<HomeState> emit) {
    List<TreeNode> updatedNodes = List.from(state.treeNodes);
    _toggleExpansion(event.node, updatedNodes);
    emit(state.copyWith(treeNodes: updatedNodes));
  }

  void _toggleExpansion(TreeNode node, List<TreeNode> nodes) {
    for (var n in nodes) {
      if (n == node) {
        n.isExpanded = !n.isExpanded;
        break;
      } else if (n.hasChildren()) {
        _toggleExpansion(node, n.children);
      }
    }
  }

  void _onTabChanged(TabChanged event, Emitter<HomeState> emit) {
    emit(state.copyWith(tabIndex: event.tabIndex));
  }

  void _onSelectLocation(SelectLocation event, Emitter<HomeState> emit) {
    final location = authRepository.getName();
    if (event.locationNode != null) {
      authRepository.saveSelectCode(event.locationNode!.code);
    }
    emit(state.copyWith(locationName: event.locationNode != null ? event.locationNode?.name : location, locationNode: event.locationNode));
  }
}
