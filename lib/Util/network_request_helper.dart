import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:internet_applications/Util/requests_params.dart';
import '../Data/user_model.dart';
import 'api_&_endpoints.dart';
import 'enums.dart';

class HelperResponse {
  String response;
  ServicesResponseStatues servicesResponse;
  HelperResponse({this.response = '', required this.servicesResponse});
}

class NetworkHelpers {
  static http.Client httpClient = http.Client();

  static Future<HelperResponse> postDataHelper({
    required String url,
    body = "",
    required bool withSessionToken,
    String? tokenArgument,
  }) async {
    try {
      Map<String, String> headers;
      headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      };
        final token=await getTokenFromLocalStorage();
      if (withSessionToken) {
        headers['Authorization'] = "Bearer $token";
      }
      if (tokenArgument != null && tokenArgument != "") {
        headers['Authorization'] = "Bearer $tokenArgument";
      }
      var request;
      http.StreamedResponse response;

      request = http.Request('POST', Uri.parse(EndPoints.kMainUrl + url));
      request.headers.addAll(headers);
      request.body = body;
      response = await request.send();

      String streamRes = await response.stream.bytesToString();
      log((EndPoints.kMainUrl + url));
      log(headers.toString());
      log(body);
      log('status code: ${response.statusCode}');
      print(streamRes);
      if (response.statusCode == 200) {
        return HelperResponse(
          response: streamRes,
          servicesResponse: ServicesResponseStatues.success,
        );
      }

      Map<String, dynamic> jsonError = json.decode(streamRes);

      if (response.statusCode == 403) {
        return HelperResponse(
            servicesResponse: ServicesResponseStatues.unauthorized);
      }

      String? error = jsonError["message"];
      return HelperResponse(
        response: error ?? response.reasonPhrase ?? "",
        servicesResponse: ServicesResponseStatues.someThingWrong,
      );
    } on SocketException catch (e) {
      return HelperResponse(
          servicesResponse: ServicesResponseStatues.networkError,
          response: "no internet connection");
    }
  }


  static Future<HelperResponse> postDataWithFile({
    required String url,
    required Map<String, String> body,
    required bool withSessionToken,
    String filekey = "file",
    File? file,
    Uint8List? webFile,
  }) async {
    try {
      Map<String, String> headers;
      headers = {
        'Accept': 'application/json',
      };

      if (withSessionToken) {
        final token = await getTokenFromLocalStorage() ?? "";
        if (token != "") {
          headers['Authorization'] = "Bearer $token";
        }
      }

      var request =
          http.MultipartRequest('POST', Uri.parse(EndPoints.kMainUrl + url));

      request.headers.addAll(headers);

      request.fields.addAll(body);

      log("multi");
      log(webFile.toString());
      log(file.toString());
      log("multi printed");

        if (kIsWeb && webFile != null) {
          List<int> list = webFile.cast();
          request.files.add(http.MultipartFile.fromBytes(filekey, list,
              filename: "myFile.png"));
        } else {
          print('mobile');
          request.files
              .add(await http.MultipartFile.fromPath(filekey, file!.path));
        }
        print('sending image');

      http.StreamedResponse response = await request.send();

      String streamRes = await response.stream.bytesToString();
      log((EndPoints.kMainUrl + url));
      print(headers.toString());
      log('status code: ${response.statusCode}');
      print(streamRes);
      if (response.statusCode == 200) {
        return HelperResponse(
          response: streamRes,
          servicesResponse: ServicesResponseStatues.success,
        );
      }

      Map<String, dynamic> jsonError = json.decode(streamRes);

      if (response.statusCode == 403) {
        return HelperResponse(
            servicesResponse: ServicesResponseStatues.unauthorized);
      }
      String? error = jsonError["message"];
      return HelperResponse(
        response: error ?? response.reasonPhrase ?? "",
        servicesResponse: ServicesResponseStatues.someThingWrong,
      );
    } on SocketException catch (e) {
      return HelperResponse(
          servicesResponse: ServicesResponseStatues.networkError);
    }
  }

  static Future<HelperResponse> getDeleteDataHelperWithCancelToken({
    required String url,
    required RequestParams params,
    required bool withSessionToken,
    String languageHeader = "ar",
    String crud = "GET",
  }) async {
    try {
      httpClient.close();
      httpClient = http.Client();
    } catch (e) {
      print(e);
    }

    try {
      Map<String, String> headers;
      headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

      if (withSessionToken) {
        final token = await getTokenFromLocalStorage() ?? "";
        if (token != "") {
          headers['Authorization'] = "Bearer $token";
        }
      }

      var request;
      print(Uri.https('athek.vroad.co', '/api/$url', params.toJson()));
      request = await httpClient.get(
        headers: headers,
        // crud,
        Uri.https('athek.vroad.co', '/api/$url', params.toJson()),
      );

      String streamRes = request.body;
      if (request.statusCode == 200) {
        return HelperResponse(
          response: streamRes,
          servicesResponse: ServicesResponseStatues.success,
        );
      }
      if (request.statusCode == 400) {
        return HelperResponse(
          response: streamRes,
          servicesResponse: ServicesResponseStatues.wrongData,
        );
      }
      Map<String, dynamic> jsonError = json.decode(streamRes);

      if (request.statusCode == 403) {
        return HelperResponse(
            servicesResponse: ServicesResponseStatues.unauthorized);
      }
      String? error = jsonError["message"];
      return HelperResponse(
        response: error ?? request.reasonPhrase ?? "",
        servicesResponse: ServicesResponseStatues.someThingWrong,
      );
    } on SocketException catch (e) {
      return HelperResponse(
          servicesResponse: ServicesResponseStatues.networkError);
    }
  }

  static Future<HelperResponse> getDeleteDataHelper({
    required String url,
    RequestParams? params,
    required bool withSessionToken,
    String languageHeader = "ar",
    String crud = "GET",
  }) async {
    try {
      Map<String, String> headers;
      headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };
      if (withSessionToken) {
        final token = await getTokenFromLocalStorage() ?? "";
        if (token != "") {
          headers['Authorization'] = "Bearer $token";
        }
        print(token);
      }
      var request;
      if (params != null) {
        log(params.toJson().toString());
        request =await  Dio().get(
             EndPoints.kMainUrl+url, queryParameters:params.toJson(),options: Options(headers: headers));
        var streamRes=request.data;
        if (request.statusCode == 200) {
          return HelperResponse(
            response: jsonEncode(streamRes),
            servicesResponse: ServicesResponseStatues.success,
          );
        }
        if (request.statusCode == 400) {
          return HelperResponse(
            response: streamRes,
            servicesResponse: ServicesResponseStatues.wrongData,
          );
        }
        Map<String, dynamic> jsonError = json.decode(streamRes);

        if (request.statusCode == 403) {
          return HelperResponse(
              servicesResponse: ServicesResponseStatues.unauthorized);
        }
        String? error = jsonError["message"];
        return HelperResponse(
          response: error??"",
          servicesResponse: ServicesResponseStatues.someThingWrong,
        );

      } else {
        request = http.Request(crud, Uri.parse(EndPoints.kMainUrl + url));
        log(Uri.parse(EndPoints.kMainUrl + url).toString());

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      String streamRes = await response.stream.bytesToString();
      print(headers.toString());
      log('status code: ${response.statusCode}');
      print(streamRes);
      if (response.statusCode == 200) {
        return HelperResponse(
          response: streamRes,
          servicesResponse: ServicesResponseStatues.success,
        );
      }
      if (response.statusCode == 400) {
        return HelperResponse(
          response: streamRes,
          servicesResponse: ServicesResponseStatues.wrongData,
        );
      }
      Map<String, dynamic> jsonError = json.decode(streamRes);

      if (response.statusCode == 403) {
        return HelperResponse(
            servicesResponse: ServicesResponseStatues.unauthorized);
      }
      String? error = jsonError["message"];
      return HelperResponse(
        response: error ?? response.reasonPhrase ?? "",
        servicesResponse: ServicesResponseStatues.someThingWrong,
      );
      }} on SocketException catch (e) {
      return HelperResponse(
          servicesResponse: ServicesResponseStatues.networkError);
    }
  }
}
