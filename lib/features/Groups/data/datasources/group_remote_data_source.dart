import 'dart:convert';

import 'package:folder_it/features/Groups/data/models/invite_model.dart';
import 'package:folder_it/core/databases/api/api_consumer.dart';
import 'package:folder_it/core/databases/api/end_points.dart';

import '../../../../core/databases/cache/cache_helper.dart';


import 'package:http/http.dart' as http;
class GroupRemoteDataSource {
  final ApiConsumer api;

  GroupRemoteDataSource({required this.api});

  Future<List<InviteModel>> viewMyInvites({required int userId, required String token}) async {
    print(userId);

    String mytoken = CacheHelper().getData(key: 'token');
    final url = Uri.parse('http://localhost:8091/user-role-group/view-my-invites?userId=$userId');

    print(mytoken);

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $mytoken',
          'Content-Type': 'application/x-www-form-urlencoded',
          'Accept': 'application/json',
        },
      );

      print(response);

      if (response.statusCode == 200) {
        return inviteModelFromJson(response.body);
      } else {
        throw Exception('Failed to load invites');
      }
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }

  Future<bool> acceptOrRejectInvite(
    {required int userId, required int inviteId , 
    required int groupId,required int inviteStatus , required String token})async{
     print(userId);
    final response = await api.post(
      "${EndPoints.userRoleGroups}/${EndPoints.acceptOrRejectInvite}",
      headers: {
        
        'Authorization': 'Bearer $token'
        //'Accept': 'application/json',
      },
      data: {
        ApiKey.userId:userId.toString(),
        ApiKey.groupId:groupId.toString(),
        ApiKey.inviteId:inviteId.toString(),
        ApiKey.inviteStatus:inviteStatus.toString()
      },
      isFormData: true
    );
    print(response.toString());
    // var jsonString = userModelToJson(response);
    // debugPrint(jsonString);
     if(response=='true'){
     return true;
     }else{
      return false;
     }
    
  }

  Future<InviteModel?> inviteMember(
    {required String userName,
     required int groupId,required String token})async{
     
    final response = await api.post(
      "${EndPoints.userRoleGroups}/${EndPoints.inviteMember}",
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/x-www-form-urlencoded',
        'Accept': 'application/json',
      },
      data: {
        ApiKey.username:userName,
        ApiKey.groupId:groupId.toString()
      },
      isFormData: true
    );
    print(response.toString());
    // var jsonString = userModelToJson(response);
    // debugPrint(jsonString);
    if(response.isNotEmpty){
    return InviteModel.fromJson(json.decode(response));
    }else{
      return null;
    }
    

    
  }
  
}