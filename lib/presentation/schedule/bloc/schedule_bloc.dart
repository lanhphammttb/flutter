import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nttcs/data/models/schedule.dart';
import 'package:nttcs/data/models/specific_response.dart';
import 'package:nttcs/data/repositories/auth_repository.dart';
import 'package:nttcs/data/result_type.dart';
part 'schedule_event.dart';
part 'schedule_state.dart';

class ScheduleBloc extends Bloc<ScheduleEvent, ScheduleState> {
  final AuthRepository authRepository;


  ScheduleBloc(this.authRepository) : super(ScheduleInitial()) {
    on<FetchSchedule>(_onFetchSchedule);
  }

  Future<void> _onFetchSchedule(FetchSchedule event, Emitter<ScheduleState> emit) async {
    emit(ScheduleLoading());
      final result = await authRepository.getSchedules();

      switch (result) {
        case Success(data: final data):
          emit(ScheduleLoaded(data as SpecificResponse<Schedule>));
          break;
        case Failure(message: final error):
          emit(ScheduleError(error));
          break;
      }
  }
}