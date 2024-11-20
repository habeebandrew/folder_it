import 'package:dartz/dartz.dart';
import 'package:folder_it/features/Groups/data/datasources/group_local_data_source.dart';
import 'package:folder_it/features/Groups/data/datasources/group_remote_data_source.dart';
import 'package:folder_it/features/Groups/domain/entities/invite_entity.dart';
import 'package:folder_it/features/Groups/domain/repositories/group_repository.dart';
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
  
  @override
  Future<Either<Failure, bool>> acceptOrRejectInvites({required int userId, required int inviteId, required int groupId, required int inviteStatus})async {
   if (await networkInfo.isConnected!) {
      try {
        final acceptOrReject = await remoteDataSource.acceptOrRejectInvite(userId: userId,inviteId: inviteId,groupId: groupId,inviteStatus: inviteStatus);
        return Right(acceptOrReject);
      } on ServerException catch (e) {
        return Left(Failure(errMessage: e.errorModel.errorMessage));
      }
    } else {
      return Left(Failure(errMessage: 'no internet'));
      
    } 
  }


 
  
}
