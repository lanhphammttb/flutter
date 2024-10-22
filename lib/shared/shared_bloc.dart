import 'package:nttcs/core/app_export.dart';
import 'package:nttcs/data/models/location.dart';
import 'package:nttcs/data/models/tree_node.dart';

class SharedLocationCubit extends Cubit<List<Location>> {
  SharedLocationCubit() : super([]);

  void setLocations(List<Location> locations) {
    emit(locations);
  }

  bool hasLocations() {
    return state.isNotEmpty;
  }
}