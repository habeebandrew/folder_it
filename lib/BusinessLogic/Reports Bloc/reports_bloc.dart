import 'dart:async';
import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import '../../Data/process_model.dart';
import '../../Util/requests_params.dart';
import 'reports_service.dart';

part 'reports_event.dart';
part 'reports_state.dart';

class ReportsBloc extends Bloc<ReportsEvent, ReportsState> {
  ReportsService reportsService = ReportsService();
  ReportsBloc() : super(ReportsInitial()) {
    on<GetReportEvent>((event, emit) async {
      emit(ReportsLoading());
      final response =
          await reportsService.getReports(requestParams: event.requestParams);
      log(response.toString());
      if (response is List<ProcessModel>) {
        emit(ReportsLoaded(processes: response));
        return;
      } else {
        emit(ReportsError(error: response.toString()));
      }
    });
  }
}
