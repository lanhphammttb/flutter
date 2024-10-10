import "package:equatable/equatable.dart";
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
  String? selectedLocation; // Thêm biến cục bộ này để lưu selectedLocation

  HomeBloc(this.authRepository) : super(HomeInitial()) {
    on<FetchLocations>(_onFetchLocations);
    on<SearchTextChanged>(_onSearchTextChanged);
    on<ExpandNode>(_onExpandNode);
    on<TabChanged>(_onTabChanged);
    on<SelectLocation>(_onSelectLocation);
  }

  Future<void> _onFetchLocations(
      FetchLocations event, Emitter<HomeState> emit) async {
    emit(LocationsLoading(state.locationName, state.tabIndex, state.treeNodes));

    try {
      final result = await authRepository.getLocations();

      if (result is Success) {
        final data = result.data as SpecificResponse<Location>;
        List<TreeNode> treeNodes = TreeNode.buildTree(data.items);
        emit(LocationsSuccess(state.locationName, state.tabIndex,
            treeNodes: treeNodes, originalTreeNodes: treeNodes));
      } else if (result is Failure) {
        emit(LocationsFailure(result.message));
      }
    } catch (error) {
      emit(LocationsFailure(error.toString()));
    }
  }

  void _onSearchTextChanged(SearchTextChanged event, Emitter<HomeState> emit) {
    final currentState = state;
    if (currentState is LocationsSuccess) {
      final originalNodes = currentState.originalTreeNodes;

      if (event.searchText.isEmpty) {
        emit(LocationsSuccess(state.locationName, state.tabIndex,
            treeNodes: originalNodes, originalTreeNodes: originalNodes));
      } else {
        List<TreeNode> filteredNodes =
            TreeNode.trimTreeDFS(originalNodes, event.searchText);

        emit(LocationsSuccess(state.locationName, state.tabIndex,
            treeNodes: filteredNodes, originalTreeNodes: originalNodes));
      }
    }
  }

  void _onExpandNode(ExpandNode event, Emitter<HomeState> emit) {
    final currentState = state;
    if (currentState is LocationsSuccess) {
      List<TreeNode> updatedNodes = List.from(currentState.treeNodes);
      _toggleExpansion(event.node, updatedNodes);
      emit(LocationsSuccess(state.locationName, state.tabIndex,
          treeNodes: updatedNodes,
          originalTreeNodes: currentState.originalTreeNodes));
    }
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
     selectedLocation = state.locationName.isNotEmpty
        ? state.locationName
        : authRepository.getName();
    emit(TabIndexChanged(event.tabIndex, selectedLocation!, state.treeNodes));
  }

  void _onSelectLocation(SelectLocation event, Emitter<HomeState> emit) {
    if (state.locationName.isNotEmpty) {
      authRepository.saveSelectCode(event.location!.code);
    }

    emit(LocationSelected(event.locationName, state.tabIndex, state.treeNodes));
  }
}
