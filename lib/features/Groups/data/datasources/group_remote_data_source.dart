import 'package:flutter/material.dart';
import 'package:folder_it/features/Groups/data/models/invite_model.dart';
import 'package:folder_it/core/databases/api/api_consumer.dart';
import 'package:folder_it/core/databases/api/end_points.dart';
import 'package:folder_it/features/Groups/domain/usecases/accept_or_reject_invite.dart';


class GroupRemoteDataSource {
  final ApiConsumer api;

  GroupRemoteDataSource({required this.api});

  Future<List<InviteModel>> viewMyInvites(
    {required int userId})async{
     
    final response = await api.get(
      "${EndPoints.userRoleGroups}/${EndPoints.viewInvites}$userId",
      headers: {
        'Content-Type':  'application/json',
        'Accept': 'application/json',
      },
      
    );
    //debugPrint(response);
    // var jsonString = userModelToJson(response);
    // debugPrint(jsonString);
    return inviteModelFromJson(response);
  }
  Future<bool> acceptOrRejectInvite(
    {required int userId, required int inviteId , 
    required int groupId,required int inviteStatus})async{
     print(userId);
    final response = await api.post(
      "${EndPoints.userRoleGroups}/${EndPoints.acceptOrRejectInvite}",
      headers: {
        
        
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

  
}