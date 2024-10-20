import 'dart:convert';
import 'dart:io';
import '../../Data/user_model.dart';
import '../../Util/api_&_endpoints.dart';
import '../../Util/enums.dart';
import '../../Util/network_request_helper.dart';

class UserService {
  Future loginUserService(
      {required String email, required String password}) async {
    try {
      HelperResponse helperResponse = await NetworkHelpers.postDataHelper(
        body: jsonEncode({
          "email":email,
          "password":password
        }),
        url: EndPoints.login,
        withSessionToken: false,
      );
      if (helperResponse.servicesResponse == ServicesResponseStatues.success) {
        return welcomeUserFromJson(helperResponse.response);
      }
      return helperResponse.response;
    } on SocketException catch (e) {
      print(e);
      return ServicesResponseStatues.networkError;
    }
  }

  Future getMyProfileService() async {
    HelperResponse helperResponse = await NetworkHelpers.getDeleteDataHelper(
      url: EndPoints.getProfile,
      withSessionToken: true,
    );
    if (helperResponse.servicesResponse == ServicesResponseStatues.success) {
      return welcomeUserFromJson(helperResponse.response);
    }
    if (helperResponse.servicesResponse ==
        ServicesResponseStatues.unauthorized) {
      return ServicesResponseStatues.unauthorized;
    }
    return helperResponse.response;
  }

  Future registerService(
      {required String email,
      required String name,
      required String password}) async {
    try {
      HelperResponse helperResponse = await NetworkHelpers.postDataHelper(
        body: jsonEncode({
          "name":name,
          "email":email,
          "password":password
        }),
        url: EndPoints.register,
        withSessionToken: false,
      );
      if (helperResponse.servicesResponse == ServicesResponseStatues.success) {
        return welcomeUserFromJson(helperResponse.response);
      }
      return helperResponse.response;
    } on SocketException catch (e) {
      print(e);
      return ServicesResponseStatues.networkError;
    }
  }

  Future Logout() async {
    try {
      HelperResponse helperResponse = await NetworkHelpers.postDataHelper(
        url: EndPoints.logout,
        withSessionToken: true,
      );
      print(helperResponse.servicesResponse);
      return helperResponse.servicesResponse;
    } on SocketException catch (e) {
      print('socket');
      return ServicesResponseStatues.networkError;
    }
  }

}
