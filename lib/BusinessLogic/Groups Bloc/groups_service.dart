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
// class GroupsService {
//   Future getGroups() async {
//     HelperResponse helperResponse;
//     helperResponse = await NetworkHelpers.getDeleteDataHelper(
//       url: EndPoints.myGroups,
//       withSessionToken: true,
//     );
//     if (helperResponse.servicesResponse == ServicesResponseStatues.success) {
//       print(helperResponse.response);
//       return welcomeFromJson(helperResponse.response).data;
//     }
//     return helperResponse.response;
//   }
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
//   Future createGroups({required String name}) async {
//     HelperResponse helperResponse = await NetworkHelpers.postDataHelper(
//       body: jsonEncode({
//         "name": name,
//       }),
//       url: EndPoints.createGroup,
//       withSessionToken: true,
//     );
//     return helperResponse.servicesResponse;
//   }
//
//   Future inviteMemberToGroup({
//     required List<String> emails,
//     required int groupId,
//   }) async {
//     HelperResponse helperResponse = await NetworkHelpers.postDataHelper(
//       body: jsonEncode({
//         "user_emails": emails,
//         "group_id": groupId,
//       }),
//       url: EndPoints.inviteMember,
//       withSessionToken: true,
//     );
//     return helperResponse.servicesResponse;
//   }
//
//   Future reserveFiles({
//     // required int groupId,
//     required List<int> reserve,
//     required List<int> unreserve,
//   }) async {
//     HelperResponse helperResponse = await NetworkHelpers.postDataHelper(
//       body: jsonEncode({
//         // "group_id": groupId,
//         "reserved_files": reserve,
//         "dereserved_files": unreserve,
//       }),
//       url: EndPoints.reserveFiles,
//       withSessionToken: true,
//     );
//     if(helperResponse.servicesResponse==ServicesResponseStatues.success
//        && jsonDecode(helperResponse.response)['reserved_files']['success']
//     ) {
//       return helperResponse.servicesResponse;
//     }
//     return  jsonDecode(helperResponse.response)['reserved_files']['message']
//     // +jsonDecode(jsonDecode(helperResponse.response)['reserved_files']['data'])["1"]["title"]
//     ;
//   }
//
//   Future uploadFileToGroup({
//     required String fileName,
//     required int groupId,
//     required Uint8List webFile,
//   }) async
//   {
//     print('upload ');
//     HelperResponse helperResponse = await NetworkHelpers.postDataWithFile(
//       body: {
//         "title": fileName,
//         "group_id": groupId.toString(),
//       },
//       webFile: webFile,
//       filekey: 'url',
//       url: EndPoints.createFile,
//       withSessionToken: true,
//     );
//     return helperResponse.servicesResponse;
//   }
//
//   Future updateFileInGroup({
//     required int fileId,
//     required int groupId,
//     required Uint8List webFile,
//   }) async {
//     print('update ');
//     HelperResponse helperResponse = await NetworkHelpers.postDataWithFile(
//       body: {
//         "group_id": groupId.toString(),
//       },
//       webFile: webFile,
//       filekey: 'url',
//       url: EndPoints.updateFile(fileId.toString()),
//       withSessionToken: true,
//     );
//     return helperResponse.servicesResponse;
//   }
//
//   Future deleteGroup({
//     required int groupId,
//   }) async {
//     HelperResponse helperResponse = await NetworkHelpers.getDeleteDataHelper(
//       // crud: 'DELETE',
//       url: EndPoints.deleteGroup(id: groupId),
//       withSessionToken: true,
//     );
//     if (helperResponse.servicesResponse == ServicesResponseStatues.success) {
//       return ServicesResponseStatues.success;
//     } else {
//       return helperResponse.response;
//     }
//   }
//
//   Future exitGroup({
//     required int groupId,
//   }) async {
//     HelperResponse helperResponse = await NetworkHelpers.postDataHelper(
//       // crud: 'DELETE',
//       body: jsonEncode({"group_id": groupId}),
//       url: EndPoints.leaveGroup,
//       withSessionToken: true,
//     );
//     if (helperResponse.servicesResponse == ServicesResponseStatues.success) {
//       return helperResponse.servicesResponse;
//     }
//     return helperResponse.response;
//   }
//
//   Future removeMemberGroup({
//     required int memberId,
//     required int groupId,
//   }) async {
//     HelperResponse helperResponse = await NetworkHelpers.postDataHelper(
//       body: jsonEncode({
//         "customer_id": memberId,
//         "group_id": groupId,
//       }),
//       url: EndPoints.removeMember,
//       withSessionToken: true,
//     );
//     if (helperResponse.servicesResponse == ServicesResponseStatues.success) {
//       return helperResponse.servicesResponse;
//     }
//     return helperResponse.response;
//   }
//
//   Future shareInvoiceToGroups({
//     required String invoiceId,
//     required List groupsId,
//   }) async {
//     HelperResponse helperResponse = await NetworkHelpers.postDataHelper(
//       body: jsonEncode({
//         "invoice_id": invoiceId,
//         "group_ids": groupsId,
//       }),
//       url: EndPoints.shareInvoice,
//       withSessionToken: true,
//     );
//     if (helperResponse.servicesResponse == ServicesResponseStatues.success) {
//       return helperResponse.servicesResponse;
//     }
//     return helperResponse.response;
//   }
// }
