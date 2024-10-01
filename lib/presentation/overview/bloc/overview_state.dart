part of 'overview_bloc.dart';

abstract class OverviewState {}

class OverviewInitial extends OverviewState {}

class OverviewLoading extends OverviewState {}

class OverviewUpdating extends OverviewState {
  final SpecificResponse<ResOverview> data;

  OverviewUpdating(this.data);
}

class OverviewLoaded extends OverviewState {
  final SpecificResponse<ResOverview> data;

  OverviewLoaded(this.data);
}

class OverviewError extends OverviewState {
  final String message;

  OverviewError(this.message);
}