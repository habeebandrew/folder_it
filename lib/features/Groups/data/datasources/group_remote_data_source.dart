import 'package:folder_it/features/Groups/data/models/invite_model.dart';
import 'package:folder_it/core/databases/api/api_consumer.dart';
import 'package:folder_it/core/databases/api/end_points.dart';


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

  
}