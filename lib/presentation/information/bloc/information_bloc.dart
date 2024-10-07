import 'package:nttcs/core/app_export.dart';
import 'package:equatable/equatable.dart';
import 'package:nttcs/data/models/information.dart';
import 'package:nttcs/data/models/specific_status_reponse.dart';
import 'package:nttcs/data/repositories/auth_repository.dart';
import 'package:nttcs/data/result_type.dart';
part 'information_event.dart';
part 'information_state.dart';
class InformationBloc extends Bloc<InformationEvent, InformationState> {
  final AuthRepository authRepository;

  InformationBloc(this.authRepository) : super(InformationInitial()) {
    on<FetchInformation>(_onFetchInformation);
  }

  Future<void> _onFetchInformation(
      FetchInformation event, Emitter<InformationState> emit) async {
    emit(InformationLoading());
    final result = await authRepository.getInformation();

    switch (result) {
      case Success(data: final data):
        emit(InformationLoaded(data as SpecificStatusResponse<Information>));
        break;
      case Failure(message: final error):
        emit(InformationError(error));
        break;
    }
  }
}