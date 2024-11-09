import 'package:folder_it/features/User/data/models/user_model.dart';
import 'package:folder_it/core/databases/api/api_consumer.dart';
import 'package:folder_it/core/databases/api/end_points.dart';


class UserRemoteDataSource {
  final ApiConsumer api;

  UserRemoteDataSource({required this.api});

  Future<UserModel> signUp(
    {required String userName,
    required String email, 
    required String password})async{
    
    final response = await api.post(
      "${EndPoints.auth}/${EndPoints.signUp}",
      headers: {
        'Content-Type':  'application/json',
        'Accept': 'application/json'
      },
      data: {
        ApiKey.username : userName,
        ApiKey.email : email,
        ApiKey.password : password
      },
     
    );
     
    print(response);
    return userModelFromJson(response);
  }

  Future<UserModel> login({required String userName,required String password })async{
    final response=await api.post(
      "${EndPoints.auth}/${EndPoints.login}",
      headers: {
        'Content-Type':  'application/json',
        'Accept': 'application/json'
      },
      data:{
        ApiKey.username : userName,
        ApiKey.password : password 
      }, 
    );
    print(response);
    return userModelFromJson(response);
  }
}