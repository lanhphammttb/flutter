part of 'information_bloc.dart';

class InformationState extends Equatable {
  const InformationState();

  @override
  List<Object> get props => [];
}

class InformationInitial extends InformationState {}

class InformationLoading extends InformationState {}

class InformationLoaded extends InformationState {
  final SpecificStatusResponse<Information> data;

  InformationLoaded(this.data);

  @override
  List<Object> get props => [data];
}

class InformationError extends InformationState {
  final String message;

  InformationError(this.message);

  @override
  List<Object> get props => [message];
}