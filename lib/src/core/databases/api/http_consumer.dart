import 'dart:convert';
import 'package:folder_it/src/core/databases/api/api_consumer.dart';
import 'package:folder_it/src/core/errors/expentions.dart';
import 'package:http/http.dart' as http;

import '../../../../Util/api_&_endpoints.dart';

class HttpConsumer extends ApiConsumer {
  final EndPoints baseUrl;

  HttpConsumer({required this.baseUrl});

//!POST
  @override
  Future post(String path,
      {dynamic data,
        Map<String, dynamic>? queryParameters,
        bool isFormData = false}) async {
    try {
      final response = await http.post(
        Uri.parse('${EndPoints.baserUrl}$path').replace(queryParameters: queryParameters),
        headers: {'Content-Type': isFormData ? 'multipart/form-data' : 'application/json'},
        body: isFormData ? data : jsonEncode(data),
      );
    } on Exception catch (e) {
      handleHttpException(e);
    }
  }

//!GET
  @override
  Future get(String path,
      {Object? data, Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl$path').replace(queryParameters: queryParameters),
      );
      return response.body;
    } on Exception catch (e) {
      handleHttpException(e);
    }
  }

//!DELETE
  @override
  Future delete(String path,
      {Object? data, Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl$path').replace(queryParameters: queryParameters),
        body: data != null ? jsonEncode(data) : null,
      );
      return response.body;
    } on Exception catch (e) {
      handleHttpException(e);
    }
  }

//!PATCH
  @override
  Future patch(String path,
      {dynamic data,
        Map<String, dynamic>? queryParameters,
        bool isFormData = false}) async {
    try {
      final response = await http.patch(
        Uri.parse('$baseUrl$path').replace(queryParameters: queryParameters),
        headers: {'Content-Type': isFormData ? 'multipart/form-data' : 'application/json'},
        body: isFormData ? data : jsonEncode(data),
      );
      return response.body;
    } on Exception catch (e) {
      handleHttpException(e);
    }
  }


}















// import 'dart:convert';
// import 'package:clean_architecture_basics/core/databases/api/api_consumer.dart';
// import 'package:clean_architecture_basics/core/databases/api/end_points.dart';
// import 'package:clean_architecture_basics/core/errors/expentions.dart';
// import 'package:http/http.dart' as http;
//
// class HttpConsumer extends ApiConsumer {
//    String baseUrl;
//
//   HttpConsumer({required this.baseUrl}){
//     baseUrl= EndPoints.baserUrl;
//   }
//
// //!POST
//   @override
//   Future post(String path,
//       {dynamic data,
//       Map<String, dynamic>? queryParameters,
//       bool isFormData = false}) async {
//     try {
//       Uri uri =
//           Uri.parse(baseUrl + path).replace(queryParameters: queryParameters);
//
//       dynamic body;
//       if (isFormData) {
//         var request = http.MultipartRequest('POST', uri);
//         data.forEach((key, value) {
//           request.fields[key] = value.toString();
//         });
//         http.StreamedResponse streamedResponse = await request.send();
//         final response = await http.Response.fromStream(streamedResponse);
//         return jsonDecode(response.body);
//       } else {
//         body = jsonEncode(data);
//       }
//
//       final response = await http.post(
//         uri,
//         headers: {'Content-Type': 'application/json'},
//         body: body,
//       );
//     } on Exception catch (e) {
//       handleHttpException(e);
//     }
//   }
//
// //!GET
//   @override
//   Future get(String path,
//       {Object? data, Map<String, dynamic>? queryParameters}) async {
//     try {
//       Uri uri =
//           Uri.parse(baseUrl + path).replace(queryParameters: queryParameters);
//       final response = await http.get(uri);
//       return response.body;
//     } on Exception catch (e) {
//       handleHttpException(e);
//     }
//   }
//
// //!DELETE
//   @override
//   Future delete(String path,
//       {Object? data, Map<String, dynamic>? queryParameters}) async {
//     try {
//       Uri uri =
//           Uri.parse(baseUrl + path).replace(queryParameters: queryParameters);
//       final response = await http.delete(
//         uri,
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode(data),
//       );
//       return response.body;
//     } on Exception catch (e) {
//       handleHttpException(e);
//     }
//   }
//
// //!PATCH
//   @override
//   Future patch(String path,
//       {dynamic data,
//       Map<String, dynamic>? queryParameters,
//       bool isFormData = false}) async {
//     try {
//       Uri uri =
//           Uri.parse(baseUrl + path).replace(queryParameters: queryParameters);
//
//       dynamic body;
//       if (isFormData) {
//         var request = http.MultipartRequest('PATCH', uri);
//         data.forEach((key, value) {
//           request.fields[key] = value.toString();
//         });
//         http.StreamedResponse streamedResponse = await request.send();
//         final response = await http.Response.fromStream(streamedResponse);
//         return jsonDecode(response.body);
//       } else {
//         body = jsonEncode(data);
//       }
//
//       final response = await http.patch(
//         uri,
//         headers: {'Content-Type': 'application/json'},
//         body: body,
//       );
//       return response.body;
//     } on Exception catch (e) {
//       handleHttpException(e);
//     }
//   }
//
//
// }
