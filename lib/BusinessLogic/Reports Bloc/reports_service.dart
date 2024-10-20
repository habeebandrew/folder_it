// import 'dart:convert';
// import 'dart:typed_data';
// import 'package:internet_applications/Util/requests_params.dart';
//
// import '../../Data/groups_model.dart';
// import '../../Data/process_model.dart';
// import '../../Util/network_request_helper.dart';
// import '../../Util/api_&_endpoints.dart';
// import '../../Util/enums.dart';
//
// class ReportsService {
//
//
//   Future getReports({required RequestParams requestParams}) async {
//     HelperResponse helperResponse;
//     helperResponse = await NetworkHelpers.getDeleteDataHelper(
//       url: EndPoints.processes,
//       withSessionToken: true,
//       params: requestParams
//     );
//     if (helperResponse.servicesResponse == ServicesResponseStatues.success) {
//       print(helperResponse.response);
//       return welcomeProcessesFromJson(helperResponse.response).data;
//     }
//     return helperResponse.response;
//   }
//
// }
