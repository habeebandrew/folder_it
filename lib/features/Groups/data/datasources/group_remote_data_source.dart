import 'dart:convert';

import 'package:folder_it/features/Groups/data/models/invite_model.dart';
import 'package:folder_it/core/databases/api/api_consumer.dart';
import 'package:folder_it/core/databases/api/end_points.dart';



class GroupRemoteDataSource {
  final ApiConsumer api;

  GroupRemoteDataSource({required this.api});

  Future<List<InviteModel>> viewMyInvites(
    {required int userId,required String token})async{
    final response = await api.get(
      "${EndPoints.userRoleGroups}/${EndPoints.viewInvites}$userId",
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );
    print(response);
    // var jsonString = userModelToJson(response);
    // debugPrint(jsonString);
    return inviteModelFromJson(response);
  }
  
  Future<bool> acceptOrRejectInvite(
    {required int userId, required int inviteId , 
    required int groupId,required int inviteStatus , required String token})async{
    final response = await api.post(
      "${EndPoints.userRoleGroups}/${EndPoints.acceptOrRejectInvite}",
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/x-www-form-urlencoded',
        'Accept': 'application/json',
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