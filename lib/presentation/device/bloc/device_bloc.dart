import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nttcs/data/models/device2.dart';
import 'package:nttcs/data/models/specific_response.dart';
import 'package:nttcs/data/repositories/auth_repository.dart';
import 'package:nttcs/data/result_type.dart';

part 'device_event.dart';

part 'device_state.dart';

class DeviceBloc extends Bloc<DeviceEvent, DeviceState> {
  final AuthRepository authRepository;

  DeviceBloc(this.authRepository) : super(DeviceInitial()) {
    on<FetchDevices>(_onFetchDevices);
  }

  Future<void> _onFetchDevices(
      FetchDevices event, Emitter<DeviceState> emit) async {
    emit(DeviceLoading());

    final result = await authRepository.getDevice2();

    switch (result) {
      case Success(data: final data):
        emit(DeviceLoaded(data as SpecificResponse<Device2>));
        break;
      case Failure(message: final error):
        emit(DeviceError(error));
        break;
    }
  }
}
