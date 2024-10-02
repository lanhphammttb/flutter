import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nttcs/data/models/location.dart';
import 'package:nttcs/data/models/specific_response.dart';
import 'package:nttcs/data/models/tree_node.dart';
import 'package:nttcs/data/repositories/auth_repository.dart';
import 'package:nttcs/data/result_type.dart';

part 'home_event.dart';

part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final AuthRepository authRepository;

  HomeBloc(this.authRepository) : super(HomeInitial()) {
    _loadInitialSelectedLocation();
    on<FetchLocations>(_onFetchLocations);
    on<SearchTextChanged>(_onSearchTextChanged);
    on<ExpandNode>(_onExpandNode);
    on<TabChanged>(_onTabChanged);
    on<SelectLocation>(_onSelectLocation);
  }

  void _loadInitialSelectedLocation() async {
    String selectedLocation = await authRepository.getName();
    emit(LocationSelected(selectedLocation));
  }

  Future<void> _onFetchLocations(
      FetchLocations event, Emitter<HomeState> emit) async {
    emit(LocationsLoading());

    try {
      final result = await authRepository.getLocations();

      if (result is Success) {
        // Assuming result.data contains the location items
        final data = result.data as SpecificResponse<Location>;
        List<TreeNode> treeNodes = TreeNode.buildTree(data.items);

        // Keep the original unfiltered list of nodes in state
        emit(LocationsSuccess(treeNodes, originalTreeNodes: treeNodes));
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
        emit(LocationsSuccess(originalNodes, originalTreeNodes: originalNodes));
      } else {
        List<TreeNode> filteredNodes = TreeNode.trimTreeDFS(originalNodes, event.searchText);

        emit(LocationsSuccess(filteredNodes, originalTreeNodes: originalNodes));
      }
    }
  }

  void _onExpandNode(ExpandNode event, Emitter<HomeState> emit) {
    final currentState = state;
    if (currentState is LocationsSuccess) {
      List<TreeNode> updatedNodes = List.from(currentState.treeNodes);
      _toggleExpansion(event.node, updatedNodes);
      emit(LocationsSuccess(updatedNodes, originalTreeNodes: currentState.originalTreeNodes));
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
    emit(TabIndexChanged(event.tabIndex));  // Emit new tab index
  }

  void _onSelectLocation(SelectLocation event, Emitter<HomeState> emit) {
    emit(LocationSelected(event.locationName));
  }
}
