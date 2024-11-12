import 'package:dartz/dartz.dart';
import 'package:folder_it/core/databases/cache/cache_helper.dart';
import 'package:folder_it/features/Groups/data/datasources/group_local_data_source.dart';
import 'package:folder_it/features/Groups/data/datasources/group_remote_data_source.dart';
import 'package:folder_it/features/Groups/data/models/sub_models/group_model.dart';
import 'package:folder_it/features/Groups/domain/entities/invite_entity.dart';
import 'package:folder_it/features/Groups/domain/repositories/group_repository.dart';
import 'package:folder_it/features/User/Data/datasources/user_local_data_source.dart';
import 'package:folder_it/features/User/Data/datasources/user_remote_data_source.dart';
import 'package:folder_it/features/User/data/models/user_model.dart';
import 'package:folder_it/features/User/domain/repositories/user_repository.dart';
import 'package:folder_it/core/connection/network_info.dart';
import 'package:folder_it/core/errors/expentions.dart';
import 'package:folder_it/core/errors/failure.dart';



class GroupRepositoryImpl implements GroupRepository {
  
  final NetworkInfo networkInfo;
  final GroupRemoteDataSource remoteDataSource;
  final GroupLocalDataSource localDataSource;

  GroupRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<InviteEntity>>> viewMyInvites({required int userId})async {
     
     if (await networkInfo.isConnected!) {
      try {
        //userId = CacheHelper().getData(key:'myid');
        final remoteInvites = await remoteDataSource.viewMyInvites(userId:userId );
        
        return Right(remoteInvites);
      } on ServerException catch (e) {
        return Left(Failure(errMessage: e.errorModel.errorMessage));
      }
    } else {
      return Left(Failure(errMessage: 'no internet'));
      
    } 
  
  }


 
  
}
