import 'package:dartz/dartz.dart';
import 'package:folder_it/features/User/Data/datasources/user_local_data_source.dart';
import 'package:folder_it/features/User/Data/datasources/user_remote_data_source.dart';
import 'package:folder_it/features/User/data/models/user_model.dart';
import 'package:folder_it/features/User/domain/repositories/user_repository.dart';
import 'package:folder_it/core/connection/network_info.dart';
import 'package:folder_it/core/errors/expentions.dart';
import 'package:folder_it/core/errors/failure.dart';



class UserRepositoryImpl implements UserRepository {
  
  final NetworkInfo networkInfo;
  final UserRemoteDataSource remoteDataSource;
  final UserLocalDataSource localDataSource;

  UserRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });


  @override
  Future<Either<Failure, UserModel>> signUp(
    {required String userName,
     required String email,
     required String password
    }) async{
      print('UserRepositoryImpl$userName$email$password');
     if (await networkInfo.isConnected!) {
      try {
        final remoteUser = await remoteDataSource.signUp(
          userName: userName,
          email: email,
          password: password
        );
        localDataSource.cacheUser(key:'myid' ,userToCache: remoteUser.id);
        localDataSource.cacheUser(key:'token' ,userToCache: remoteUser.token!);
        localDataSource.cacheUser(key:'refreshToken' ,userToCache: remoteUser.refreshToken!);
        return Right(remoteUser);
      } on ServerException catch (e) {
        return Left(Failure(errMessage: e.errorModel.errorMessage));
      }
    }else{
      return Left(Failure(errMessage: 'no internet'));
    }
  }
  
  @override
  Future<Either<Failure, UserModel>> login({required String userName,required String password})async {
    if (await networkInfo.isConnected!) {
      try {
        final remoteUser = await remoteDataSource.login(
          userName:userName ,
          password: password
        );
        localDataSource.cacheUser(key:'myid' ,userToCache: remoteUser.id);
        localDataSource.cacheUser(key:'token' ,userToCache: remoteUser.token);

        localDataSource.cacheUser(key:'refreshToken' ,userToCache: remoteUser.refreshToken!);

        return Right(remoteUser);
      } on ServerException catch (e) {
        return Left(Failure(errMessage: e.errorModel.errorMessage));
      }
    }else{
      return Left(Failure(errMessage: 'no internet'));
    }

  }
}
