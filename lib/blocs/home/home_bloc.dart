import 'package:bloc/bloc.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial());

  @override
  Stream<HomeState> mapEventToState(HomeEvent event) async* {
    if (event is LoadHome) {
      yield HomeLoading();
      await Future.delayed(Duration(seconds: 1));
      yield HomeLoaded();
    }
  }
}
