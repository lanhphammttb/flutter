import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nttcs/data/models/res_overview.dart';
import 'package:nttcs/data/models/specific_response.dart';
import 'package:nttcs/data/repositories/auth_repository.dart';
import 'package:nttcs/data/result_type.dart'; // Import AuthRepository
import 'package:equatable/equatable.dart';
part 'overview_event.dart';
part 'overview_state.dart';

class OverviewBloc extends Bloc<OverviewEvent, OverviewState> {
  final AuthRepository authRepository;

  OverviewBloc(this.authRepository) : super(OverviewInitial()) {
    on<FetchOverview>(_onFetchOverview);
  }

  Future<void> _onFetchOverview(
      FetchOverview event, Emitter<OverviewState> emit) async {
    if (state is OverviewLoaded) {
      emit(OverviewUpdating((state as OverviewLoaded).data));
    } else {
      emit(OverviewLoading());
    }

    final result = await authRepository.getOverview();

    switch (result) {
      case Success(data: final data as SpecificResponse<ResOverview>):
        emit(OverviewLoaded(data));
        break;
      case Failure(message: final error):
        emit(OverviewError(error));
        break;
    }
  }
}
