import 'package:dartz/dartz.dart';
import 'package:folder_it/core/errors/failure.dart';
import 'package:folder_it/features/User/data/models/user_model.dart';



abstract class UserRepository {

  Future<Either<Failure,UserModel>> signUp({required String userName,required String email,required String password});
  Future<Either<Failure,UserModel>> login({required String userName,required String password});
}
