import 'package:dartz/dartz.dart';
import 'package:folder_it/core/errors/failure.dart';
import 'package:folder_it/features/Groups/domain/entities/invite/invite_entity.dart';




abstract class GroupRepository {
  Future<Either<Failure,List<InviteEntity>>> viewMyInvites({required  int userId});
  Future<Either<Failure,bool>>acceptOrRejectInvites({required int userId, required int inviteId , required int groupId,required int inviteStatus });

}
