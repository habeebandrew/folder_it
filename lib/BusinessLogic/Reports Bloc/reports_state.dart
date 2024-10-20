part of 'reports_bloc.dart';

@immutable
abstract class ReportsState {}

class ReportsInitial extends ReportsState {}

class ReportsLoading extends ReportsState {}

class ReportsError extends ReportsState {
  ReportsError({required this.error});
  String error;
}

class ReportsLoaded extends ReportsState {
  ReportsLoaded({required this.processes});
  List<ProcessModel> processes;
}
